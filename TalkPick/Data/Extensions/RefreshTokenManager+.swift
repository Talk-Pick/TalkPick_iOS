
import Foundation

class RefreshTokenManager {
    static let shared = RefreshTokenManager()

    private let keychainService = "refresh-token"
    private let keychainAccount = "user"
    
    private var cachedToken: String?

    private init() {
        cachedToken = KeychainHelper.standard.read(
            service: keychainService,
            account: keychainAccount
        )
    }

    func getToken() -> String? {
        return cachedToken
    }

    func saveToken(_ token: String) {
        cachedToken = token
        KeychainHelper.standard.save(token, service: keychainService, account: keychainAccount)
    }

    func clearToken() {
        cachedToken = nil
        KeychainHelper.standard.delete(service: keychainService, account: keychainAccount)
    }
}
