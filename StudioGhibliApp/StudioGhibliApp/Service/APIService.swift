import Foundation

class APIService: CommonService {
    
    func fetchMoviesService() {
        guard let url = component?.url else { return }
        var request = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                // TODO: return message error
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                // TODO: return status code
                return
            }
            
            guard let data = data else { return }
            do {
                let apiData = try JSONDecoder().decode([APIModel].self, from: data)
                for item in apiData {
                    print(item)
                }
            }
            catch {
                if String(data: data, encoding: .utf8) != nil {
                    print("JSON recebido")
                }
            }
        }
        dataTask.resume()
    }
}
