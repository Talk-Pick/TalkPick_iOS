
import RxSwift
import Foundation

/// API 통신을 위한 프로토콜
/// Domain 레이어에서 사용하므로 Data 레이어의 구체 타입에 의존하지 않음
protocol APIServiceProtocol {
    // GET 요청 (토큰 없음)
    func get<T: Codable>(of type: T.Type, url: String) -> Single<T>
    
    // GET 요청 (토큰 포함)
    func getWithToken<T: Codable>(of type: T.Type, url: String, accessToken: String) -> Single<T>
    
    // GET 요청 (토큰 & 파라미터 포함)
    func getWithTokenAndParams<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?, accessToken: String) -> Single<T>
    
    // POST 요청
    func post<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?) -> Single<T>
    
    // POST 요청 (토큰 포함)
    func postWithToken<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?, accessToken: String) -> Single<T>
    
    // POST 요청 (토큰 & 파라미터 포함)
    func postWithTokenAndParams<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?, accessToken: String) -> Single<T>
    
    // DELETE 요청 (토큰 포함)
    func deleteWithToken<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?, accessToken: String) -> Single<T>
    
    // PATCH 요청 (토큰 포함)
    func patchWithToken<T: Codable>(of type: T.Type, url: String, parameters: [String: Any]?, accessToken: String) -> Single<T>
}
