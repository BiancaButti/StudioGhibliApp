import Foundation

class APIService: CommonService, APIServiceProtocol {
    
    override init() {
        super.init()
        component = URLComponents(string: "https://ghibliapi.vercel.app/films/")
    }
    
    func fetchMovies(completion: @escaping(Result<[MovieAPIModel], Error>) -> Void) {
        guard let url = component?.url else {
            return
        }
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                let statusError = NSError(domain: NSLocalizedString("failure_invalid_response",
                                                                    comment: ""),
                                          code: 0)
                completion(.failure(statusError))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([MovieAPIModel].self, from: data)
                completion(.success(decoded))
            }
            catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
