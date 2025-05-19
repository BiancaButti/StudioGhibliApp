import Foundation

enum ViewState {
    case loading
    case content
    case empty(message: String)
    case error(message: String)
}
