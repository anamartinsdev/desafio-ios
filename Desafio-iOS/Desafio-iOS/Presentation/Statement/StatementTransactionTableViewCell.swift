import UIKit
import DesignSystem

public class StatementTransactionTableViewCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.applyBoldFont(size: 16)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyRegularFont(size: 14)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.applyRegularFont(size: 14, color: UIColor(hex: "6B7076"))
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.applyRegularFont(size: 12, color: UIColor(hex: "6B7076"))
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupCellViews() {
        addSubview(iconImageView)
        addSubview(amountLabel)
        addSubview(descriptionLabel)
        addSubview(nameLabel)
        addSubview(timeLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            iconImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            amountLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: 16
            ),
            amountLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: amountLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(
                equalTo: amountLabel.bottomAnchor,
                constant: 4
            ),
            
            nameLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            nameLabel.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: 4
            ),
            
            timeLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    public func configure(with transaction: Transaction) {
        backgroundColor = .white
        if transaction.type == .reversed {
            let attributeString = NSAttributedString(
                string: transaction.amount,
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            amountLabel.attributedText = attributeString
            iconImageView.image = UIImage(named: "ic_arrow-return")
        } else {
            amountLabel.text = transaction.amount
            iconImageView.image = UIImage(named: "ic_arrow-up-out")
        }
        amountLabel.textColor = evaluateTextForIconAndColor(text: transaction.description).color
        iconImageView.tintColor = evaluateTextForIconAndColor(text: transaction.description).color
        iconImageView.image = evaluateTextForIconAndColor(text: transaction.description).icon
        descriptionLabel.text = transaction.description
        descriptionLabel.textColor = evaluateTextForIconAndColor(text: transaction.description).color
        nameLabel.text = transaction.name
        timeLabel.text = transaction.time
    }
}

extension StatementTransactionTableViewCell {
    struct EvaluationResult {
        var icon: UIImage
        var color: UIColor
    }

    func evaluateTextForIconAndColor(text: String) -> EvaluationResult {
        let lowercasedText = text.lowercased()
        
        var icon: UIImage?
        if lowercasedText.contains("recebida") || lowercasedText.contains("recebido") {
            icon = UIImage(named: "ic_arrow-down-in")
        } else if lowercasedText.contains("estornada") || lowercasedText.contains("reembolso") {
            icon = UIImage(named: "ic_arrow-return")
        } else if lowercasedText.contains("boleto") {
            icon = UIImage(named: "ic_bar-code")
        } else {
            icon = UIImage(systemName: "cart")
        }
        
        var color: UIColor = UIColor(hex: "3B3B3B")
        if lowercasedText.contains("boleto") && lowercasedText.contains("deposito") {
            color = UIColor(hex: "1A93DA")
        } else if lowercasedText.contains("boleto") && lowercasedText.contains("pago") {
            color = UIColor(hex: "3B3B3B")
        } else if lowercasedText.contains("transferencia") && lowercasedText.contains("recebida") {
            color = UIColor(hex: "1A93DA")
        } else if lowercasedText.contains("pagamento") && lowercasedText.contains("recebido") {
            color = UIColor(hex: "1A93DA")
        } else {
            color = UIColor(hex: "3B3B3B")
        }
        
        return EvaluationResult(icon: icon ?? UIImage(), color: color)
    }

}
