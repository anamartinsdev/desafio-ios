import UIKit.UIView
import DesignSystem

protocol AuthCPFViewProtocol: UIView {
    var actionNext: ((String) -> Void)? { get set }
    var actionBack: (() -> Void)? { get set }
}

final class AuthCPFView: UIView, AuthCPFViewProtocol {
    private lazy var customNavigationBar: CoraNavigationBar = {
        let navBar = CoraNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        return navBar
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var cpfLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var cpfTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var nextButton: CoraButton = {
        let button = CoraButton(
            title: "Próximo",
            image: UIImage(systemName: "ic_arrow-right"),
            style: .primary
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var dataString: String = ""
    
    var actionNext: ((String) -> Void)?
    var actionBack: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func onTapNext() {
        cpfTextField.resignFirstResponder()
        actionNext?(dataString)
    }
}

extension AuthCPFView: ViewCode {
    func buildViewHierarchy() {
        addSubview(customNavigationBar)
        addSubview(titleLabel)
        addSubview(cpfLabel)
        addSubview(cpfTextField)
        addSubview(nextButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            cpfLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            cpfLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            cpfTextField.topAnchor.constraint(equalTo: cpfLabel.bottomAnchor, constant: 20),
            cpfTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cpfTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 48.0)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .white
        customNavigationBar.backgroundColor = .gray01
        customNavigationBar.configure(
            title: "Login Cora",
            showBackButton: true,
            backAction: { [weak self] in
                self?.actionBack?()
            },
            actionImage: nil,
            action: nil
        )
        
        titleLabel.text = "Bem-vindo de volta!"
        //fonte customizada e negrito
        cpfLabel.text = "Qual seu CPF?"
        
        nextButton.addTarget(
            self,
            action: #selector(onTapNext),
            for: .touchUpInside
        )
        cpfTextField.becomeFirstResponder()
    }
}

extension AuthCPFView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataString = textField.text ?? ""
    }
}
