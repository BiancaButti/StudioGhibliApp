import UIKit

class HomeMovieListViewController: UIViewController {
        
    private let tableView = UITableView()
    private let searchController = UISearchController()
    private let viewModel = MovieListViewModel()
    private var filteredMovies: [MovieViewData] = []
    private var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    private var isLoading = true
    private let emptyStateView = EmptyStateView(message: "")
    private var stateManager: GenericStateViewManager<UITableView>!
    
    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        stateManager = GenericStateViewManager(contentView: tableView,
                                               emptyStateView: emptyStateView)
        stateManager.onRetry = { [weak self] in
            self?.viewModel.fetchListMovies()
        }
        setupSearchController()
        setupTableView()
        bindViewModel()
        viewModel.fetchListMovies()
    }

    // MARK: - Setup Table View
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        
        emptyStateView.isHidden = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieItemCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 220
    }
    
    private func bindViewModel() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.stateManager.apply(state: isLoading ? .loading : .content)
                self?.isLoading = isLoading
            }
        }
        
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if self.viewModel.movies.isEmpty {
                    self.stateManager.apply(state: .empty(message: "Nenhum filme encontrado!"))
                } else {
                    self.stateManager.apply(state: .content)
                }
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.stateManager.apply(state: .error(message: message))
            }
        }
    }

    // MARK: - Setup Search Controller
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Qual filme está procurando?"
        searchController.searchBar.searchTextField.backgroundColor = .systemGray6
        searchController.searchBar.searchTextField.clipsToBounds = true
        searchController.searchBar.tintColor = .label
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

extension HomeMovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch stateManager.currentState {
        case .loading:
            return 6
        case .content:
            return isFiltering ? filteredMovies.count : viewModel.movies.count
        case .empty(message: _), .error(message: _):
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        switch stateManager.currentState {
        case .loading:
            cell.showPlaceholder()
        case .content:
            let movie = isFiltering
            ? filteredMovies[indexPath.row]
            : viewModel.movies[indexPath.row]
            cell.configure(with: movie)
        case .empty(message: _), .error(message: _):
            return UITableViewCell()
        }
        return cell
    }
}

extension HomeMovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = isFiltering
        ? filteredMovies[indexPath.row]
        : viewModel.movies[indexPath.row]
        coordinator?.showMovieDetailView(for: selectedMovie)
    }
}

extension HomeMovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.isEmpty else {
            filteredMovies = []
            emptyStateView.isHidden = true
            tableView.reloadData()
            return
        }
        filteredMovies = viewModel.movies.filter {
            $0.title?.lowercased().contains(query.lowercased()) ?? false
        }
        if filteredMovies.isEmpty {
            stateManager.apply(state: .empty(message: "Não encontramos o seu filme!"))
        } else {
            stateManager.apply(state: .content)
        }
        tableView.reloadData()
    }
}
