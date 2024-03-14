import UIKit.UINavigationController

protocol IntroRouterProtocol {
    func navigateToSignup()
    func navigateToSignin()
}

final class IntroRouter: IntroRouterProtocol {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToSignup() {
        
    }
    
    func navigateToSignin() {
        let authViewController = AuthCPFFactory.create(navigationController: navigationController)
        navigationController.pushViewController(authViewController, animated: true)
    }
}

