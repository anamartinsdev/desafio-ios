import UIKit.UINavigationController

protocol ErrorRouterProtocol {
    func navigateToPrevious()
}

final class ErrorRouter: ErrorRouterProtocol {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToPrevious() {
        navigationController.popViewController(animated: true)
    }
}
