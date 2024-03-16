import UIKit

public enum SkeletonType {
    case statement
    case detail
}

public class CoraSkeletonView: UIView {
    
    private var type: SkeletonType = SkeletonType.statement
    private var gradientLayer = CAGradientLayer()
    private var gradientBackgroundColor: CGColor = UIColor(
        white: 0.85,
        alpha: 1.0
    ).cgColor
    private var gradientMovingColor: CGColor = UIColor(
        white: 0.75,
        alpha: 1.0
    ).cgColor
    
    public init(frame: CGRect, type: SkeletonType) {
        self.type = type
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: -bounds.width, y: 0, width: bounds.width * 3, height: bounds.height)
    }
    
    public func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = .infinity
        
        gradientLayer.add(
            animation,
            forKey: "shimmer"
        )
    }
    
    public func stopAnimating() {
        gradientLayer.removeAllAnimations()
    }
}

extension CoraSkeletonView {
    private func setupViews() {
        backgroundColor = .white
        switch type {
        case .statement:
            setupStatementSkeleton()
        case .detail:
            setupDetailSkeleton()
        }
        setupGradientLayer()
    }
    
    private func setupStatementSkeleton() {
        let leadingPadding: CGFloat = 20.0
        let topPadding: CGFloat = 20.0
        let spacing: CGFloat = 16.0
        
        var lastBottomAnchor: NSLayoutYAxisAnchor = topAnchor
        
        addLine(
            height: 32,
            widthPercent: 1,
            leadingPadding: 0,
            topAnchor: lastBottomAnchor,
            topPadding: topPadding
        )
        
        guard let firstBottomAnchor = subviews.last?.bottomAnchor else { return }
        lastBottomAnchor = firstBottomAnchor
        
        for _ in 0...3 {
            addLine(
                height: 32,
                widthPercent: 0.65,
                leadingPadding: leadingPadding,
                topAnchor: lastBottomAnchor,
                topPadding: topPadding
            )
            
            guard let newBottomAnchor = subviews.last?.bottomAnchor else { return }
            lastBottomAnchor = newBottomAnchor
            
            addLine(
                height: 16,
                widthPercent: 0.45,
                leadingPadding: leadingPadding,
                topAnchor: lastBottomAnchor,
                topPadding: spacing
            )
            
            guard let updatedBottomAnchor = subviews.last?.bottomAnchor else { return }
            lastBottomAnchor = updatedBottomAnchor
        }
        
        addLine(
            height: 32,
            widthPercent: 1,
            leadingPadding: 0,
            topAnchor: lastBottomAnchor,
            topPadding: topPadding
        )
        
        guard let anotherBottomAnchor = subviews.last?.bottomAnchor else { return }
        lastBottomAnchor = anotherBottomAnchor
        
        addLine(
            height: 32,
            widthPercent: 0.65,
            leadingPadding: leadingPadding,
            topAnchor: lastBottomAnchor,
            topPadding: topPadding
        )
        
        guard let finalBottomAnchor = subviews.last?.bottomAnchor else { return }
        lastBottomAnchor = finalBottomAnchor
        
        addLine(
            height: 16,
            widthPercent: 0.45,
            leadingPadding: leadingPadding,
            topAnchor: lastBottomAnchor,
            topPadding: spacing
        )
    }

    
    private func setupDetailSkeleton() {
        let leadingPadding: CGFloat = 20.0
        let topPadding: CGFloat = 20.0
        let spacing: CGFloat = 10.0
        
        var lastBottomAnchor: NSLayoutYAxisAnchor = topAnchor
        
        addLine(
            height: 32,
            widthPercent: 0.85,
            leadingPadding: leadingPadding,
            topAnchor: lastBottomAnchor,
            topPadding: topPadding
        )
        guard let anotherBottomAnchor = subviews.last?.bottomAnchor else { return }
        lastBottomAnchor = anotherBottomAnchor
        
        addLine(
            height: 0,
            widthPercent: 0,
            leadingPadding: -20,
            topAnchor: lastBottomAnchor,
            topPadding: 32
        )
        guard let anotherBottomAnchor = subviews.last?.bottomAnchor else { return }
        lastBottomAnchor = anotherBottomAnchor
        
        let smallLinesCount = 4
        for _ in 0...smallLinesCount {
            addLine(
                height: 32,
                widthPercent: 0.65,
                leadingPadding: leadingPadding,
                topAnchor: lastBottomAnchor,
                topPadding: spacing
            )
            lastBottomAnchor = subviews.last!.bottomAnchor
            
            addLine(
                height: 16,
                widthPercent: 0.45,
                leadingPadding: leadingPadding,
                topAnchor: lastBottomAnchor,
                topPadding: spacing
            )
        }
    }
    
    private func addLine(
        height: CGFloat,
        widthPercent: CGFloat,
        leadingPadding: CGFloat,
        topAnchor: NSLayoutYAxisAnchor,
        topPadding: CGFloat) {
            let line = UIView()
            line.backgroundColor = UIColor(hex: "#DEE4E9")
            line.layer.cornerRadius = 4
            line.translatesAutoresizingMaskIntoConstraints = false
            addSubview(line)
            
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: leadingPadding
                ),
                line.topAnchor.constraint(
                    equalTo: topAnchor,
                    constant: topPadding
                ),
                line.widthAnchor.constraint(
                    equalTo: widthAnchor,
                    multiplier: widthPercent
                ),
                line.heightAnchor.constraint(equalToConstant: height)
            ])
        }
    
    private func setupGradientLayer() {
        let baseColor = UIColor(hex: "#FFFFFF")
        let gradientDarkColor = baseColor.withAlphaComponent(1.0).cgColor
        let gradientLightColor = baseColor.withAlphaComponent(0.8).cgColor
        
        gradientLayer.colors = [
            gradientDarkColor,
            gradientLightColor,
            gradientDarkColor
        ]
        gradientLayer.locations = [
            0.0,
            0.5,
            1.0
        ]
        
        gradientLayer.startPoint = CGPoint(
            x: 0.0,
            y: 0.5
        )
        gradientLayer.endPoint = CGPoint(
            x: 1.0,
            y: 0.5
        )
        
        gradientLayer.frame = CGRect(
            x: -bounds.width,
            y: 0,
            width: bounds.width * 3,
            height: bounds.height
        )
        
        layer.insertSublayer(
            gradientLayer,
            at: 0
        )
    }
}
