import Foundation

extension MovieDetailContentView: ContentDisplayable {
    func showContent(model: Any?) {
        guard let model = model as? MovieViewData else {
            return
        }
        configure(with: model)
    }
    
    func setLoading() {
        showSkeleton()
    }
    
    func setHidden(_ hidden: Bool) {
        self.isHidden = hidden
    }
}
