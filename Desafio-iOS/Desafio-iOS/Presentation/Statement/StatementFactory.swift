import UIKit.UINavigationController

final class StatementFactory {
    static func create(navigationController: UINavigationController) -> UIViewController {
        let router = StatementRouter(navigationController: navigationController)
        let viewModel = StatementViewModel(router: router)
        return StatementViewController(viewModel: viewModel)
    }
}
