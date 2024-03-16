import UIKit

public class CPFTextFieldView: UIView {
    
    public let textField = UITextField()
    private let errorLabel = UILabel()
    private var rawCPFString = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func validateCPF() {
        guard let text = textField.text, isCPFValid(text) else {
            showError(message: "CPF inválido")
            return
        }
        hideError()
    }
    
    public func isCPFValid(_ cpf: String) -> Bool {
        let numbers = cpf.compactMap({ Int(String($0)) })
        
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        
        func calculateDigit(with weights: [Int]) -> Int {
            let sum = zip(numbers, weights).map(*).reduce(0, +)
            return (sum * 10 % 11) % 10
        }
        
        let firstNineDigits = Array(numbers.prefix(9))
        let firstVerifier = calculateDigit(with: [10, 9, 8, 7, 6, 5, 4, 3, 2])
        let secondVerifier = calculateDigit(with: [11] + [10, 9, 8, 7, 6, 5, 4, 3, 2])
        
        return firstVerifier == numbers[9] && secondVerifier == numbers[10]
    }
    public func getRawCPFNumber() -> String {
        return rawCPFString
    }
}

extension CPFTextFieldView {
    private func setupViews() {
        addSubview(textField)
        addSubview(errorLabel)
        
        errorLabel.textColor = .red
        errorLabel.applyRegularFont(size: 14, color: .red)
        errorLabel.isHidden = true
        
        // Set up constraints
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupTextField() {
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    @objc public func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }

            let numericText = text.filter { $0.isNumber }
            rawCPFString = numericText

            let formattedText = formatForCPF(numericText)
            textField.text = formattedText
    }
    
    private func showError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func hideError() {
        errorLabel.isHidden = true
    }
    
    private func formatForCPF(_ cpf: String) -> String {
        let numericText = cpf.filter { $0.isNumber }
        let cpfDigits = String(numericText.prefix(11))

        let masks = ["###.###.###-##", "###.###.###", "###.###", "###"]
        var maskedText = ""

        let mask = masks.first { $0.count == cpfDigits.count + (cpfDigits.count / 3) + (cpfDigits.count > 6 ? 1 : 0) } ?? "###.###.###-##"
        
        var index = cpfDigits.startIndex
        for ch in mask {
            if ch == "#", index < cpfDigits.endIndex {
                maskedText.append(cpfDigits[index])
                index = cpfDigits.index(after: index)
            } else if ch != "#" {
                maskedText.append(ch)
            }
        }
        return maskedText
    }


    
}
