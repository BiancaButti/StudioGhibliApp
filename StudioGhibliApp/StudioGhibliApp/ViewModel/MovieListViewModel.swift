import Foundation

final class MovieListViewModel {
    
    private let apiService = APIService()
    private var movieCache: [MovieViewModel]?
    private(set) var movies: [MovieViewModel] = []
    var movie: MovieViewModel?
    
    var onMoviesUpdated: (() -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onMovieLoaded: ((String) -> Void)?
    
    func fetchListMovies() {
        if let cached = movieCache {
            print("usando cache em memória")
            movies = cached
            onMoviesUpdated?()
            return
        }
        
        if let cachedAPIModels: [MovieAPIModel] = JSONCache.shared.load([MovieAPIModel].self) {
            print("usando cache do disco")
            let viewModels = cachedAPIModels.map { MovieViewModel(from: $0) }
            movieCache = viewModels
            movies = viewModels
            onMoviesUpdated?()
            return
        }
        
        print("buscando da api")
        onLoadingStateChange?(true)
        apiService.fetchMovies{ [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingStateChange?(false)
                switch result {
                case .success(let apiMovies):
                    print("dados recebidos da api")
                    let viewModels = apiMovies.map {
                        MovieViewModel(from: $0)
                    }
                    self?.movieCache = viewModels
                    self?.movies = viewModels
                    JSONCache.shared.save(apiMovies)
                    
                    for movie in apiMovies {
                        if let id = movie.id {
                            MovieDetailCache.shared.save(movie, for: id)
                        }
                    }
                    self?.onMoviesUpdated?()
                case .failure(_):
                    print("erro na api")
                    self?.onError?("Occur an error when loading all movies. Try again")
                }
            }
        }
    }
    
    func clearCache() {
        movieCache = nil
        JSONCache.shared.clearCache()
    }
    
    func loadMovie(withId id: String) {
        if let model = MovieDetailCache.shared.load(for: id) {
            self.movie = MovieViewModel(from: model)
            self.onMoviesUpdated?()
        } else {
            self.onError?("Movie not found/")
        }
    }
}
