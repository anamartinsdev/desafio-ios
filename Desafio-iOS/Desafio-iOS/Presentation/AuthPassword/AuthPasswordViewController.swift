import UIKit.UIViewController

final class AuthPasswordViewController: UIViewController {
    private let viewModel: AuthPasswordViewModelProtocol
    private let contentView: AuthPasswordViewProtocol
    
    init(viewModel: AuthPasswordViewModelProtocol,
         contentView: AuthPasswordViewProtocol = AuthPasswordView()) {
        self.viewModel = viewModel
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    func setupView() {
        contentView.actionNext = { [weak self] text in
            self?.viewModel.onTapNext(data: text)
        }
        contentView.actionBack = { [weak self] in
            self?.viewModel.onTapBack()
        }
    }
}
