import UIKit

public class StatementTransactionTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Initialization
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
        
        // Define a auto-layout para as subviews
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Icon ImageView Constraints
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Amount Label Constraints
            amountLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            // Description Label Constraints
            descriptionLabel.leadingAnchor.constraint(equalTo: amountLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
            
            // Name Label Constraints
            nameLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            
            // Time Label Constraints
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    
    // MARK: - Configuration
    public func configure(with transaction: Transaction) {
        backgroundColor = .white
        descriptionLabel.text = transaction.description
        nameLabel.text = transaction.name
        
        timeLabel.text = transaction.time
        
        iconImageView.image = UIImage(systemName: "creditcard.fill")
        
        
        
        switch transaction.entry {
        case .debit:
            amountLabel.textColor = UIColor(hex: "1A93DA")
            descriptionLabel.textColor = UIColor(hex: "1A93DA")
            iconImageView.tintColor = UIColor(hex: "1A93DA")
        case .credit:
            amountLabel.textColor = UIColor(hex: "3B3B3B")
            descriptionLabel.textColor = UIColor(hex: "3B3B3B")
            iconImageView.tintColor = UIColor(hex: "3B3B3B")
        }
        
                
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
    }
}
