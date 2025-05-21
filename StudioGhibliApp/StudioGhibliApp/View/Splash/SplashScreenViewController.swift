import UIKit

final class SplashScreenViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    
    var onAnimationFinished: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.31, green: 0.64, blue: 0.85, alpha: 1.0)
        setupConstraints()
        setupLayout()
        animateSplash()
    }
    
    private func setupConstraints() {
        [logoImageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
        ])
    }
    
    private func setupLayout() {
        logoImageView.image = UIImage(named: "Totoro")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.alpha = 0
        
        titleLabel.text = "スタジオジブリ作品 \n STUDIO GHIBLI App"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.alpha = 0
    }
    
    private func animateSplash() {
        UIView.animate(withDuration: 1.2, animations: {
            self.logoImageView.alpha = 1
            self.titleLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.8, delay: 1.2, animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.navigateToHome()
            })
        })
    }
    
    private func navigateToHome() {
        onAnimationFinished?()
    }
}
