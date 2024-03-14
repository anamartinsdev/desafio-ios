import UIKit.UINavigationController

protocol AuthPasswordRouterProtocol {
    func navigateToStatement()
}

final class AuthPasswordRouter: AuthPasswordRouterProtocol {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToStatement() {
//        let authViewController = AuthPasswordFactory.create(navigationController: navigationController)
//        navigationController.pushViewController(authViewController, animated: true)
    }
}
