import UIKit

class MovieDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = MovieDetailContentView()
    private let emptyStateView = EmptyStateView(message: "")
    private var lastModel: MovieViewData?
    private var shouldFailFirstTime = true
    private lazy var stateManager = GenericStateViewManager<MovieDetailContentView>(
        contentView: contentView,
        emptyStateView: emptyStateView
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupConstraints()
        setupRetryAction()
    }
    
    // MARK: - private methods
    private func setupConstraints() {
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
    
    private func setupHierarchy() {
        
        [scrollView, emptyStateView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    private func setupRetryAction() {
        stateManager.onRetry = { [weak self] in
            guard let self = self else { return }
            self.configure(with: self.lastModel)
        }
    }
    
    // MARK: - public method
    func configure(with model: MovieViewData?) {
        if let model = model {
            lastModel = model
        }

        stateManager.apply(state: .loading)

        guard let model = self.lastModel else {
            self.stateManager.apply(state: .error(message: NSLocalizedString("failure_invalid_movie", comment: "")))
            return
        }
        self.stateManager.apply(state: .content, model: model)
    }
}
