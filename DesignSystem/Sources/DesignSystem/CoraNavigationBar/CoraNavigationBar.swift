import UIKit

public class CoraNavigationBar: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(named: "ic_chevron-left"),
            for: .normal
        )
        button.tintColor = .systemPink
        button.isHidden = true
        return button
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(hex: "FE3E6D")
        button.isHidden = true
        return button
    }()
    
    public var onBackButtonPressed: (() -> Void)?
    public var onActionButtonPressed: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(actionButton)
    }
    
    private func setupConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            backButton.centerYAnchor.constraint(
                equalTo: centerYAnchor,
                constant: 25
            ),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(
                equalTo: centerYAnchor,
                constant: 25
            ),
            
            actionButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            actionButton.centerYAnchor.constraint(
                equalTo: centerYAnchor,
                constant: 25
            ),
            actionButton.widthAnchor.constraint(equalToConstant: 24),
            actionButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    @objc private func backButtonTapped() {
        onBackButtonPressed?()
    }
    
    @objc private func actionButtonTapped() {
        onActionButtonPressed?()
    }
    
    public func configure(
        title: String,
        titleColor: UIColor? = UIColor(hex: "6B7076"),
        showBackButton: Bool = true,
        backAction: (() -> Void)? = nil,
        actionImage: UIImage? = nil,
        action: (() -> Void)? = nil
    ) {
        backgroundColor = .clear
        titleLabel.text = title
        titleLabel.applyRegularFont(
            size: 14,
            color: titleColor
        )
        backgroundColor = UIColor(hex: "F0F4F8")
        backButton.isHidden = !showBackButton
        backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        actionButton.isHidden = (actionImage == nil)
        if let actionImage = actionImage {
            actionButton.setImage(actionImage, for: .normal)
            actionButton.addTarget(
                self,
                action: #selector(actionButtonTapped),
                for: .touchUpInside
            )
        }
        
        self.onBackButtonPressed = backAction
        self.onActionButtonPressed = action
    }
}
