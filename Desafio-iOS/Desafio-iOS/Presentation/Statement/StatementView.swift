import UIKit
import DesignSystem

protocol StatementViewProtocol: UIView {
    var tableView: UITableView { get }
    var actionBack: (() -> Void)? { get set }
    var actionReload: (() -> Void)? { get set }
    func showLoadingState()
    func showErrorState(with message: String)
    func showDataState()
}

final class StatementView: UIView, StatementViewProtocol {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(StatementTransactionTableViewCell.self, forCellReuseIdentifier: "StatementTransactionTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var customNavigationBar: CoraNavigationBar = {
        let navBar = CoraNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        return navBar
    }()
    
    private lazy var coraTab: CoraTab = {
        let tab = CoraTab(
            items: ["Tudo", "Entrada", "Saída", "Futuro"],
            icon: UIImage(systemName: "ic_filter")
        )
        tab.translatesAutoresizingMaskIntoConstraints = false
        
        return tab
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Não foi possível carregar suas transações."
        label.isHidden = true
        return label
    }()
    
    private lazy var actionButton: CoraButton = {
        let button  = CoraButton(
            title: "Voltar e Tentar Novamente",
            image: nil,
            style: .primary
        )
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var actionBack: (() -> Void)?
    var actionReload: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTapReload() {
        actionReload?()
    }
    
    // MARK: - State Handlers
    func showLoadingState() {
        customNavigationBar.isHidden = false
        coraTab.isHidden = false
        tableView.isHidden = true
        errorLabel.isHidden = true
        actionButton.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func showErrorState(with message: String) {
        customNavigationBar.isHidden = true
        coraTab.isHidden = true
        tableView.isHidden = true
        loadingView.isHidden = true
        loadingView.stopAnimating()
        errorLabel.isHidden = false
        errorLabel.text = message
        actionButton.isHidden = false
    }
    
    func showDataState() {
        customNavigationBar.isHidden = false
        coraTab.isHidden = false
        loadingView.isHidden = true
        loadingView.stopAnimating()
        errorLabel.isHidden = true
        actionButton.isHidden = true
        tableView.isHidden = false
    }
}

extension StatementView: ViewCode {
    func buildViewHierarchy() {
        addSubview(customNavigationBar)
        addSubview(coraTab)
        addSubview(tableView)
        addSubview(loadingView)
        addSubview(errorLabel)
        addSubview(actionButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            coraTab.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 8),
            coraTab.leftAnchor.constraint(equalTo: leftAnchor),
            coraTab.heightAnchor.constraint(equalToConstant: 44),
            coraTab.rightAnchor.constraint(equalTo: rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: coraTab.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            errorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 64),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            actionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .white
        actionButton.addTarget(
            self,
            action: #selector(onTapReload),
            for: .touchUpInside
        )
        
        customNavigationBar.configure(
            title: "Extrato",
            showBackButton: true,
            backAction: { [weak self] in
                self?.actionBack?()
            },
            actionImage: UIImage(named: "ic_download"),
            action: { [weak self] in
                self?.actionBack?()
            }
        )
    }
}
