import Foundation

protocol ContentDisplayable: AnyObject {
    func showContent(model: Any?)
    func setLoading()
    func setHidden(_ hidden: Bool)
}
