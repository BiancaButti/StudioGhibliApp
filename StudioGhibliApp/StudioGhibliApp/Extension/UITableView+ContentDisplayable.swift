import UIKit

extension UITableView: ContentDisplayable {
    func showContent(model: Any?) {
        self.reloadData()
    }
    
    func setLoading() { }
    
    func setHidden(_ hidden: Bool) {
        self.isHidden = hidden
    }
}
