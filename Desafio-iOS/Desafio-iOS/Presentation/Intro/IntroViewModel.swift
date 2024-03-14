protocol IntroViewModelProtocol {
    func onTapSignin()
    func onTapSignup()
}

final class IntroViewModel: IntroViewModelProtocol {
    private var router: IntroRouterProtocol
    
    init(router: IntroRouterProtocol) {
        self.router = router
    }
    
    func onTapSignup() {
        router.navigateToSignup()
    }
    
    func onTapSignin() {
        router.navigateToSignin()
    }
}
