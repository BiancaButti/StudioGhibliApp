import Foundation

class JSONCache {
    static let shared = JSONCache()
    
    private var fileURL: URL {
        FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask).first!.appendingPathExtension("cachedItems.json")
    }
    
    func save<T: Encodable>(_ items: T) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: fileURL)
        } catch {
            print("Error to save JSON cache")
        }
    }
    
    func load<T: Decodable>(_ type: T.Type) -> T? {
        do {
            let data = try Data(contentsOf: fileURL)
            let items = try JSONDecoder().decode(type, from: data)
            return items
        } catch {
            return nil
        }
    }
    
    func clearCache() {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error on clean cache")
        }
    }
}
