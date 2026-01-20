
import Foundation

/// Domain 레이어에서 사용하는 토큰 관리 프로토콜
/// Data 레이어의 구체적인 구현에 의존하지 않도록 추상화
protocol TokenProviderProtocol {
    /// Access Token을 가져옵니다
    func getAccessToken() -> String?
    
    /// Access Token을 저장합니다
    func saveAccessToken(_ token: String)
    
    /// Access Token을 삭제합니다
    func clearAccessToken()
}