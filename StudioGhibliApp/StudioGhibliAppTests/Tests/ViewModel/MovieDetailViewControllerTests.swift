import XCTest
@testable import StudioGhibliApp

final class MovieDetailViewControllerTests: XCTestCase {
    
    var sut: MovieDetailViewController!
    
    override func setUp() {
        super.setUp()
        sut = MovieDetailViewController()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testConfigureWithValidModelShouldShowContent() {
        // Given
        sut.loadViewIfNeeded()
        let mockModel = MovieViewData(
            from:
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
        )
        
        // When
        sut.configure(with: mockModel)
        
        // Then
        let expectation = expectation(description: "Estado .content aplicado")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            XCTAssertFalse(self.sut.view.subviews.contains { $0.isHidden })
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testConfigureWithNilModelShouldShowErrorState() {
        // Given
        sut.loadViewIfNeeded()
        
        // When
        sut.configure(with: nil)
        
        // Then
        let expectation = expectation(description: "Estado .error aplicado")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            let emptyState = self.sut.view.subviews.first(where: { $0 is EmptyStateView })
            XCTAssertNotNil(emptyState)
            XCTAssertFalse(emptyState?.isHidden ?? true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testConfigureShouldRetryAndShowContentOnRetryTap() {
        // Given
        sut.loadViewIfNeeded()
        sut.view.layoutIfNeeded()
        
        let mockModel = MovieViewData(
            from:
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
        )
        sut.configure(with: mockModel)
        let retryExpectation = expectation(description: "Estado de conteúdo aplicado após retry")
        
        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            guard let emptyState = self.sut.view.subviews
                .compactMap({ $0 as? EmptyStateView })
                .first else {
                XCTFail("EmptyStateView não encontrado")
                return
            }
            self.sut.view.layoutIfNeeded()
            
            emptyState.onRetry?()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                guard let contentView = self.sut.view.subviews
                    .compactMap({ $0 as? UIScrollView })
                    .first?.subviews
                    .compactMap({ $0 as? MovieDetailContentView })
                    .first else {
                    XCTFail("ContentView não encontrado")
                    return
                }
                XCTAssertFalse(contentView.isHidden, "ContentView deveria estar visível após retry")
                retryExpectation.fulfill()
            }
        }
        
        // Then
        wait(for: [retryExpectation], timeout: 5.0)
    }
}
