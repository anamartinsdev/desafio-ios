import Foundation

protocol StatementViewModelProtocol {
    var onStateChanged: ((ViewState<[TransactionSection]>) -> Void)? { get set }
    func loadTransactions()
    func onTapBack()
    func selectTransaction(transactionId: String)
    func allTransactions() -> [TransactionSection]
    func transactionsFilteredByEntryType(_ entryType: TransactionEntryType) -> [TransactionSection]
    func transactionsFilteredByFutureDates() -> [TransactionSection]
}

final class StatementViewModel: StatementViewModelProtocol {
    var onStateChanged: ((ViewState<[TransactionSection]>) -> Void)?

    private let repository: StatementRepositoryProtocol
    private let router: StatementRouterProtocol
    private var allTransactionSections: [TransactionSection] = []
    
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
                    self?.allTransactionSections = result
                    self?.onStateChanged?(.data(result))
                case .failure(let error):
                    self?.onStateChanged?(.error(error.localizedDescription))
                }
            }
        }
    }
    
    func onTapBack() {
        router.navigateToPrevious()
    }
    
    func selectTransaction(transactionId: String) {
        router.navigateToTransactionDetail(transactionId: transactionId)
    }
    
    func allTransactions() -> [TransactionSection] {
        allTransactionSections
    }
    
    func transactionsFilteredByEntryType(_ entryType: TransactionEntryType) -> [TransactionSection] {
        return allTransactionSections.map { section in
            let filteredTransactions = section.transactions.filter { $0.entry == entryType }
            return TransactionSection(date: section.date, transactions: filteredTransactions)
        }
    }
    
    func transactionsFilteredByFutureDates() -> [TransactionSection] {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return allTransactionSections.filter { section in
            guard let sectionDate = dateFormatter.date(from: section.date) else { return false }
            return sectionDate > currentDate
        }
    }
}
