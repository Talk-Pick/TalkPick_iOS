//
//  AuthInterceptor.swift
//  TalkPick
//
//  Created by jaegu park on 11/26/25.
//

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
    
    // 리프레시 토큰을 사용하여 액세스 토큰 갱신
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = RefreshTokenManager.shared.getToken() else {
            print(" 리프레시 토큰 없음")
            completion(false)
            return
        }
        
        print(" 리프레시 토큰 요청: \(refreshToken)")
        
        let url = APIConstants.tokenRefresh.path
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Content-Type": "application/json"
        ]
        let parameters: [String: String] = [
            "refreshToken": refreshToken
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Token.self) { response in
            switch response.result {
            case .success(let data):
                let newAccessToken = data.accessToken
                
                print("새로운 액세스 토큰 저장 전: \(newAccessToken)")
                
                KeychainHelper.standard.save(newAccessToken, service: "access-token", account: "user")
                
                print("저장된 액세스 토큰: \(KeychainHelper.standard.read(service: "access-token", account: "user") ?? "없음")")
                
                completion(true)
            case .failure(let error):
                completion(false)
            }
        }
    }
}
