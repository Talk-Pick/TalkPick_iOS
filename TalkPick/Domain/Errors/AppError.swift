
import Foundation

/// 애플리케이션의 도메인 에러 타입
enum AppError: Error, Equatable {
    // 토큰 관련 에러
    case tokenNotFound
    case tokenExpired
    case unauthorized
    
    // 네트워크 관련 에러
    case networkError(String)
    case serverError(Int, String)
    
    // 비즈니스 로직 에러
    case validationError(String)
    case notFound(String)
    
    // 기타 에러
    case unknown(String)
    
    /// 사용자에게 표시할 메시지
    var userMessage: String {
        switch self {
        case .tokenNotFound:
            return "토큰이 존재하지 않습니다.\n다시 시도해주세요."
        case .tokenExpired:
            return "세션이 만료되었습니다.\n다시 로그인해주세요."
        case .unauthorized:
            return "인증에 실패했습니다.\n다시 시도해주세요."
        case .networkError(let message):
            return "\(message)\n다시 시도해주세요."
        case .serverError(_, let message):
            return "\(message)\n다시 시도해주세요."
        case .validationError(let message):
            return "\(message)\n다시 시도해주세요."
        case .notFound(let message):
            return "\(message)을(를) 찾을 수 없습니다.\n다시 시도해주세요."
        case .unknown(let message):
            return "\(message)\n다시 시도해주세요."
        }
    }
    
    /// 에러 코드
    var code: Int {
        switch self {
        case .tokenNotFound:
            return 401
        case .tokenExpired:
            return 401
        case .unauthorized:
            return 401
        case .networkError:
            return -1001
        case .serverError(let code, _):
            return code
        case .validationError:
            return 400
        case .notFound:
            return 404
        case .unknown:
            return -1
        }
    }
}