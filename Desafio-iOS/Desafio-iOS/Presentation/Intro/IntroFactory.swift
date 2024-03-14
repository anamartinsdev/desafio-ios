import UIKit.UINavigationController

final class IntroFactory {
    static func create(navigationController: UINavigationController) -> UIViewController {
        let router = IntroRouter(navigationController: navigationController)
        let viewModel = IntroViewModel(router: router)
        return IntroViewController(viewModel: viewModel)
    }
}
