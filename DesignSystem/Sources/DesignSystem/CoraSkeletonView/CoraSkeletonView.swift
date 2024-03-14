import UIKit

public enum SkeletonType {
    case statement
    case detail
}

public class CoraSkeletonView: UIView {
    
    private var type: SkeletonType = SkeletonType.statement
    private var gradientLayer = CAGradientLayer()
    private var gradientBackgroundColor: CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    private var gradientMovingColor: CGColor = UIColor(white: 0.75, alpha: 1.0).cgColor
    
    public init(frame: CGRect, type: SkeletonType) {
        self.type = type
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
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
        
        var lastBottomAnchor = topAnchor
        
        addLine(
            height: 32,
            widthPercent: 1,
            leadingPadding: 0,
            topAnchor: lastBottomAnchor,
            topPadding: topPadding
        )
        lastBottomAnchor = subviews.last!.bottomAnchor
        
        for _ in 0...3 {
            addLine(
                height: 32,
                widthPercent: 0.65,
                leadingPadding: leadingPadding,
                topAnchor: lastBottomAnchor,
                topPadding: topPadding
            )
            lastBottomAnchor = subviews.last!.bottomAnchor
            
            addLine(
                height: 16,
                widthPercent: 0.45,
                leadingPadding: leadingPadding,
                topAnchor: lastBottomAnchor,
                topPadding: spacing
            )
            lastBottomAnchor = subviews.last!.bottomAnchor
        }
        
        addLine(
            height: 32,
            widthPercent: 1,
            leadingPadding: 0,
            topAnchor: lastBottomAnchor,
            topPadding: topPadding
        )
        lastBottomAnchor = subviews.last!.bottomAnchor
        
        addLine(
            height: 32,
            widthPercent: 0.65,
            leadingPadding: leadingPadding,
            topAnchor: lastBottomAnchor,
            topPadding: topPadding
        )
        lastBottomAnchor = subviews.last!.bottomAnchor
        
        addLine(
            height: 16,
            widthPercent: 0.45,
            leadingPadding: leadingPadding,
            topAnchor: lastBottomAnchor,
            topPadding: spacing
        )
        lastBottomAnchor = subviews.last!.bottomAnchor
    }
    
    private func setupDetailSkeleton() {
        let leadingPadding: CGFloat = 20.0
        let topPadding: CGFloat = 20.0
        let spacing: CGFloat = 10.0
        
        var lastBottomAnchor = topAnchor
        addLine(
            height: 32,
            widthPercent: 0.85,
            leadingPadding: leadingPadding,
            topAnchor: lastBottomAnchor,
            topPadding: topPadding
        )
        lastBottomAnchor = subviews.last!.bottomAnchor
        
        addLine(
            height: 0,
            widthPercent: 0,
            leadingPadding: -20,
            topAnchor: lastBottomAnchor,
            topPadding: 32
        )
        lastBottomAnchor = subviews.last!.bottomAnchor
        
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
            lastBottomAnchor = subviews.last!.bottomAnchor
        }
    }
    
    private func addLine(
        height: CGFloat,
        widthPercent: CGFloat,
        leadingPadding: CGFloat,
        topAnchor: NSLayoutYAxisAnchor,
        topPadding: CGFloat) {
            let line = UIView()
            line.backgroundColor = .lightGray
            line.layer.cornerRadius = 4
            line.translatesAutoresizingMaskIntoConstraints = false
            addSubview(line)
            
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPadding),
                line.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
                line.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthPercent),
                line.heightAnchor.constraint(equalToConstant: height)
            ])
        }
    
    private func setupGradientLayer() {
        let gradientDarkColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        let gradientLightColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        
        gradientLayer.colors = [gradientDarkColor, gradientLightColor, gradientDarkColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradientLayer.frame = CGRect(x: -bounds.width, y: 0, width: bounds.width * 3, height: bounds.height)
        
        layer.insertSublayer(gradientLayer, at: 0)
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
        
        gradientLayer.add(animation, forKey: "shimmer")
    }
}
