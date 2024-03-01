//
//  Reusable.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import UIKit

public protocol Reusable: AnyObject {
    static var reuseID: String { get }
}

public extension Reusable {
    static var reuseID: String {
        return String(describing: Self.self)
    }
}

extension UICollectionView {
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseID)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell with identifier: \(T.reuseID)")
        }
        return cell
    }
    func registerReusableSupplementaryView<T: UICollectionReusableView>(elementKind: String,
                                                                        _: T.Type) where T: Reusable {
        self.register(
            T.self,
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: T.reuseID)
    }
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String,
                                                                       for indexPath: IndexPath)
    -> T where T: Reusable {
        guard let view = self.dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: T.reuseID,
            for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable supplementary view with identifier: \(T.reuseID)")
        }
        return view
    }
}

extension UITableView {
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        self.register(T.self, forCellReuseIdentifier: T.reuseID)
    }
    func registerReusableView<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable {
        self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseID)
    }
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell with identifier: \(T.reuseID)")
        }
        return cell
    }
    func dequeueReusableView<T: UITableViewHeaderFooterView>() -> T where T: Reusable {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseID) as? T else {
            fatalError("Failed to dequeue reusable view with identifier: \(T.reuseID)")
        }
        return view
    }
}
