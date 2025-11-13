//
//  APIService.swift
//  TalkPick
//
//  Created by jaegu park on 11/3/25.
//

import Alamofire
import RxSwift

struct APIService {
    
    static let shared = APIService()

    private func request<T: Codable>(
        of type: T.Type,
        url: URLConvertible,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding? = nil,
        headers: HTTPHeaders? = nil
    ) -> Single<T> {
        return Single<T>.create { single in
            let finalEncoding: ParameterEncoding = encoding ?? (method == .get ? URLEncoding.default : JSONEncoding.default)
            let request = AF.request(url,
                                     method: method,
                                     parameters: parameters,
                                     encoding: finalEncoding,
                                     headers: headers)
                .responseDecodable(of: type) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    // GET 요청 (토큰 없음)
    func get<T: Codable>(of type: T.Type, url: URLConvertible) -> Single<T> {
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        return request(of: type, url: url, method: .get, headers: headers)
    }
    
    // GET 요청 (토큰 포함)
    func getWithToken<T: Codable>(of type: T.Type, url: URLConvertible, accessToken: String) -> Single<T> {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        return request(of: type, url: url, method: .get, headers: headers)
    }
    
    // GET 요청 (토큰 & 파라미터 포함)
    func getWithTokenAndParams<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        return request(of: type, url: url, method: .get, parameters: parameters, headers: headers)
    }

    // POST 요청
    func post<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String: Any]?) -> Single<T> {
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        return request(of: type, url: url, method: .post, parameters: parameters, headers: headers)
    }
    
    // POST 요청 (토큰 포함)
    func postWithToken<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        return request(of: type, url: url, method: .post, parameters: parameters, headers: headers)
    }
    
    func postWithTokenAndParams<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        return request(of: type, url: url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
    }
    
    // DELETE 요청 (토큰 포함)
    func deleteWithToken<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        return request(of: type, url: url, method: .delete, parameters: parameters, headers: headers)
    }

    // PATCH 요청 (토큰 포함)
    func patchWithToken<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        return request(of: type, url: url, method: .patch, parameters: parameters, headers: headers)
    }
    
    // PUT 요청 (토큰 포함)
    func putWithToken<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        return request(of: type, url: url, method: .put, parameters: parameters, headers: headers)
    }
}
