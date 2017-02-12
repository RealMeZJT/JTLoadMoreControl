//
//  FakeCommunicator.swift
//  JTLoadMoreControl
//
//  Created by ZhouJiatao on 11/02/2017.
//  Copyright © 2017 ZhouJiatao. All rights reserved.
//

import Foundation


protocol FakeCommunicatorDelegate {
    func onFetchSuccess(newTitles:[String],page:Int)
    func onFetchFailed()
}

class FakeCommunicator {
    
    struct Contants {
        static var pageSize:Int = 10
        static var totalpage: Int = 3
    }
    
    var awaylFetchFaild = false
    var delegate: FakeCommunicatorDelegate?
    
    let pageSize:Int = 10
    func fetchPage(page:Int) {
        
    
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            [unowned self] in
            if self.awaylFetchFaild {
                self.delegate?.onFetchFailed()
            } else if page < Contants.totalpage {
                self.delegate?.onFetchSuccess(newTitles: self.createFakeTitles(byPage: page),page:page)
            } else {
                self.delegate?.onFetchSuccess(newTitles: [],page:page)
            }
            
        }
        
        
    }
    
    private func createFakeTitles(byPage page:Int) -> [String] {
        var fakeResult: [String] = []
        let startIndex = page * Contants.pageSize
        for i in 0...(pageSize-1) {
            fakeResult.append("hello \(startIndex + i)")
        }
        return fakeResult
    }

    
}
