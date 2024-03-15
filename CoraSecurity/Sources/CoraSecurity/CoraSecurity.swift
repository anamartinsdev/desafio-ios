import Foundation
import Security

public enum CredentialKey: String {
    case cpf = "userCPF"
    case password = "userPassword"
    case token = "userToken"
}

public enum KeychainError: Error {
    case unhandledError(status: OSStatus)
    case badData
}

public protocol KeychainManagerProtocol {
    func save(_ data: String, for key: CredentialKey) throws
    func retrieve(for key: CredentialKey) -> String?
    func delete(for key: CredentialKey) throws
}

public final class KeychainManager: KeychainManagerProtocol {
    public init() {}

    public func save(_ data: String, for key: CredentialKey) throws {
        guard let data = data.data(using: .utf8) else { throw KeychainError.badData }

        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: key.rawValue,
                                      kSecValueData: data]

        var status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecDuplicateItem {
            let updateQuery: [CFString: Any] = [kSecValueData: data]
            status = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
        }

        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }

    public func retrieve(for key: CredentialKey) -> String? {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: key.rawValue,
                                      kSecReturnData: kCFBooleanTrue!,
                                      kSecMatchLimit: kSecMatchLimitOne]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data else { return nil }

        return String(data: data, encoding: .utf8)
    }

    public func delete(for key: CredentialKey) throws {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: key.rawValue]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}
