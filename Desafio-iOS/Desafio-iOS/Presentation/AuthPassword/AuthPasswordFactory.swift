import UIKit.UINavigationController

final class AuthPasswordFactory {
    static func create(navigationController: UINavigationController) -> UIViewController {
        let router = AuthPasswordRouter(navigationController: navigationController)
        let viewModel = AuthPasswordViewModel(router: router)
        return AuthPasswordViewController(viewModel: viewModel)
    }
}
