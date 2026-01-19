
import Foundation
import Alamofire

/// API 에러를 Domain 에러로 변환하는 매퍼
struct ErrorMapper {
    
    /// Alamofire 에러를 AppError로 변환
    static func mapToAppError(_ error: Error) -> AppError {
        if let afError = error as? AFError {
            return mapAFError(afError)
        }
        
        if let urlError = error as? URLError {
            return mapURLError(urlError)
        }
        
        // NSError 처리
        if let nsError = error as NSError? {
            if nsError.domain == "TokenError" {
                return .tokenNotFound
            }
            return .unknown(nsError.localizedDescription)
        }
        
        return .unknown(error.localizedDescription)
    }
    
    /// Alamofire 에러 매핑
    private static func mapAFError(_ error: AFError) -> AppError {
        switch error {
        case .responseValidationFailed(let reason):
            if case .unacceptableStatusCode(let code) = reason {
                return mapHTTPStatusCode(code)
            }
            return .networkError(error.localizedDescription)
            
        case .responseSerializationFailed:
            return .networkError("응답 파싱에 실패했습니다.")
            
        case .requestAdaptationFailed:
            return .networkError("요청 생성에 실패했습니다.")
            
        case .sessionTaskFailed(let error):
            if let urlError = error as? URLError {
                return mapURLError(urlError)
            }
            return .networkError(error.localizedDescription)
            
        default:
            return .networkError(error.localizedDescription)
        }
    }
    
    /// HTTP 상태 코드 매핑
    private static func mapHTTPStatusCode(_ code: Int) -> AppError {
        switch code {
        case 401:
            return .unauthorized
        case 404:
            return .notFound("요청한 리소스")
        case 400...499:
            return .validationError("클라이언트 오류 (코드: \(code))")
        case 500...599:
            return .serverError(code, "서버 오류가 발생했습니다")
        default:
            return .serverError(code, "알 수 없는 오류")
        }
    }
    
    /// URLError 매핑
    private static func mapURLError(_ error: URLError) -> AppError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .networkError("인터넷 연결을 확인해주세요")
        case .timedOut:
            return .networkError("요청 시간이 초과되었습니다")
        case .cannotFindHost, .cannotConnectToHost:
            return .networkError("서버에 연결할 수 없습니다")
        default:
            return .networkError(error.localizedDescription)
        }
    }
}
