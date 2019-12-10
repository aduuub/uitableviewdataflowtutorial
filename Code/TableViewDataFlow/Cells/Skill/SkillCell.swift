//
//  SkillCell.swift
//  TableViewDataFlow
//
//  Created by Adam Wareing on 19/09/19.
//

import UIKit

struct SkillVm: Equatable {
    let id: String
}

class SkillCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    
    func setup(_ viewModel: SkillVm) {
        idLabel.text = "Skill id: \(viewModel.id)"
        if viewModel.id == "ADDED_SKILL" {
            backgroundColor = .red
        } else {
            backgroundColor = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
        }
    }
}
