import Foundation

protocol APIServiceProtocol {
    func fetchMovies(completion: @escaping (Result<[MovieAPIModel], Error>) -> Void)
}
