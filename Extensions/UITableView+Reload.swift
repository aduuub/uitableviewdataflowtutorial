//
//  UITableView+Reload.swift
//  TableViewDataFlow
//
//  Created by Adam Wareing on 20/09/19.
//

import UIKit

extension UITableView {
    
    func reloadWithAnimation<T: Equatable>(oldValues: [T], newValues: [T], using animation: RowAnimation = .fade) {
        let sectionUpdates = TableViewUpdate.compareSections(oldValues: [oldValues], newValues: [newValues])
        reloadDataWithAnimation(with: sectionUpdates, using: animation)
    }
    
    func reloadWithAnimation<T: Equatable>(oldValues: [[T]], newValues: [[T]], using animation: RowAnimation = .fade) {
        let sectionUpdates = TableViewUpdate.compareSections(oldValues: oldValues, newValues: newValues)
        reloadDataWithAnimation(with: sectionUpdates, using: animation)
    }
    
    private func reloadDataWithAnimation(with batchUpdates: [TableViewUpdate], using animation: RowAnimation) {
        if animation == .none {
            UIView.setAnimationsEnabled(false)
        }
        
        beginUpdates()
        for (section, sectionUpdates) in batchUpdates.enumerated() {
            insertRows(at: sectionUpdates.inserted.map { $0.indexPath(section: section) }, with: animation)
            deleteRows(at: sectionUpdates.deleted.map { $0.indexPath(section: section) }, with: animation)
            reloadRows(at: sectionUpdates.reloaded.map { $0.indexPath(section: section) }, with: animation)
            
            for movedRows in sectionUpdates.moved {
                moveRow(at: IndexPath(row: movedRows.0, section: section),
                        to: IndexPath(row: movedRows.1, section: section))
            }
        }
        
        endUpdates()
        if animation == .none {
            UIView.setAnimationsEnabled(true)
        }
    }
}

// MARK: UITableView update object

fileprivate struct TableViewUpdate {
    let deleted: [Int]
    let inserted: [Int]
    let moved: [(Int, Int)]
    let reloaded: [Int]
    
    static func compare<T: Equatable>(oldValues: [T], newValues: [T]) -> TableViewUpdate {
        var deleted = [Int]()
        var moved = [(Int, Int)]()
        var remainingNewValues = newValues.enumerated().map { (element: $0.element, offset: $0.offset, alreadyFound: false) }
        
        outer: for oldValue in oldValues.enumerated() {
            for newValue in remainingNewValues {
                if oldValue.element == newValue.element && !newValue.alreadyFound {
                    if oldValue.offset != newValue.offset {
                        moved.append((oldValue.offset, newValue.offset))
                    }
                    
                    remainingNewValues[newValue.offset].alreadyFound = true
                    continue outer
                }
            }
            deleted.append(oldValue.offset)
        }
        
        let inserted = remainingNewValues
            .filter { !$0.alreadyFound }
            .map { $0.offset }
        
        return TableViewUpdate(deleted: deleted, inserted: inserted, moved: moved, reloaded: [])
    }
    
    static func compareSections<T: Equatable>(oldValues: [[T]], newValues: [[T]]) -> [TableViewUpdate] {
        let maxNumSections = max(oldValues.count, newValues.count)
        var batchUpdates: [TableViewUpdate] = []
        for section in 0..<maxNumSections {
            let update = TableViewUpdate.compare(oldValues: oldValues[section, default: []],
                                                 newValues: newValues[section, default: []])
            batchUpdates.append(update)
        }
        return batchUpdates
    }
}

// MARK: Mapping extension

extension Int {
    func indexPath(section: Int) -> IndexPath {
        return IndexPath(row: self, section: section)
    }
}

// MARK: Extension for safely accessing collections

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds and nil otherwise.
    /// (See https://stackoverflow.com/a/30593673)
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// Returns the element at the specified index if it is within bounds and the default value otherwise.
    subscript(index: Index, default defaultValue: Element) -> Element {
        return indices.contains(index) ? self[index] : defaultValue
    }
}
