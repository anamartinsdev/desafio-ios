import UIKit.UINavigationController

final class StatementDetailFactory {
    static func create(navigationController: UINavigationController, and id: String) -> UIViewController {
        let router = StatementDetailRouter(navigationController: navigationController)
        let viewModel = StatementDetailViewModel(
            router: router,
            id: id
        )
        return StatementDetailViewController(viewModel: viewModel)
    }
}
