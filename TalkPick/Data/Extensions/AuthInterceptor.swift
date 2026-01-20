
import Alamofire
import Foundation

class AuthInterceptor: RequestInterceptor {
    
    // 토큰 저장 및 갱신 관련 프로퍼티
    private let lock = NSLock() 
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    // 요청에 액세스 토큰 추가
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        // AccessTokenManager를 통해 토큰 가져오기 (캐싱된 토큰 사용)
        if let accessToken = AccessTokenManager.shared.getToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }
    
    // 401 에러 발생 시 처리
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                isRefreshing = true
                
                refreshToken { [weak self] success in
                    guard let self = self else { return }
                    
                    self.lock.lock()
                    defer { self.lock.unlock() }
                    
                    self.isRefreshing = false
                    
                    let retryResults: RetryResult = success ? .retry : .doNotRetryWithError(error)
                    self.requestsToRetry.forEach { $0(retryResults) }
                    self.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
    
    // 액세스 토큰 갱신 (외부에서도 사용 가능)
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        refreshToken(completion: completion)
    }
    
    // 액세스 토큰 갱신 (내부용)
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        // 쿠키에서 리프레시 토큰 추출
        guard let refreshToken = getRefreshTokenFromCookie() else {
            completion(false)
            return
        }
        
        let url = APIConstants.tokenRefresh.path
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Cookie": "refreshToken=\(refreshToken)"
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Token.self) { response in
            switch response.result {
            case .success(let data):
                let newAccessToken = data.accessToken
                
                AccessTokenManager.shared.saveToken(newAccessToken)
                
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    // 쿠키에서 리프레시 토큰 추출
    private func getRefreshTokenFromCookie() -> String? {
        guard let url = URL(string: APIConstants.baseURL) else {
            return nil
        }
        
        // HTTPCookieStorage에서 쿠키 가져오기
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            // refreshToken 쿠키 찾기
            for cookie in cookies {
                if cookie.name == "refreshToken" {
                    return cookie.value
                }
            }
        }
        
        // 특정 URL에 쿠키가 없으면 모든 쿠키에서 찾기 (도메인이 다른 경우 대비)
        if let allCookies = HTTPCookieStorage.shared.cookies {
            for cookie in allCookies {
                if cookie.name == "refreshToken" {
                    return cookie.value
                }
            }
        }
        
        return nil
    }
}
