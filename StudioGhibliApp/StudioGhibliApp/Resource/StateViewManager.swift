import UIKit

final class StateViewManager {
    
    private weak var tableView: UITableView?
    private weak var emptyStateView: EmptyStateView?
    
    private(set) var currentState: ViewState = .loading
    
    var onRetry: (() -> Void)?
    
    init(tableView: UITableView?, emptyStateView: EmptyStateView) {
        self.tableView = tableView
        self.emptyStateView = emptyStateView
        
        emptyStateView.onRetry = { [weak self] in
            self?.onRetry?()
        }
    }
    
    func apply(state: ViewState, isFiltering: Bool = false) {
        currentState = state
        
        guard let tableView = tableView,
              let emptyStateView = emptyStateView else { return }
        
        switch state {
        case .loading:
            tableView.isHidden = false
            emptyStateView.isHidden = true
        case .content:
            tableView.isHidden = false
            emptyStateView.isHidden = true
            tableView.reloadData()
        case .empty(let message):
            tableView.isHidden = false
            emptyStateView.setMessage(message)
            emptyStateView.showRetryButton(false)
            emptyStateView.isHidden = false
        case .error(let message):
            tableView.isHidden = true
            emptyStateView.setMessage(message)
            emptyStateView.showRetryButton(true)
            emptyStateView.isHidden = false
        }
    }
}
