import Foundation

class MovieDetailCache {
    static let shared = MovieDetailCache()
    
    private var memoryCache: [String: MovieAPIModel] = [:]
    
    private var fileURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathExtension("movieDetailCache.json")
    }
    
    private init() {
        loadFromDisk()
    }
    
    func save(_ movie: MovieAPIModel, for id: String) {
        memoryCache[id] = movie
        saveToDisk()
    }
    
    func load(for id: String) -> MovieAPIModel? {
        memoryCache[id]
    }
    
    private func saveToDisk() {
        guard let data = try? JSONEncoder().encode(memoryCache) else { return }
        try? data.write(to: fileURL)
    }
    
    private func loadFromDisk() {
        guard let data = try? Data(contentsOf: fileURL),
              let savedCache = try? JSONDecoder().decode([String: MovieAPIModel].self, from: data)
        else {
            return
        }
        memoryCache = savedCache
    }
}
