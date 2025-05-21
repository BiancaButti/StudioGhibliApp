import Foundation
@testable import StudioGhibliApp

final class MockDetailCache: DetailCacheProtocol {
    private var storage: [String: MovieAPIModel] = [:]
    func save(_ object: StudioGhibliApp.MovieAPIModel, for id: String) {
        storage[id] = object
    }
    
    func load(for id: String) -> StudioGhibliApp.MovieAPIModel? {
        return storage[id]
    }
}
