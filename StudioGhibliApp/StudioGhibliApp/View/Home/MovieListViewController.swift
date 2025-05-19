import UIKit

class MovieListViewController: UIViewController {
        
    private let tableView = UITableView()
    private let searchController = UISearchController()
    private let movieListViewModel = MovieListViewModel()
    private var filteredMovies: [MovieViewModel] = []
    private var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    private var isLoading = true
    private let emptyStateView = EmptyStateView(message: "")
    private var stateManager: StateViewManager!
    
    weak var coordinator: MovieListCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
        setupTableView()
        bindViewModel()
        movieListViewModel.fetchListMovies()
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
        
        stateManager = StateViewManager(tableView: tableView, emptyStateView: emptyStateView)
        stateManager.onRetry = { [weak self] in
            self?.stateManager.apply(state: .loading)
            self?.movieListViewModel.fetchListMovies()
        }
    }
    
    private func bindViewModel() {
        movieListViewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.stateManager.apply(state: isLoading ? .loading : .content)
            }
            self?.isLoading = isLoading
        }
        
        movieListViewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if self.movieListViewModel.movies.isEmpty {
                    self.stateManager.apply(state: .empty(message: "Nenhum filme encontrado!"))
                } else {
                    self.stateManager.apply(state: .content)
                }
            }
        }
        
        movieListViewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.stateManager.apply(state: .error(message: message))
            }
        }
    }

    // MARK: - Setup Search Controller
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a movie..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch stateManager.currentState {
        case .loading:
            return 6
        case .content:
            return isFiltering ? filteredMovies.count : movieListViewModel.movies.count
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
            return cell
        case .content:
            let movieViewModel = isFiltering
            ? filteredMovies[indexPath.row]
            : movieListViewModel.movies[indexPath.row]
            cell.configure(with: movieViewModel)
            return cell
        case .empty(message: _), .error(message: _):
            return UITableViewCell()
        }
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = isFiltering
        ? filteredMovies[indexPath.row]
        : movieListViewModel.movies[indexPath.row]
        coordinator?.showMovieDetailView(for: selectedMovie)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.isEmpty else {
            filteredMovies = []
            emptyStateView.isHidden = true
            tableView.reloadData()
            return
        }
        filteredMovies = movieListViewModel.movies.filter {
            $0.title?.lowercased().contains(query.lowercased()) ?? false
        }
        if filteredMovies.isEmpty {
            stateManager.apply(state: .empty(message: "Não achamos seu filme favorito!"))
        } else {
            stateManager.apply(state: .content)
        }
        tableView.reloadData()
    }
}
