import UIKit

final class EmptyStateView: UIView {

    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    var onRetry: (() -> Void)? = nil
    
    init(message: String) {
        super.init(frame: .zero)
        setupView()
        setupConstraint()
        setMessage(message)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraint()
    }
    
    // MARK: - public methods
    func setMessage(_ text: String) {
        messageLabel.text = text
    }
    
    func showRetryButton(_ show: Bool) {
        actionButton.isHidden = !show
    }
    
    func setButtonTitle(_ title: String) {
        actionButton.setTitle(title, for: .normal)
    }
    
    // MARK: - private methods
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
        messageLabel.font = .systemFont(ofSize: 16,
                                        weight: .medium)
        
        actionButton.setTitle(NSLocalizedString("try_again",
                                                comment: ""),
                              for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 16,
                                                    weight: .semibold)
        actionButton.addTarget(self,
                               action: #selector(didTapRetry),
                               for: .touchUpInside)
        actionButton.isHidden = true
    }
    
    @objc
    private func didTapRetry() {
        onRetry?()
    }
}
