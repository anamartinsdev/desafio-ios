import UIKit.UINavigationController

protocol StatementDetailRouterProtocol {
    func navigateToPrevious()
}

final class StatementDetailRouter: StatementDetailRouterProtocol {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToPrevious() {
        navigationController.popViewController(animated: true)
    }
}
