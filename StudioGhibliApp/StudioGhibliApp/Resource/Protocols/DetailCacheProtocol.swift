import Foundation

protocol DetailCacheProtocol {
    func save(_ object: MovieAPIModel, for id: String)
    func load(for id: String) -> MovieAPIModel?
}
