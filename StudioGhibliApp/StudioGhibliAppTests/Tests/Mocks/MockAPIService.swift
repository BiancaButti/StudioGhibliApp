import Foundation
@testable import StudioGhibliApp

final class MockAPIService: APIServiceProtocol {
    var result: Result<[MovieAPIModel], Error>?
    
    func fetchMovies(completion: @escaping (Result<[StudioGhibliApp.MovieAPIModel], Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
    
    
}
