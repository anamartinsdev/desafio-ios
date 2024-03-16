import UIKit

public extension UILabel {
    func applyBoldFont(size: CGFloat, color: UIColor? = nil) {
        self.font = UIFont(name: "Avenir-Heavy", size: size)
        if let textColor = color {
            self.textColor = textColor
        }
    }

    func applyRegularFont(size: CGFloat, color: UIColor? = nil) {
        self.font = UIFont(name: "Avenir-Book", size: size)
        if let textColor = color {
            self.textColor = textColor
        }
    }
}

