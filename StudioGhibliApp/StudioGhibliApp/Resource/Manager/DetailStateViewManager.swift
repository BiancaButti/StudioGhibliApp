import Foundation

final class DetailStateViewManager {
    
    private weak var contentView: MovieDetailContentView?
    private weak var emptyStateView: EmptyStateView?
    
    private(set) var currentState: ViewState = .loading
    
    var onRetry: (() -> Void)?
    
    init(contentView: MovieDetailContentView?, emptyStateView: EmptyStateView) {
        self.contentView = contentView
        self.emptyStateView = emptyStateView
        
        emptyStateView.onRetry = { [weak self] in
            self?.onRetry?()
        }
    }
    
    func apply(state: ViewState, model: MovieViewData? = nil) {
        currentState = state
        
        guard let contentView = contentView,
              let emptyStateView = emptyStateView else { return }
        
        switch state {
        case .loading:
            emptyStateView.isHidden = true
            contentView.isHidden = false
            contentView.showSkeleton()
        case .content:
            contentView.isHidden = false
            emptyStateView.isHidden = true
            if let model = model {
                contentView.configure(with: model)
            }
        case .empty(let message), .error(let message):
            contentView.isHidden = true
            contentView.hideSkeleton()
            emptyStateView.setMessage(message)
            emptyStateView.showRetryButton(true)
            emptyStateView.isHidden = false
        }
    }
}
