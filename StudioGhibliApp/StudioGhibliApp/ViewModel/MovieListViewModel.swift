import Foundation

final class MovieListViewModel {
    
    // MARK: - Dependencies
    private let apiService: APIServiceProtocol
    private let jsonCache: CacheProtocol
    private let detailCache: DetailCacheProtocol
    
    // MARK: - State
    private(set) var movies: [MovieViewData] = []
    private var inMemoryCache: [MovieViewData]?
    var selectedMovie: MovieViewData?
    
    // MARK: - Bindings
    var onMoviesUpdated: (() -> Void)?
    var onMovieLoaded: ((String) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    init(apiService: APIServiceProtocol = APIService(),
         jsonCache: CacheProtocol = JSONCache.shared,
         detailCache: DetailCacheProtocol = MovieDetailCache.shared) {
        self.apiService = apiService
        self.jsonCache = jsonCache
        self.detailCache = detailCache
    }
    
    // MARK: - public methods
    func fetchListMovies() {
        if let cached = inMemoryCache {
            updateMovies(cached)
            return
        }
        
        if let cachedAPIModels: [MovieAPIModel] = jsonCache.load([MovieAPIModel].self) {
            let viewModels = cachedAPIModels.map { MovieViewData(from: $0) }
            inMemoryCache = viewModels
            updateMovies(viewModels)
            cacheDetails(cachedAPIModels)
            return
        }
        
        onLoadingStateChange?(true)

        apiService.fetchMovies{ [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingStateChange?(false)
                
                switch result {
                case .success(let apiMovies):
                    let viewModels = apiMovies.map { MovieViewData(from: $0) }
                    self?.inMemoryCache = viewModels
                    self?.updateMovies(viewModels)
                    
                    if !apiMovies.isEmpty {
                        self?.jsonCache.save(apiMovies)
                        self?.cacheDetails(apiMovies)
                    }
                case .failure(_):
                    if let cacheAPIModels: [MovieAPIModel] = self?.jsonCache.load([MovieAPIModel].self),
                       !cacheAPIModels.isEmpty {
                        let viewModels = cacheAPIModels.map { MovieViewData(from: $0) }
                        self?.inMemoryCache = viewModels
                        self?.updateMovies(viewModels)
                        self?.cacheDetails(cacheAPIModels)
                    } else {
                        self?.onError?(NSLocalizedString("failure_fetch_movies",
                                                         comment: ""))
                    }
                }
            }
        }
    }
    
    func clearCache() {
        inMemoryCache = nil
        JSONCache.shared.clearCache()
    }
    
    func loadMovie(withId id: String) {
        guard let model = detailCache.load(for: id) else {
            onError?(NSLocalizedString("failure_movie_not_found_fetch_movies",
                                       comment: ""))
            return
        }
        selectedMovie = MovieViewData(from: model)
        onMoviesUpdated?()
    }
    
    // MARK: - private methods
    private func updateMovies(_ viewModels: [MovieViewData]) {
        self.movies = viewModels
        onMoviesUpdated?()
    }
    
    private func cacheDetails(_ models: [MovieAPIModel]) {
        models.forEach {
            if let id = $0.id {
                detailCache.save($0, for: id)
            }
        }
    }
    
    private func mapToViewData(_ models: [MovieAPIModel]) -> [MovieViewData] {
        return models.map { MovieViewData(from: $0) }
    }
}
