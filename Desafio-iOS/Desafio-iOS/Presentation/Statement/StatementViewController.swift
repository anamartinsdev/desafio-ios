import UIKit

final class StatementViewController: UIViewController {
    private var viewModel: StatementViewModelProtocol
    private var contentView: StatementViewProtocol
    private var transactionSections: [TransactionSection] = []

    init(viewModel: StatementViewModelProtocol,
         contentView: StatementViewProtocol = StatementView()) {
        self.viewModel = viewModel
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
        setupView()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = contentView
    }

    private func setupView() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            DispatchQueue.main.async {
                self?.updateView(for: state)
            }
        }
        viewModel.loadTransactions()
    }

    private func updateView(for state: ViewState<[TransactionSection]>) {
        switch state {
        case .loading:
            contentView.showLoadingState()
        case .error(let message):
            contentView.showErrorState(with: message)
        case .data(let transactions):
            self.transactionSections = transactions
            contentView.showDataState()
            contentView.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension StatementViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionSections[section].transactions.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return transactionSections[section].date
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatementTransactionTableViewCell", for: indexPath) as! StatementTransactionTableViewCell
        
        let transaction = transactionSections[indexPath.section].transactions[indexPath.row]
        cell.configure(with: transaction)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StatementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTransaction = transactionSections[indexPath.section].transactions[indexPath.row]
        viewModel.selectTransaction(transactionId: selectedTransaction.id)
    }
}
