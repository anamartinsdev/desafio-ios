import UIKit
import DesignSystem

protocol StatementDetailViewProtocol: UIView {
    var actionBack: (() -> Void)? { get set }
    var actionShare: (() -> Void)? { get set }
    func takeSnapshot() -> UIImage?
    func configure(with dataSections: [([String], Int?)])
}

final class StatementDetailView: UIView, StatementDetailViewProtocol {
    private lazy var customNavigationBar: CoraNavigationBar = {
        let navBar = CoraNavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        return navBar
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var titleIcon: UIImageView = {
        let image = UIImage(named: "ic_arrow-down-in")
        let button = UIImageView(image: image)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var titleStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var detailView: CoraTextGroupView = {
        let view = CoraTextGroupView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var actionButton: CoraButton = {
        let button = CoraButton(
            title: "Compartilhar comprovante",
            image: UIImage(named: "ic_share-ios"),
            style: .primary
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var actionBack: (() -> Void)?
    var actionShare: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with dataSections: [([String], Int?)]) {
        detailView.configure(with: dataSections)
    }
    
    func takeSnapshot() -> UIImage? {
        // Esconde elementos que não devem ser incluídos no snapshot
        let actionButtonIsHidden = actionButton.isHidden
        actionButton.isHidden = true
        
        // Renderiza a view em uma imagem
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        
        // Restaura a visibilidade dos elementos escondidos
        actionButton.isHidden = actionButtonIsHidden
        
        return image
    }
    
    @objc private func onTapShare() {
        actionShare?()
    }
}

extension StatementDetailView: ViewCode {
    func buildViewHierarchy() {
        addSubview(customNavigationBar)
        addSubview(scrollView)
        titleStack.addArrangedSubview(titleIcon)
        titleStack.addArrangedSubview(titleLabel)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleStack)
        contentView.addSubview(detailView)
        contentView.addSubview(actionButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            scrollView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleIcon.heightAnchor.constraint(equalToConstant: 12),
            titleIcon.widthAnchor.constraint(equalToConstant: 16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            titleStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleStack.heightAnchor.constraint(equalToConstant: 64),
            
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            actionButton.heightAnchor.constraint(equalToConstant: 64),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            detailView.topAnchor.constraint(equalTo: titleStack.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: 20)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .white
        titleLabel.text = "Transferência enviada"
    }
}
