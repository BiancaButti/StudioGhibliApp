import UIKit

final class AppCoordinator: Coordinator {
    let window: UIWindow
    var navigationController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let splashScreen = SplashScreenViewController()
        splashScreen.onAnimationFinished = { [weak self] in
            self?.starMainFlow()
        }
        window.rootViewController = splashScreen
        window.makeKeyAndVisible()
    }
    

    func showMovieDetailView(for movie: MovieViewData) {
        let detailViewController = MovieDetailViewController()
        detailViewController.configure(with: movie)
        navigationController?.pushViewController(detailViewController,
                                                 animated: true)
    }
    
    private func starMainFlow() {
        let movieListViewController = HomeMovieListViewController()
        movieListViewController.coordinator = self
        let navigationController = UINavigationController(rootViewController: movieListViewController)
        self.navigationController = navigationController
        window.rootViewController = navigationController
    }
}
