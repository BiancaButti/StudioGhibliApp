import QuartzCore
import UIKit

func applyShimmer(to view: UIView) {
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
        UIColor.systemGray5.cgColor,
        UIColor.systemGray4.cgColor,
        UIColor.systemGray3.cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    gradientLayer.locations = [0.0, 0.5, 1.0]
    gradientLayer.frame = view.bounds
    gradientLayer.cornerRadius = view.layer.cornerRadius
    
    let animation = CABasicAnimation(keyPath: NSLocalizedString("locations", comment: ""))
    animation.fromValue = [-1.0, 1.5, 2.0]
    animation.toValue = [1.0, 1.5, 2.0]
    animation.duration = 1.2
    animation.repeatCount = .infinity
    
    gradientLayer.add(animation, forKey: NSLocalizedString("shimmer", comment: ""))
    view.layer.addSublayer(gradientLayer)
    view.layer.masksToBounds = true
}

func removeShimmer(from view: UIView) {
    view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
}
