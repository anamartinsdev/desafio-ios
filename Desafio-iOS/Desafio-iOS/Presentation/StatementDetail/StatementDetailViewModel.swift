import Foundation

protocol StatementDetailViewModelProtocol {
    var onStateChange: ((ViewState<TransactionDetail>?) -> Void)? { get set }
    func onTapBack()
    func getTransactionDetail()
    func navigateToErrorScreen()
}

final class StatementDetailViewModel: StatementDetailViewModelProtocol {
    private let router: StatementDetailRouterProtocol
    private var repository: TransactionDetailRepositoryProtocol
    
    private let transactionId: String
    var onStateChange: ((ViewState<TransactionDetail>?) -> Void)?
    
    var state: ViewState<TransactionDetail>? {
        didSet {
            onStateChange?(state)
        }
    }
    
    init(router: StatementDetailRouterProtocol,
         repository: TransactionDetailRepositoryProtocol = TransactionDetailRepository(),
         id: String) {
        self.router = router
        self.repository = repository
        self.transactionId = id
        self.repository.transactionId = id
    }
    
    func onTapBack() {
        router.navigateToPrevious()
    }
    
    func getTransactionDetail() {
        state = .loading
        
        repository.fetchDetails { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transactionDetail):
                    self?.state = .data(transactionDetail)
                case .failure(let error):
                    self?.state = .error(error.localizedDescription)
                }
            }
        }
    }
    
    func navigateToErrorScreen() {
        router.navigateToErrorScreen()
    }
}

