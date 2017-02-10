//
//  JTLoadMoreControl.swift
//  JTLoadMoreControl
//
//  Created by ZhouJiatao on 10/02/2017.
//  Copyright © 2017 ZhouJiatao. All rights reserved.
//

import UIKit

class JTLoadMoreControl: UIView {
    
    
    
    var superScrollView: UIScrollView? {
        didSet {
            self.superScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        superScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        superScrollView = findSuperScrollView(forView: self)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
    }
    
    
    
    private func setup() {
        //test code
        self.backgroundColor = UIColor.brown
        
        //
        
    }
    
    
    private func findSuperScrollView(forView v:UIView) -> UIScrollView? {
        guard let container = v.superview else { return nil }
        
        if let scrollView = container as? UIScrollView {
            return scrollView
        } else {
            return findSuperScrollView(forView: container)
        }
    }
    
    
    //MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(keyPath)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
