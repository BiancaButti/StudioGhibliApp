import Foundation

protocol CacheProtocol {
    func save<T: Encodable>(_ object: T)
    func load<T: Decodable>(_ type: T.Type) -> T?
    func clearCache()
}
