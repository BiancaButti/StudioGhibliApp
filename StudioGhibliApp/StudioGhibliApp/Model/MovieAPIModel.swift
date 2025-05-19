import Foundation

struct MovieAPIModel: Codable {
    let id: String?
    let title: String?
    let originalTitle: String?
    let originalTitleRomanised: String?
    let image: String?
    let movieBanner: String?
    let description: String?
    let producer: String?
    let releaseDate: String?
    let runningTime: String?
    let ratingScore: String?
    let people: [String]?
    let species: [String]?
    let locations: [String]?
    let vehicles: [String]?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case originalTitleRomanised = "original_title_romanised"
        case image
        case movieBanner = "movie_banner"
        case description
        case producer
        case releaseDate = "release_date"
        case runningTime = "running_time"
        case ratingScore = "rt_score"
        case people
        case species
        case locations
        case vehicles
        case url
    }
}
