import UIKit.UIView
import DesignSystem

protocol AuthPasswordViewProtocol: UIView {
    var actionNext: ((String) -> Void)? { get set }
    var actionForgotPassowrd: (() -> Void)? { get set }
    var actionBack: (() -> Void)? { get set }
}

final class AuthPasswordView: UIView, AuthPasswordViewProtocol {
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
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_eye-hidden"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemPink
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
    
    private var isPasswordVisible = false
    private var dataString: String {
        get { passwordTextField.text ?? "" }
        set { passwordTextField.text = newValue }
    }
    
    var actionNext: ((String) -> Void)?
    var actionForgotPassowrd: (() -> Void)?
    var actionBack: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func onTapNext() {
        actionNext?(dataString)
    }
    
    @objc private func onTapForgotPassword() {
        actionForgotPassowrd?()
    }
    
    @objc private func onTapEye() {
        togglePassword()
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        dataString = textField.text ?? ""
    }
    
    private func togglePassword() {
        isPasswordVisible = !isPasswordVisible
        passwordTextField.isSecureTextEntry = isPasswordVisible
        let image: UIImage? = isPasswordVisible ? UIImage(named: "ic_eye-hidden") : UIImage(named: "ic_eye-open")
        eyeButton.setImage(image, for: .normal)
    }
}

extension AuthPasswordView: ViewCode {
    func buildViewHierarchy() {
        addSubview(customNavigationBar)
        addSubview(titleLabel)
        addSubview(passwordTextField)
        addSubview(eyeButton)
        addSubview(forgotPasswordLabel)
        addSubview(nextButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                        
            passwordTextField.heightAnchor.constraint(equalToConstant: 64.0),
            passwordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64),
            
            eyeButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            forgotPasswordLabel.heightAnchor.constraint(equalToConstant: 32.0),
            forgotPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32),
            forgotPasswordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            forgotPasswordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 48.0)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .white
        customNavigationBar.backgroundColor = .gray02
        customNavigationBar.configure(
            title: "Login Cora",
            showBackButton: true,
            backAction: { [weak self] in
                self?.actionBack?()
            },
            actionImage: nil,
            action: nil
        )
        
        titleLabel.text = "Digite sua senha de acesso"
        //fonte customizada e negrito
        forgotPasswordLabel.text = "Esqueci minha senha"
        
        passwordTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        passwordTextField.delegate = self
        
        nextButton.addTarget(
            self,
            action: #selector(onTapNext),
            for: .touchUpInside
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapForgotPassword))
        forgotPasswordLabel.addGestureRecognizer(tapGesture)
        
        eyeButton.addTarget(
            self,
            action: #selector(onTapEye),
            for: .touchUpInside
        )
    }
}

extension AuthPasswordView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataString = textField.text ?? ""
    }
}
