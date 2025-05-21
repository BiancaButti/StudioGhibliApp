import Foundation

extension JSONCache: CacheProtocol {}

class JSONCache {
    static let shared = JSONCache()
    
    func save<T: Encodable>(_ items: T) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: fileURL)
        } catch {
            print(NSLocalizedString("failure_error_save_cache",
                                    comment: ""))
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
            print(NSLocalizedString("failure_error_clean_cache",
                                    comment: ""))
        }
    }
}

#if DEBUG
extension JSONCache {
    var fileURL: URL {
        FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("cachedItems.json")
    }
}
#endif
