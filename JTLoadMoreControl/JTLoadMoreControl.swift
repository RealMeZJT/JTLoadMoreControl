//
//  JTLoadMoreControl.swift
//  JTLoadMoreControl
//
//  Created by ZhouJiatao on 10/02/2017.
//  Copyright © 2017 ZhouJiatao. All rights reserved.
//

import UIKit

class JTLoadMoreControl: UIView {
    
    enum JTLoadMoreControlState {
        case idle //空闲
        case loading //加载中
        case noMoreData //没有更多数据
        case PleaseTryAgain //请重试（加载失败后的状态）
    }
    
    public private(set) var state: JTLoadMoreControlState = .idle {
        didSet {
            if oldValue != state {
                updateUI()
            }
        }
    }
    
    
    var superScrollView: UIScrollView? {
        didSet {
            self.superScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0,
                                y: 0,
                                width: UIScreen.main.bounds.width,
                                height: 44))
        
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
    
    
    private var stateButton = UIButton()
    private var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private func setup() {
        self.backgroundColor = UIColor.brown
        
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        stateButton.addSubview(activityIndicator)
        
                stateButton.setTitle("正在加载…", for: .normal)
        stateButton.sizeToFit()
        stateButton.addTarget(self,
                              action: #selector(onStateButtonClick),
                              for: .touchUpInside)
        addSubview(stateButton)
        
        
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.frame = CGRect(origin: CGPoint.zero,
                                         size: activityIndicator.bounds.size)
        stateButton.center = CGPoint(x: bounds.width / 2,
                                     y: bounds.height / 2)
        let leftInset = activityIndicator.isAnimating ? activityIndicator.frame.width : 0
        stateButton.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                     left: leftInset,
                                                     bottom: 0,
                                                     right: 0)
        
    }
    
    private func updateUI() {
        switch state {
        case .loading:
            stateButton.setTitle("正在加载…", for: .normal)
            activityIndicator.startAnimating()
            break
        case .noMoreData:
            stateButton.setTitle("没有更多数据", for: .normal)
            activityIndicator.stopAnimating()
            break
        case .PleaseTryAgain:
            stateButton.setTitle("请重试…", for: .normal)
            activityIndicator.stopAnimating()
            break
        default:
            break
        }
        
        stateButton.sizeToFit()
    }
    
    func onStateButtonClick() {
        
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
        if keyPath == "contentOffset" {
            updateStateIfNeeded()
        }
    }

    
    private func updateStateIfNeeded() {
        guard let superScrollView = superScrollView else {return}
        
        let isReachBottom = superScrollView.contentOffset.y >= (superScrollView.contentSize.height - superScrollView.frame.height)
        
        if isReachBottom && (state == .idle) {
            state = .loading
        }
    }
    
    
    public func endLoading() {
        state = .idle
    }
    
    public func endLoadingDueToFailed() {
        state = .PleaseTryAgain
    }
    
    public func endLoadingDueToNoMoreData() {
        state = .noMoreData
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
