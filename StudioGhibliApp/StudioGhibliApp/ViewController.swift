import UIKit

class ViewController: UIViewController {
    
    let apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiService.fetchMoviesService()
    }


}

