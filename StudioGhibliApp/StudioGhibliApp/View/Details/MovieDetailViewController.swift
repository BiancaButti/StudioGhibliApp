import UIKit

class MovieDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = MovieDetailContentView()
    private let emptyStateView = EmptyStateView(message: "")
    private lazy var stateManager = DetailStateViewManager(
        contentView: contentView, emptyStateView: emptyStateView
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraint()
        setupRetryAction()
    }
    
    private func setupConstraint() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupRetryAction() {
        stateManager.onRetry = { [weak self] in
            //TODO: make action
        }
    }
    
    func configure(with model: MovieViewData?) {
        stateManager.apply(state: .loading)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let model {
                self.stateManager.apply(state: .content, model: model)
            } else {
                self.stateManager.apply(state: .error(message: "Não foi possível exibir os dados."))
            }
        }
    }
}
