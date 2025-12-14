
import Foundation

class AccessTokenManager {
    
    static let shared = AccessTokenManager()
    
    private let keychainService = "access-token"
    private let keychainAccount = "user"
    
    private var cachedToken: String? // 메모리 캐싱 (Keychain 직접 접근 최소화)

    private init() {
        // 앱 실행 시 한 번만 Keychain에서 가져와서 캐싱
        cachedToken = KeychainHelper.standard.read(
            service: keychainService,
            account: keychainAccount
        )
    }

    // Access Token 가져오기 (Keychain -> 메모리 캐싱 활용)
    func getToken() -> String? {
        return cachedToken
    }

    // Access Token 저장 (Keychain + 캐싱 동기화)
    func saveToken(_ token: String) {
        cachedToken = token // 메모리에 먼저 저장
        KeychainHelper.standard.save(token, service: keychainService, account: keychainAccount)
    }

    // Access Token 삭제 (로그아웃 시 사용)
    func clearToken() {
        cachedToken = nil // 메모리 캐싱 제거
        KeychainHelper.standard.delete(service: keychainService, account: keychainAccount)
    }
}
