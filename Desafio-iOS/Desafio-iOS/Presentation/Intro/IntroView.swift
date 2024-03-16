import UIKit
import DesignSystem

protocol IntroViewProtocol: UIView {
    var actionSignUp: (() -> Void)? { get set }
    var actionSignIn: (() -> Void)? { get set }
}

final class IntroView: UIView, IntroViewProtocol {
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "home-banner"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.applyBoldFont(size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.applyRegularFont(size: 26)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.textColor = .white
        label.applyRegularFont(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var signUpButton: CoraButton = {
        let button = CoraButton(
            title: "Quero fazer parte!",
            image: UIImage(systemName: "ic_arrow-right"),
            style: .secondary
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signInButton: CoraButton = {
        let button = CoraButton(
            title: "Já sou cliente",
            image: nil,
            style: .primary
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var actionSignUp: (() -> Void)?
    var actionSignIn: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func onTapSignUp() {
        actionSignUp?()
    }
    
    @objc private func onTapSignIn() {
        actionSignIn?()
    }
}

extension IntroView: ViewCode {
    func buildViewHierarchy() {
        addSubview(backgroundImage)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(descriptionLabel)
        addSubview(signUpButton)
        addSubview(signInButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -12),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            subTitleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            descriptionLabel.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -26),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 64),
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            signUpButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -16),
            
            signInButton.heightAnchor.constraint(equalToConstant: 64),
            signInButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            signInButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            signInButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = UIColor(hex: "FE3E6D")
        titleLabel.text = "Conta Digital PJ"
        subTitleLabel.text = "Poderosamente simples"
        descriptionLabel.text = "Sua empresa livre de burocracias e de taxas para gerar boletos, fazer transferências e pagamentos."
        
        signUpButton.addTarget(
            self,
            action: #selector(onTapSignUp),
            for: .touchUpInside
        )
        
        signInButton.addTarget(
            self,
            action: #selector(onTapSignIn),
            for: .touchUpInside
        )
    }
}
