import UIKit.UIViewController
import DesignSystem

final class StatementDetailViewController: UIViewController {
    private var viewModel: StatementDetailViewModelProtocol
    private let contentView: StatementDetailViewProtocol
    
    init(viewModel: StatementDetailViewModelProtocol,
         contentView: StatementDetailViewProtocol = StatementDetailView()) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.getTransactionDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCustomNavigation()
    }
}

private extension StatementDetailViewController {
    func setupView() {
        contentView.actionBack = { [weak self] in
            self?.viewModel.onTapBack()
        }
        contentView.actionShare = { [weak self] in
            guard let snapshot = self?.contentView.takeSnapshot() else { return }
            self?.shareSnapshot(image: snapshot)
        }
    }
    
    func setupCustomNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            switch state {
            case .loading:
                break
            case .data(let transactionDetail):
                let dataSections = TransactionDetailMapper.map(transactionDetail)

                self?.contentView.configure(with: dataSections)
                break
            case .error(let errorMessage):
                print(errorMessage)
                break
            case .none:
                break
            }
        }
    }
}

private extension StatementDetailViewController {
    func shareSnapshot(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
}
