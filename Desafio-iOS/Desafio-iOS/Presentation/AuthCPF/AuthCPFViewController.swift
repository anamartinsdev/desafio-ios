import UIKit.UIViewController
import DesignSystem

final class AuthCPFViewController: UIViewController {
    private let viewModel: AuthCPFViewModelProtocol
    private let contentView: AuthCPFViewProtocol
    
    init(viewModel: AuthCPFViewModelProtocol,
         contentView: AuthCPFViewProtocol = AuthCPFView()) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        setupCustomNavigation()
    }
}

private extension AuthCPFViewController {
    func setupView() {
        contentView.actionNext = { [weak self] text in
            self?.viewModel.onTapNext(data: text)
        }
        contentView.actionBack = { [weak self] in
            self?.viewModel.onTapBack()
        }
    }
    
    func setupCustomNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
