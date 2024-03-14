import UIKit.UINavigationController

final class AuthCPFFactory {
    static func create(navigationController: UINavigationController) -> UIViewController {
        let router = AuthCPFRouter(navigationController: navigationController)
        let viewModel = AuthCPFViewModel(router: router)
        return AuthCPFViewController(viewModel: viewModel)
    }
}
