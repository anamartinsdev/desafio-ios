protocol AuthPasswordViewModelProtocol {
    func onTapNext(data: String)
}

final class AuthPasswordViewModel: AuthPasswordViewModelProtocol {
    private let router: AuthPasswordRouterProtocol
    private let repository: AuthRepositoryProtocol
    
    init(router: AuthPasswordRouterProtocol,
         repository: AuthRepositoryProtocol = AuthRepository()) {
        self.router = router
        self.repository = repository
    }
    
    func onTapNext(data: String) {
        let keychainManager = KeychainManager()
        do {
            try keychainManager.savePass(password: data)
            repository.authenticate { [weak self] result, token in
                if result {
                    self?.router.navigateToStatement()
                } else {
                    
                }
            }
        } catch {
            
        }
    }
}
