
import Foundation

/// TokenProviderProtocol의 Data 레이어 구현체
class TokenProvider: TokenProviderProtocol {
    static let shared = TokenProvider()
    
    private let keychainService = "access-token"
    private let keychainAccount = "user"
    private var cachedToken: String?
    
    private init() {
        // 앱 실행 시 한 번만 Keychain에서 가져와서 캐싱
        cachedToken = KeychainHelper.standard.read(
            service: keychainService,
            account: keychainAccount
        )
    }
    
    func getAccessToken() -> String? {
        // 먼저 메모리 캐시 확인
        if let cached = cachedToken {
            return cached
        }
        
        // Keychain에서 직접 읽기
        let token = KeychainHelper.standard.read(service: keychainService, account: keychainAccount)
        cachedToken = token
        return token
    }
    
    func saveAccessToken(_ token: String) {
        cachedToken = token
        KeychainHelper.standard.save(token, service: keychainService, account: keychainAccount)
    }
    
    func clearAccessToken() {
        cachedToken = nil
        KeychainHelper.standard.delete(service: keychainService, account: keychainAccount)
    }
}