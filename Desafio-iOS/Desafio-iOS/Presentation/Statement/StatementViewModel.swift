import Foundation

protocol StatementViewModelProtocol {
    var onStateChanged: ((ViewState<[TransactionSection]>) -> Void)? { get set }
    func loadTransactions()
    func selectTransaction(transactionId: String)
}

final class StatementViewModel: StatementViewModelProtocol {
    var onStateChanged: ((ViewState<[TransactionSection]>) -> Void)?

    private let repository: StatementRepositoryProtocol
    private let router: StatementRouterProtocol
    
    init(repository: StatementRepositoryProtocol = StatementRepository(),
         router: StatementRouterProtocol) {
        self.repository = repository
        self.router = router
    }

    func loadTransactions() {
        self.onStateChanged?(.loading)
        repository.fetchStatement { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    let result = StatementTransactionMapper().map(response: transactions)
                    self?.onStateChanged?(.data(result))
                case .failure(let error):
                    self?.onStateChanged?(.error(error.localizedDescription))
                }
            }
        }
    }
    
    func selectTransaction(transactionId: String) {
        router.navigateToTransactionDetail(transactionId: transactionId)
    }
}
