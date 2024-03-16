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
    
    private lazy var cpfTextField: CPFTextFieldView = {
        let textField = CPFTextFieldView()
        textField.textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var nextButton: CoraButton = {
        let button = CoraButton(
            title: "Próximo",
            image: UIImage(named: "ic_arrow-right"),
            style: .primary,
            iconColor: .white
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var dataString: String {
        get { cpfTextField.textField.text ?? "" }
        set { cpfTextField.textField.text = newValue }
    }
    
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
        dataString = cpfTextField.getRawCPFNumber()
        actionNext?(dataString)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        cpfTextField.textFieldEditingChanged(textField)
        dataString = cpfTextField.getRawCPFNumber()
        cpfTextField.validateCPF()
        
        let isValidCPF = cpfTextField.isCPFValid(dataString)
        nextButton.isEnabled = isValidCPF
        nextButton.apply(style: isValidCPF ? .primary : .disable)
        textField.text = cpfTextField.formatForCPF(dataString)
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
            customNavigationBar.topAnchor.constraint(
                equalTo: topAnchor,
                constant: -10
            ),
            customNavigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 104),
            
            titleLabel.topAnchor.constraint(
                equalTo: customNavigationBar.bottomAnchor,
                constant: 20
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            
            cpfLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 20
            ),
            cpfLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            
            cpfTextField.topAnchor.constraint(
                equalTo: cpfLabel.bottomAnchor,
                constant: 32
            ),
            cpfTextField.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            cpfTextField.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            
            nextButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            ),
            nextButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            nextButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            nextButton.heightAnchor.constraint(equalToConstant: 48.0)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .white

        customNavigationBar.configure(
            title: "Login Cora",
            titleColor: UIColor(hex: "6B7076"),
            showBackButton: true,
            backAction: { [weak self] in
                self?.actionBack?()
            },
            actionImage: nil,
            action: nil
        )
        
        nextButton.addTarget(
            self,
            action: #selector(onTapNext),
            for: .touchUpInside
        )
        nextButton.apply(style: .disable)
        nextButton.isEnabled = false
        
        cpfTextField.textField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        cpfTextField.textField.delegate = self
        cpfTextField.textField.font = UIFont(
            name: "Avenir-Roman",
            size: 22
        )
        cpfTextField.textField.textColor = UIColor(hex: "3B3B3B")
        cpfTextField.becomeFirstResponder()
        
        titleLabel.text = "Bem-vindo de volta!"
        titleLabel.applyRegularFont(
            size: 16,
            color: UIColor(hex: "6B7076")
        )
        
        cpfLabel.text = "Qual seu CPF?"
        cpfLabel.applyBoldFont(
            size: 28,
            color: UIColor(hex: "3B3B3B")
        )
    }
}

extension AuthCPFView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataString = textField.text ?? ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(
            range,
            in: currentText
        ) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 14 && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
