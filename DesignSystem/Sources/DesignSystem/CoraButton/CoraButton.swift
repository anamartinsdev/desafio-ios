import UIKit

public class CoraButton: UIControl {
    
    public enum ButtonStyle {
        case primary
        case secondary
        case disable
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var buttonTitle: String? {
        didSet {
            titleLabel.text = buttonTitle
        }
    }
    
    private var buttonImage: UIImage? {
        didSet {
            imageView.image = buttonImage
        }
    }
    
    var actionHandler: (() -> Void)?
    
    public init(title: String?, image: UIImage?, style: ButtonStyle) {
        super.init(frame: .zero)
        setup(title: title, image: image, style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(title: String?, image: UIImage?, style: ButtonStyle) {
        buttonTitle = title
        buttonImage = image
        
        addSubview(titleLabel)
        addSubview(imageView)
        apply(style: style)
        addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        setupViews()
    }
    
    private func setupViews() {
        layer.cornerRadius =  16
        clipsToBounds = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        if imageView.image != nil {
            NSLayoutConstraint.activate([
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                titleLabel.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: 22
                ),
                imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                imageView.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -22
                ),
                imageView.heightAnchor.constraint(
                    equalTo: heightAnchor,
                    multiplier: 0.5
                ),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
    }
    
    func apply(style: ButtonStyle) {
        let tintColor: UIColor
        let backgroundColor: UIColor
        
        switch style {
        case .primary:
            tintColor = .white
            backgroundColor = .systemPink
        case .secondary:
            tintColor = .systemPink
            backgroundColor = .white
        case .disable:
            tintColor = .white
            backgroundColor = .lightGray
        }
        
        titleLabel.textColor = tintColor
        if let buttonImage = buttonImage?.withRenderingMode(.alwaysTemplate) {
            imageView.image = buttonImage
            imageView.tintColor = tintColor
        }
        self.backgroundColor = backgroundColor
    }
    
    @objc private func buttonAction() {
        actionHandler?()
    }
}
