import UIKit.UIViewController

final class IntroViewController: UIViewController {
    private let viewModel: IntroViewModelProtocol
    private let contentView: IntroViewProtocol

    init(viewModel: IntroViewModelProtocol,
         contentView: IntroViewProtocol = IntroView()) {
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
        contentView.actionSignUp = { [weak self] in
            self?.viewModel.onTapSignup()
        }
        
        contentView.actionSignIn = { [weak self] in
            self?.viewModel.onTapSignin()
        }
    }
}
