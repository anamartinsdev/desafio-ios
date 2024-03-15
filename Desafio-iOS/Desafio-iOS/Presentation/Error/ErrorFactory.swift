import UIKit.UINavigationController

final class ErrorFactory {
    static func create(navigationController: UINavigationController) -> UIViewController {
        let router = ErrorRouter(navigationController: navigationController)
        let viewModel = ErrorViewModel(router: router)
        return ErrorViewController(viewModel: viewModel)
    }
}
