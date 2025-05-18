import Foundation

struct MovieViewModel {
    let id: String?
    let title: String?
    let originalTitle: String?
    let imageURL: URL?
    let description: String?
    let producer: String?
    let releaseDate: String?
    let runningTime: String?
    let ratingScore: String?
    let people: [String]?
    
    init(id: String? = nil,
         title: String? = nil,
         originalTitle: String? = nil,
         image: String,
         description: String? = nil,
         producer: String? = nil,
         releaseDate: String? = nil,
         runningTime: String? = nil,
         ratingScore: String? = nil,
         people: [String]? = []) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.imageURL = URL(string: image)
        self.description = description
        self.producer = producer
        self.releaseDate = releaseDate
        self.runningTime = runningTime
        self.ratingScore = ratingScore
        self.people = people
    }
}
