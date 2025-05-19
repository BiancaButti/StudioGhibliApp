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
    weak var coordinator: MovieListCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        filteredMovies = []
        setupSearchController()
        setupTableView()
        bindViewModel()
        movieListViewModel.fetchMovies()
    }

    // MARK: - Setup Table View
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieItemCell")
    }
    
    private func bindViewModel() {
        movieListViewModel.onLoadingStateChange = { [weak self] isLoading in
            self?.isLoading = isLoading
            DispatchQueue.main.async {
                self?.tableView.reloadData()
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
        if isLoading {
            return 6
        }
        return isFiltering ? filteredMovies.count : movieListViewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        if isLoading {
            cell.showPlaceholder()
            return cell
        }
        let movieViewModel = isFiltering
        ? filteredMovies[indexPath.row]
        : movieListViewModel.movies[indexPath.row]
        cell.configure(with: movieViewModel)
        return cell
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
            tableView.reloadData()
            return
        }
        filteredMovies = movieListViewModel.movies.filter {
            $0.title?.lowercased().contains(query.lowercased()) ?? false
        }
        tableView.reloadData()
    }
}
