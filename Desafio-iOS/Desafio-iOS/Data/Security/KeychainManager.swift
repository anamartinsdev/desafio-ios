import Foundation
import Security

protocol KeychainManagerProtocol {
    func saveDocument(cpf: String) throws
    func savePass(password: String) throws
    func getDocument() -> String?
    func getPass() -> String?
    func deleteCredentials() throws
}

final class KeychainManager: KeychainManagerProtocol {
    func saveDocument(cpf: String) throws {
        let cpfData = Data(cpf.utf8)
        
        let cpfQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                   kSecAttrAccount: "userCPF",
                                     kSecValueData: cpfData]
        
        var status = SecItemUpdate(cpfQuery as CFDictionary, [kSecValueData: cpfData] as CFDictionary)
        if status == errSecItemNotFound {
            status = SecItemAdd(cpfQuery as CFDictionary, nil)
        }
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    func savePass(password: String) throws {
        let passwordData = Data(password.utf8)
        let passwordQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                        kSecAttrAccount: "userPassword",
                                          kSecValueData: passwordData]
        var status = SecItemUpdate(passwordQuery as CFDictionary, [kSecValueData: passwordData] as CFDictionary)
        status = SecItemUpdate(passwordQuery as CFDictionary, [kSecValueData: passwordData] as CFDictionary)
        if status == errSecItemNotFound {
            status = SecItemAdd(passwordQuery as CFDictionary, nil)
        }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    func getDocument() -> String? {
        return retrieveData(forAccount: "userCPF")
    }
    
    func getPass() -> String? {
        return retrieveData(forAccount: "userPassword")
    }
    
    func deleteCredentials() throws {
        let cpfQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                   kSecAttrAccount: "userCPF"]
        let statusCPF = SecItemDelete(cpfQuery as CFDictionary)
        
        let passwordQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                        kSecAttrAccount: "userPassword"]
        let statusPassword = SecItemDelete(passwordQuery as CFDictionary)
        
        guard statusCPF == errSecSuccess || statusCPF == errSecItemNotFound,
              statusPassword == errSecSuccess || statusPassword == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: statusCPF)
        }
    }
    
    private func retrieveData(forAccount account: String) -> String? {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrAccount: account,
                                 kSecReturnData: kCFBooleanTrue!,
                                 kSecMatchLimit: kSecMatchLimitOne]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else { return nil }
        guard let data = item as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
}
