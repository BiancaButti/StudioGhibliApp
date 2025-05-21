import UIKit

final class GenericStateViewManager<Content: ContentDisplayable> {
    
    private weak var contentView: Content?
    private weak var emptyStateView: EmptyStateView?
    private(set) var currentState: ViewState = .loading
    
    var onRetry: (() -> Void)?
    
    init(contentView: Content?, emptyStateView: EmptyStateView) {
        self.contentView = contentView
        self.emptyStateView = emptyStateView
        
        emptyStateView.onRetry = { [weak self] in
            self?.onRetry?()
        }
    }
    
    func apply(state: ViewState, model: Any? = nil, showRetryOnError: Bool = true) {
        currentState = state
        
        switch state {
        case .loading:
            emptyStateView?.isHidden = true
            contentView?.setHidden(false)
            contentView?.setLoading()
        case .content:
            contentView?.setHidden(false)
            emptyStateView?.isHidden = true
            contentView?.showContent(model: model)
        case .empty(let message):
            contentView?.setHidden(true)
            emptyStateView?.setMessage(message)
            emptyStateView?.showRetryButton(false)
            emptyStateView?.isHidden = false
        case .error(let message):
            contentView?.setHidden(true)
            emptyStateView?.setMessage(message)
            emptyStateView?.showRetryButton(showRetryOnError)
            emptyStateView?.isHidden = false
        }
    }
}
