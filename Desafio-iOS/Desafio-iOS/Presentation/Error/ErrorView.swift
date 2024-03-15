import UIKit
import DesignSystem

protocol ErrorViewProtocol: UIView {
    var actionBack: (() -> Void)? { get set }
}

final class ErrorView: UIView, ErrorViewProtocol {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let actionButton: CoraButton = {
        let button  = CoraButton(
            title: "Voltar e Tentar Novamente",
            image: nil,
            style: .primary
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var actionBack: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func onTapBack() {
        actionBack?()
    }
}

extension ErrorView: ViewCode {
    func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(actionButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            actionButton.heightAnchor.constraint(equalToConstant: 64),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            actionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .white
        titleLabel.text = "Ocorreu um erro"
        messageLabel.text = "Nossa plataforma encontrou um erro inesperado. Por favor, tente novamente."
        
        actionButton.addTarget(self, action: #selector(onTapBack), for: .touchUpInside)
    }
}
