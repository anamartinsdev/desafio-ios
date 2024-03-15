import UIKit.UIView

public class CoraTextGroupView: UIView {
    
    private var mainStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMainStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }
    
    public func configure(with dataSections: [([String], Int?)]) {
        dataSections.forEach { (strings, boldIndex) in
            let groupStackView = UIStackView()
            groupStackView.axis = .vertical
            groupStackView.spacing = 2.0
            groupStackView.alignment = .fill
            groupStackView.distribution = .fill
            groupStackView.translatesAutoresizingMaskIntoConstraints = false
            
            for (index, string) in strings.enumerated() {
                let label = UILabel()
                label.text = string
                label.numberOfLines = 0
                
                let isBold = index == boldIndex
                label.font = isBold ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 14)
                if isBold {
                    label.textColor = .black
                    groupStackView.addArrangedSubview(label)
                    groupStackView.setCustomSpacing(8, after: label)
                } else {
                    label.textColor = .darkGray
                    groupStackView.addArrangedSubview(label)
                }
            }
            
            mainStackView.addArrangedSubview(groupStackView)
            mainStackView.setCustomSpacing(32, after: groupStackView)
        }
    }
}
