//
//  HeaderCell.swift
//  TableViewDataFlow
//
//  Created by Adam Wareing on 19/09/19.
//

import UIKit

struct HeaderVm: Equatable {
    let title: String
}

class HeaderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(_ viewModel: HeaderVm) {
        titleLabel.text = viewModel.title
    }
}
