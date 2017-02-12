//
//  FakeModel.swift
//  JTLoadMoreControl
//
//  Created by ZhouJiatao on 11/02/2017.
//  Copyright © 2017 ZhouJiatao. All rights reserved.
//

import Foundation

class FakeTableModel {
    var currentPage = 0
    
    var titles:[String] = []
    
    func reset() {
        currentPage = 0
        titles = []
    }
    
    func append(newTitles:[String]) {
        titles.append(contentsOf: newTitles)
    }
    
}
