import UIKit

public class CoraStatementCell: UITableViewCell {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
        
        descriptionLabel.text = transaction.description
        nameLabel.text = transaction.name
        timeLabel.text = transaction.time
        
        iconImageView.image = UIImage(systemName: "creditcard.fill")
        
        if transaction.type == .reverse {
            let attributeString = NSAttributedString(
                string: transaction.amount,
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            amountLabel.attributedText = attributeString
        } else {
            amountLabel.text = transaction.amount
        }
    }
}
