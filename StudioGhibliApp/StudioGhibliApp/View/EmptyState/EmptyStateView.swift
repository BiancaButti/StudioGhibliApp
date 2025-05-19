import UIKit

final class EmptyStateView: UIView {

   private let messageLabel = UILabel()
    
    init(message: String) {
        super.init(frame: .zero)
        setupView()
        setMessage(message)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        addSubview(messageLabel)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])
    }
    
    func setMessage(_ text: String) {
        messageLabel.text = text
    }
}
