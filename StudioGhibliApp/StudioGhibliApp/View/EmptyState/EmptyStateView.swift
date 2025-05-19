import UIKit

final class EmptyStateView: UIView {

    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    var onRetry: (() -> Void)? = nil
    
    init(message: String) {
        super.init(frame: .zero)
        setupConstraint()
        setupView()
        setMessage(message)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupConstraint() {
        translatesAutoresizingMaskIntoConstraints = false

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(messageLabel)
        addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupView() {
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        actionButton.setTitle("Tente Novamente", for: .normal)
        actionButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        actionButton.isHidden = true
    }
    
    func setMessage(_ text: String) {
        messageLabel.text = text
    }
    
    func showRetryButton(_ show: Bool) {
        actionButton.isHidden = !show
    }
    
    @objc
    private func didTapRetry() {
        onRetry?()
    }
}
