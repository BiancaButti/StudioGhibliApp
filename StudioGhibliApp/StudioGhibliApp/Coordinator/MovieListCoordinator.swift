import UIKit

final class MovieListCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let movieListViewController = MovieListViewController()
        movieListViewController.coordinator = self
        navigationController.pushViewController(movieListViewController, animated: true)
    }
    
    func showMovieDetailView(for movie: MovieViewModel) {
        let detailViewController = MovieDetailViewController()
        detailViewController.configure(with: nil)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
