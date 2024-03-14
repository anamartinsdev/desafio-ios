protocol AuthCPFViewModelProtocol {
    func onTapNext(data: String)
    func onTapBack()
}

final class AuthCPFViewModel: AuthCPFViewModelProtocol {
    private var router: AuthCPFRouterProtocol
    
    init(router: AuthCPFRouterProtocol) {
        self.router = router
    }
    
    func onTapNext(data: String) {
        let keychainManager = KeychainManager()
        do {
            try keychainManager.saveDocument(cpf: data)
            router.navigateToPassword()
        } catch {
            
        }
    }

    func onTapBack() {
        router.navigateToPrevious()
    }
}
