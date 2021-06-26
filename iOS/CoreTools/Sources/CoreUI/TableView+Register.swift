import UIKit

public extension UITableView {
    
    func register(_ type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(type, forCellReuseIdentifier: cellId)
    }
    
    func dequeue<T: UITableViewCell>() -> T {
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }
    
}

public extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
