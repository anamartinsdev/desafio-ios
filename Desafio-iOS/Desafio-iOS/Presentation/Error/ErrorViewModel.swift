protocol ErrorViewModelProtocol {
    func onTapBack()
}

final class ErrorViewModel: ErrorViewModelProtocol {
    private var router: ErrorRouterProtocol
    
    init(router: ErrorRouterProtocol) {
        self.router = router
    }
    
    func onTapBack() {
        router.navigateToPrevious()
    }
}
