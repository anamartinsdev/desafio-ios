import CoraSecurity

protocol AuthPasswordViewModelProtocol {
    func onTapNext(data: String)
}

final class AuthPasswordViewModel: AuthPasswordViewModelProtocol {
    private let router: AuthPasswordRouterProtocol
    private let repository: AuthRepositoryProtocol
    private let keychainManager: KeychainManagerProtocol
    
    init(router: AuthPasswordRouterProtocol,
         repository: AuthRepositoryProtocol = AuthRepository(),
         keychainManager: KeychainManagerProtocol = KeychainManager()) {
        self.router = router
        self.repository = repository
        self.keychainManager = keychainManager
    }
    
    func onTapNext(data: String) {
        do {
            try? keychainManager.save(data, for: .password)
            repository.authenticate { [weak self] result, token in
                if let token = token {
                    try? self?.keychainManager.save(token, for: .token)
                }
                if result {
                    self?.router.navigateToStatement()
                } else {
                    self?.router.navigateToErrorScreen()
                }
            }
        }
    }
}
