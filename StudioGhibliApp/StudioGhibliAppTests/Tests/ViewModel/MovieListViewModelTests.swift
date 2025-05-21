import XCTest
@testable import StudioGhibliApp

final class MovieListViewModelTests: XCTestCase {
    private var viewModel: MovieListViewModel!
    private var mockAPI: MockAPIService!
    private var mockCache: MockCache!
    private var mockDetailCache: MockDetailCache!
    
    override func setUp() {
        super.setUp()
        mockAPI = MockAPIService()
        mockCache = MockCache()
        mockDetailCache = MockDetailCache()
        viewModel = MovieListViewModel(
            apiService: mockAPI,
            jsonCache: mockCache,
            detailCache: mockDetailCache
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        mockCache = nil
        mockDetailCache = nil
        super.tearDown()
    }
    
    func testFetchMoviesFromAPISuccess() {
        // Given
        let expectation = expectation(description: "Movies fetched")
        mockAPI.result = .success([
            MovieAPIModel(
                id: "1",
                title: "Title Test",
                originalTitle: "Original Title Test",
                originalTitleRomanised: "Original Titlte Romanised Test",
                image: "Image Test",
                movieBanner: "Movie Banner Test",
                description: "Description Test",
                producer: "Producer Test",
                releaseDate: "Release Date Test",
                runningTime: "Running Time Test",
                ratingScore: "Rating Score Test",
                people: ["People Test"],
                species: ["Species Test"],
                locations: ["Locations Test"],
                vehicles: ["Vehicles Test"],
                url: "URL test")
        ])
        
        viewModel.onMoviesUpdated = {
            expectation.fulfill()
        }
        
        // When
        viewModel.fetchListMovies()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "Title Test")
    }
    
    func testFetchMoviesApiFailureFallbackToCache() {
        // Given
        let expectation = expectation(description: "Movies loaded from cache")
        
        let cachedMovie =
            MovieAPIModel(
                id: "1",
                title: "Title Test",
                originalTitle: "Original Title Test",
                originalTitleRomanised: "Original Titlte Romanised Test",
                image: "Image Test",
                movieBanner: "Movie Banner Test",
                description: "Description Test",
                producer: "Producer Test",
                releaseDate: "Release Date Test",
                runningTime: "Running Time Test",
                ratingScore: "Rating Score Test",
                people: ["People Test"],
                species: ["Species Test"],
                locations: ["Locations Test"],
                vehicles: ["Vehicles Test"],
                url: "URL test")
        
        mockCache.save([cachedMovie])
        mockAPI.result = .failure(NSError(domain: "", code: -1))
        viewModel.onMoviesUpdated = {
            expectation.fulfill()
        }
        
        // When
        viewModel.fetchListMovies()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "Title Test")
    }
    
    func testFetchMoviesApiFailureAndNoCacheShouldShowError() {
        // Given
        let expectation = expectation(description: "Error closure called")
        
        mockAPI.result = .failure(NSError(domain: "", code: -1))
        mockCache.clearCache()
        mockCache.storage = nil
        
        var capturedMessage: String?
        viewModel.onError = { message in
            capturedMessage = message
            expectation.fulfill()
        }
        // When
        viewModel.fetchListMovies()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(capturedMessage, "Ocorreu um erro ao carregar os filmes. Tente novamente.")
    }
    
    func testLoadMovieWithValidIDShouldLoadFromDetailCache() {
        // Given
        let movieID = "123"
        let apiModel =
            MovieAPIModel(
                id: "1",
                title: "Title Test",
                originalTitle: "Original Title Test",
                originalTitleRomanised: "Original Titlte Romanised Test",
                image: "Image Test",
                movieBanner: "Movie Banner Test",
                description: "Description Test",
                producer: "Producer Test",
                releaseDate: "Release Date Test",
                runningTime: "Running Time Test",
                ratingScore: "Rating Score Test",
                people: ["People Test"],
                species: ["Species Test"],
                locations: ["Locations Test"],
                vehicles: ["Vehicles Test"],
                url: "URL test")
        mockDetailCache.save(apiModel, for: movieID)
        
        let expectation = expectation(description: "Movie loaded from detail cache")
        viewModel.onMoviesUpdated = {
            expectation.fulfill()
        }
        
        // When
        viewModel.loadMovie(withId: movieID)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.selectedMovie?.title, "Title Test")
    }
    
    func testLoadMovieWithInvalidIDShouldTriggerError() {
        // Given
        let invalidID = "nao_existe"
        let expectation = expectation(description: "onError chamado para ID invalido")
        
        viewModel.onError = { message in
            XCTAssertEqual(message, "Filme não encontrado!")
            expectation.fulfill()
        }
        
        // When
        viewModel.loadMovie(withId: invalidID)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(viewModel.selectedMovie)
    }
}
