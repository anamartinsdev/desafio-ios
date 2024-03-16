@testable import CoraSecurity

final class KeychainManagerMock: KeychainManagerProtocol {
    var storedCredentials = [CredentialKey: String]()
    
    func save(_ data: String, for key: CredentialKey) throws {
        storedCredentials[key] = data
    }
    
    func retrieve(for key: CredentialKey) -> String? {
        return storedCredentials[key]
    }
    
    func delete(for key: CredentialKey) throws {
        storedCredentials[key] = nil
    }
}
