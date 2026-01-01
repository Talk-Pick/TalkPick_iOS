
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
        if let accessToken = KeychainHelper.standard.read(service: "access-token", account: "user") {
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
    
    // 액세스 토큰 갱신
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let accessToken = AccessTokenManager.shared.getToken() else {
            completion(false)
            return
        }
        
        let url = APIConstants.tokenRefresh.path
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url,
                   method: .post,
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
}
