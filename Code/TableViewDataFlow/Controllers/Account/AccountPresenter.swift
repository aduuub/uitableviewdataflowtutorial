//
//  AccountPresenter.swift
//  Drive
//
//  Created by Adam Wareing on 19/09/19.
//  Copyright © 2019 NZ Transport Agency. All rights reserved.
//

import UIKit

/// A view model that represents cells shown on the account view controller
enum AccountVm: Equatable {
    case header(HeaderVm)
    case skill(SkillVm)
}

class AccountPresenter: NSObject {
    
    let contentService = ContentService()
    
    weak var view: AccountViewProtocol?
    var viewModels = [AccountVm]()
    
    func start() {
        createViewModels()
    }
    
    func createViewModels() {
        // Show view models
        viewModels.append(AccountVm.header(HeaderVm(title: "All skills")))
        view?.reloadTableView(viewModels: viewModels, withAnimation: false)
            
        // Make an async request to load skills
        contentService.loadSkills { (skillIds) in
            skillIds.forEach {
                self.viewModels.append(.skill(SkillVm(id: $0)))
            }
            self.view?.reloadTableView(viewModels: self.viewModels, withAnimation: false)
        }
    }
    
    func headerTapped() {
        // Handle action here
    }
    
    func skillTapped(id: String) {
        // Handle action here
    }
    
    func deleteItem(at index: Int) {
        self.viewModels.remove(at: index)
        self.view?.reloadTableView(viewModels: viewModels, withAnimation: true)
    }
}
