import UIKit.UINavigationController

protocol AuthPasswordRouterProtocol {
    func navigateToPrevious()
    func navigateToStatement()
}

final class AuthPasswordRouter: AuthPasswordRouterProtocol {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToPrevious() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToStatement() {
        let viewController = StatementFactory.create(navigationController: navigationController)
        navigationController.pushViewController(viewController, animated: true)
    }
}
