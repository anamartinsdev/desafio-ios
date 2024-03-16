import UIKit
import DesignSystem

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
        contentView.tableView.estimatedRowHeight = 100
        contentView.tableView.rowHeight = 100
        
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        contentView.actionBack = { [weak self] in
            self?.viewModel.onTapBack()
        }
        
        contentView.actionReload = { [weak self] in
            self?.viewModel.loadTransactions()
        }
        
        contentView.actionChangeTab = { [weak self] index in
            self?.updateTransactions(for: index)
        }
        
        contentView.actionDownload = { [weak self] in
            guard let snapshot = self?.contentView.takeSnapshot() else { return }
            self?.shareSnapshot(image: snapshot)
        }
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
    
    private func updateTransactions(for index: Int) {
        switch index {
        case 0:
            transactionSections = viewModel.allTransactions()
        case 1:
            transactionSections = viewModel.transactionsFilteredByEntryType(.credit)
        case 2:
            transactionSections = viewModel.transactionsFilteredByEntryType(.debit)
        case 3:
            transactionSections = viewModel.transactionsFilteredByFutureDates()
        default:
            return
        }
        removeEmptySections()
        contentView.tableView.reloadData()
    }
    
    private func removeEmptySections() {
        transactionSections = transactionSections.filter { !$0.transactions.isEmpty }
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "F0F4F8")

        let headerLabel = UILabel()
        headerLabel.text = transactionSections[section].date
        headerLabel.textColor = UIColor(hex: "6B7076")
        headerLabel.applyRegularFont(size: 14)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(
                equalTo: headerView.leadingAnchor,
                constant: 16
            ),
            headerLabel.trailingAnchor.constraint(
                equalTo: headerView.trailingAnchor,
                constant: -16
            ),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        return headerView
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "StatementTransactionTableViewCell",
            for: indexPath
        ) as! StatementTransactionTableViewCell
        cell.selectionStyle = .none
        let transaction = transactionSections[indexPath.section].transactions[indexPath.row]
        cell.configure(with: transaction)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
}

extension StatementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTransaction = transactionSections[indexPath.section].transactions[indexPath.row]
        viewModel.selectTransaction(transactionId: selectedTransaction.id)
    }
}
