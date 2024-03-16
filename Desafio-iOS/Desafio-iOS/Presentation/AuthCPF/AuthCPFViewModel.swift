import CoraSecurity

protocol AuthCPFViewModelProtocol {
    func onTapNext(data: String)
    func onTapBack()
}

final class AuthCPFViewModel: AuthCPFViewModelProtocol {
    private var router: AuthCPFRouterProtocol
    private let keychainManager: KeychainManagerProtocol
    
    init(router: AuthCPFRouterProtocol,
         keychainManager: KeychainManagerProtocol = KeychainManager()) {
        self.router = router
        self.keychainManager = keychainManager
    }
    
    func onTapNext(data: String) {
        let keychainManager = KeychainManager()
        do {
            try? keychainManager.save(
                data,
                for: .cpf
            )
            router.navigateToPassword()
        }
    }

    func onTapBack() {
        router.navigateToPrevious()
    }
}
