//
//  UITableView+Extensions.swift
//  TableViewDataFlow
//
//  Created by Adam Wareing on 19/09/19.
//

import UIKit

extension UITableView {
    internal func dequeueCell<T: UITableViewCell> (for indexPath: IndexPath, withIdentifier reuseIdentifier: String) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell of  type \(T.self)")
        }
        return cell
    }
    
    internal func dequeueCell<T: UITableViewCell> (for indexPath: IndexPath) -> T {
        return dequeueCell(for: indexPath, withIdentifier: T.reuseIdentifier)
    }
    
    internal func register(_ type: UITableViewCell.Type) {
        register(UINib(nibName: type.nibName, bundle: nil), forCellReuseIdentifier: type.reuseIdentifier)
    }
}

extension UITableViewCell {
    
    static var cellName: String! {
        return String(reflecting: self.self)
    }
    
    static var reuseIdentifier: String! {
        return String(reflecting: self.self)
    }
    
    var reuseIdentifier: String? {
        return String(reflecting: type(of: self.self))
    }
    
    static var nibName: String! {
        return String(describing: self)
    }
}
