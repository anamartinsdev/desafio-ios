import UIKit
import DesignSystem

protocol StatementViewProtocol: UIView {
    var tableView: UITableView { get }
    func showLoadingState()
    func showErrorState(with message: String)
    func showDataState()
}

final class StatementView: UIView, StatementViewProtocol {
    // Componentes da view
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Não foi possível carregar suas transações."
        label.isHidden = true
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State Handlers
    func showLoadingState() {
        tableView.isHidden = true
        errorLabel.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func showErrorState(with message: String) {
        tableView.isHidden = true
        loadingView.isHidden = true
        loadingView.stopAnimating()
        errorLabel.isHidden = false
        errorLabel.text = message
    }
    
    func showDataState() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
        errorLabel.isHidden = true
        tableView.isHidden = false
    }
}

extension StatementView: ViewCode {
    func buildViewHierarchy() {
        addSubview(tableView)
        addSubview(loadingView)
        addSubview(errorLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            errorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .white
    }
}
