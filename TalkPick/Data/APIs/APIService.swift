
import Alamofire
import RxSwift
import Foundation

struct APIService: APIServiceProtocol {
    static let shared = APIService()
    
    // AuthInterceptor를 사용하는 Session (토큰이 필요한 요청용)
    private let session: Session = {
        let interceptor = AuthInterceptor()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        return Session(configuration: configuration, interceptor: interceptor)
    }()

    // 토큰이 필요 없는 요청용 (기본 AF 사용)
    private func request<T: Codable>(
        of type: T.Type,
        url: String,
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
    
    // 토큰이 필요한 요청용 (AuthInterceptor 사용)
    private func requestWithToken<T: Codable>(
        of type: T.Type,
        url: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding? = nil,
        headers: HTTPHeaders? = nil
    ) -> Single<T> {
        return Single<T>.create { single in
            let finalEncoding: ParameterEncoding = encoding ?? (method == .get ? URLEncoding.default : JSONEncoding.default)
            
            // 기본 헤더 설정
            var finalHeaders = headers ?? HTTPHeaders()
            if finalHeaders["Accept"] == nil {
                finalHeaders["Accept"] = "application/json"
            }
            if method != .get && finalHeaders["Content-Type"] == nil {
                finalHeaders["Content-Type"] = "application/json"
            }
            
            // AuthInterceptor가 자동으로 토큰을 추가하고 401 시 재시도 처리
            let request = session.request(url,
                                         method: method,
                                         parameters: parameters,
                                         encoding: finalEncoding,
                                         headers: finalHeaders)
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
    func get<T: Codable>(of type: T.Type, url: String) -> Single<T> {
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        return request(of: type, url: url, method: .get, headers: headers)
    }
    
    // GET 요청 (토큰 포함) - AuthInterceptor가 자동으로 토큰 추가 및 401 재시도 처리
    func getWithToken<T: Codable>(of type: T.Type, url: String, accessToken: String) -> Single<T> {
        return requestWithToken(of: type, url: url, method: .get)
    }
    
    // GET 요청 (토큰 & 파라미터 포함) - AuthInterceptor가 자동으로 토큰 추가 및 401 재시도 처리
    func getWithTokenAndParams<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        return requestWithToken(of: type, url: url, method: .get, parameters: parameters)
    }

    // POST 요청
    func post<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?) -> Single<T> {
        let headers: HTTPHeaders = ["Accept": "*/*"]
        return request(of: type, url: url, method: .post, parameters: parameters, headers: headers)
    }
    
    // POST 요청 (토큰 포함) - AuthInterceptor가 자동으로 토큰 추가 및 401 재시도 처리
    func postWithToken<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        return requestWithToken(of: type, url: url, method: .post, parameters: parameters)
    }
    
    // POST 요청 (토큰 & 파라미터 포함) - AuthInterceptor가 자동으로 토큰 추가 및 401 재시도 처리
    func postWithTokenAndParams<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        return requestWithToken(of: type, url: url, method: .post, parameters: parameters, encoding: URLEncoding.default)
    }
    
    // DELETE 요청 (토큰 포함) - AuthInterceptor가 자동으로 토큰 추가 및 401 재시도 처리
    func deleteWithToken<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        return requestWithToken(of: type, url: url, method: .delete, parameters: parameters)
    }

    // PATCH 요청 (토큰 포함) - AuthInterceptor가 자동으로 토큰 추가 및 401 재시도 처리
    func patchWithToken<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?, accessToken: String) -> Single<T> {
        return requestWithToken(of: type, url: url, method: .patch, parameters: parameters)
    }
}
