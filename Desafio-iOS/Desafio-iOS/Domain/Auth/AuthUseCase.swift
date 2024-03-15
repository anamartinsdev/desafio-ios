import CoraSecurity

protocol AuthUseCaseProtocol {
    func getCredentials() -> (String, String)
}

final class AuthUseCase: AuthUseCaseProtocol {
    
    private let keychainManager: KeychainManagerProtocol
    
    init(keychainManager: KeychainManagerProtocol = KeychainManager()) {
        self.keychainManager = keychainManager
    }
    
    func getCredentials() -> (String, String) {
        if let cpf = keychainManager.retrieve(for: .cpf),
           let password = keychainManager.retrieve(for: .password) {
            return (cpf, password)
        } else {
            return ("", "")
        }
    }
}
