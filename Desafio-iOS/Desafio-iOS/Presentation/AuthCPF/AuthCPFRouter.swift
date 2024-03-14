import UIKit.UINavigationController

protocol AuthCPFRouterProtocol {
    func navigateToPassword()
    func navigateToPrevious()
}

final class AuthCPFRouter: AuthCPFRouterProtocol {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToPassword() {
        let authViewController = AuthPasswordFactory.create(navigationController: navigationController)
        navigationController.pushViewController(authViewController, animated: true)
    }
    
    func navigateToPrevious() {
        navigationController.popViewController(animated: true)
    }
}
