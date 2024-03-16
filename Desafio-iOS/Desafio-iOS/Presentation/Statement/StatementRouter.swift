import UIKit.UINavigationController

protocol StatementRouterProtocol {
    func navigateToPrevious()
    func navigateToTransactionDetail(transactionId: String)
}

final class StatementRouter: StatementRouterProtocol {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToPrevious() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToTransactionDetail(transactionId: String) {
        let viewController = StatementDetailFactory.create(navigationController: navigationController, and: transactionId)
        navigationController.pushViewController(viewController, animated: true)
    }
}
