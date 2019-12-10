//
//  AccountViewController.swift
//  Drive
//
//  Created by Adam Wareing on 19/09/19.
//  Copyright © 2019 Adam Wareing. All rights reserved.
//

import UIKit

protocol AccountViewProtocol: AnyObject {
    func reloadTableView(viewModels: [AccountVm], withAnimation animation: Bool)
}

class AccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let presenter = AccountPresenter()
    private var viewModels: [AccountVm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(HeaderCell.self)
        tableView.register(SkillCell.self)
        
        presenter.view = self
        presenter.start()
    }
}

// MARK: View extension

extension AccountViewController: AccountViewProtocol {
    
    func reloadTableView(viewModels: [AccountVm], withAnimation animation: Bool) {
        // Animate cell reload
        DispatchQueue.main.async {
            let oldViewModels = self.viewModels
            self.viewModels = viewModels
            self.tableView.reloadWithAnimation(oldValues: oldViewModels, newValues: viewModels, using: animation ? .fade : .none)
        }
    }
}

// MARK: UITableViewDelgate

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModels[indexPath.row] {
        
        case .header(let viewModel):
            let cell: HeaderCell = tableView.dequeueCell(for: indexPath)
            cell.setup(viewModel)
            return cell
            
        case .skill(let viewModel):
            let cell: SkillCell = tableView.dequeueCell(for: indexPath)
            cell.setup(viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModels[indexPath.row] {
        case .header:
            presenter.headerTapped()
        case .skill(let viewModel):
            presenter.skillTapped(id: viewModel.id)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch viewModels[indexPath.row] {
        case .header:
            return false
        case .skill:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        self.presenter.deleteItem(at: indexPath.row)
    }
}
