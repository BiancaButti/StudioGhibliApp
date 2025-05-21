import Foundation
@testable import StudioGhibliApp

final class MockCache: CacheProtocol {
    var storage: Data?
    
    func save<T>(_ object: T) where T : Encodable {
        storage = try? JSONEncoder().encode(object)
    }
    
    func load<T>(_ type: T.Type) -> T? where T : Decodable {
        guard let data = storage else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    func clearCache() {
        storage = nil
    }
}
