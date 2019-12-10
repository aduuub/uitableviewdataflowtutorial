//
//  ContentService.swift
//  TableViewDataFlow
//
//  Created by Adam Wareing on 16/10/19.
//

import Foundation

class ContentService {
    
    typealias SkillsCompletion = ([String]) -> Void
    
    func loadSkills(_ completion: @escaping SkillsCompletion) {
        
        // Simulate async request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            
        }
    }
}
