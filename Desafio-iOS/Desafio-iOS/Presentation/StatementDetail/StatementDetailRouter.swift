import UIKit.UINavigationController

protocol StatementDetailRouterProtocol {
    func navigateToPrevious()
    func navigateToErrorScreen()
}

final class StatementDetailRouter: StatementDetailRouterProtocol {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToPrevious() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToErrorScreen() {
        let viewController = ErrorFactory.create(navigationController: navigationController)
        navigationController.pushViewController(viewController, animated: true)
    }
}
