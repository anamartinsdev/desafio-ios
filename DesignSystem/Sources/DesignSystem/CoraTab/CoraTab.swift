import UIKit.UIView

public class CoraTab: UIView {
    private let segmentControl: UISegmentedControl
    private let iconImageView: UIImageView
    
    public var onValueChanged: ((Int) -> Void)?
    
    public var isSegmentedControlEnabled: Bool {
        get {
            return segmentControl.isEnabled
        }
        set {
            segmentControl.isEnabled = newValue
            updateSegmentControlColors()
        }
    }
    
    public init(items: [String], icon: UIImage? = nil) {
        segmentControl = UISegmentedControl(items: items)
        iconImageView = UIImageView(image: icon)
        iconImageView.tintColor = .systemPink
        
        super.init(frame: .zero)
       
        self.backgroundColor = .white
        setupSegmentControl()
        setupIconImageView()
        setupLayoutComponents()
    }
     
    required init?(coder: NSCoder) {
        segmentControl = UISegmentedControl(items: [])
        iconImageView = UIImageView()
        super.init(coder: coder)
    }
    
    private func setupSegmentControl() {
        addSubview(segmentControl)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(
            self,
            action: #selector(segmentChanged(_:)),
            for: .valueChanged
        )
        updateSegmentControlColors()
        isSegmentedControlEnabled = true
    }
    
    private func setupIconImageView() {
        addSubview(iconImageView)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayoutComponents() {
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentControl.trailingAnchor.constraint(
                equalTo: iconImageView.leadingAnchor,
                constant: -8
            ),
            segmentControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),
            iconImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -18
            ),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func updateSegmentControlColors() {
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemPink,
            .underlineColor: UIColor.systemPink,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        segmentControl.setTitleTextAttributes(
            normalTextAttributes,
            for: .normal
        )
        segmentControl.setTitleTextAttributes(
            selectedTextAttributes,
            for: .selected
        )
        
        segmentControl.backgroundColor = .white
        segmentControl.selectedSegmentTintColor = .white
        
        segmentControl.selectedSegmentTintColor = .clear
        segmentControl.setBackgroundImage(
            UIImage(),
            for: .normal,
            barMetrics: .default
        )
        segmentControl.setDividerImage(
            UIImage(),
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .default
        )
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        onValueChanged?(sender.selectedSegmentIndex)
    }
}
