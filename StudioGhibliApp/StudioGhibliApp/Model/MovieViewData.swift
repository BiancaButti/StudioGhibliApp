import Foundation

struct MovieViewData {
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
    
    init(from apiModel: MovieAPIModel) {
        self.id = apiModel.id
        self.title = apiModel.title
        self.originalTitle = apiModel.originalTitle
        self.imageURL = apiModel.image.flatMap { URL(string: $0) }
        self.description = apiModel.description
        self.producer = apiModel.producer
        self.releaseDate = apiModel.releaseDate
        self.runningTime = apiModel.runningTime
        self.ratingScore = apiModel.ratingScore
        self.people = apiModel.people
    }
}
