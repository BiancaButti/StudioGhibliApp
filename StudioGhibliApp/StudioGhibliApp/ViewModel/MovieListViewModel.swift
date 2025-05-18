import Foundation

final class MovieListViewModel {
    
    private let apiService = APIService()
    private(set) var movies: [MovieViewModel] = []
    
    var onMoviesUpdated: (() -> Void)?
    
    func fetchMovies() {
        apiService.fetchMoviesService { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies.map {
                    MovieViewModel(
                        id: $0.id,
                        title: $0.title,
                        originalTitle: $0.originalTitle,
                        image: $0.image,
                        description: $0.description,
                        producer: $0.producer,
                        releaseDate: $0.releaseDate,
                        runningTime: $0.runningTime,
                        ratingScore: $0.ratingScore,
                        people: $0.people)
                }
                self?.onMoviesUpdated?()
            case .failure(let error):
                print("Error to fetch movies:", error.localizedDescription)
            }
        }
    }
}
