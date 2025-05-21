import XCTest
@testable import StudioGhibliApp

final class JSONCacheTests: XCTestCase {
    var sut: JSONCache!
    
    override func setUp() {
        super.setUp()
        sut = JSONCache()
    }
    
    override func tearDown() {
        sut.clearCache()
        sut = nil
        super.tearDown()
    }
    
    func testSaveAndLoadShouldPersistData() {
        // Given
        let movie = MovieAPIModel(
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
        
        let movieArray = [movie]
        
        // Whn
        sut.save(movieArray)
        let loaded: [MovieAPIModel]? = sut.load([MovieAPIModel].self)
        
        // Then
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.count, 1)
        XCTAssertEqual(loaded?.first?.title, "Title Test")
    }
    
    func testClearCacheShouldRemoveFileFromDisk() {
        // Given
        let movie = MovieAPIModel(
            id: "2",
            title: "Cache Clear Test",
            originalTitle: "",
            originalTitleRomanised: "",
            image: "",
            movieBanner: "",
            description: "",
            producer: "",
            releaseDate: "",
            runningTime: "",
            ratingScore: "",
            people: [""],
            species: [""],
            locations: [""],
            vehicles: [""],
            url: "")
        sut.save([movie])
        
        // When
        sut.clearCache()
        
        // Then
        let loaded: [MovieAPIModel]? = sut.load([MovieAPIModel].self)
        XCTAssertNil(loaded)
    }
    
    func testLoadWithInvalidDataShouldReturnNil() {
        // Given
        let invalidData = Data([0x00, 0x01])
        try? invalidData.write(to: sut.fileURL)
        
        // When
        let result: [MovieAPIModel]? = sut.load([MovieAPIModel].self)
        
        // Then
        XCTAssertNil(result)
    }
}
