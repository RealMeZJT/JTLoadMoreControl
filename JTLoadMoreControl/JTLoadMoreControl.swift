//
//  JTLoadMoreControl.swift
//  JTLoadMoreControl
//
//  Created by ZhouJiatao on 10/02/2017.
//  Copyright © 2017 ZhouJiatao. All rights reserved.
//

import UIKit

class JTLoadMoreControl: UIView {

    public enum JTLoadMoreControlState {
        case idle //空闲
        case loading //加载中
        case noMoreData //没有更多数据
        case PleaseTryAgain //请重试（加载失败后的状态）
    }
    
    public private(set) var state: JTLoadMoreControlState = .idle {
        didSet {
            if oldValue != state {
                updateUI(byState: state)
            }
        }
    }
    
    public var textFont = UIFont.systemFont(ofSize: 14)
    public var textColor = UIColor.black
    
    
    var superScrollView: UIScrollView? {
        didSet {
            self.superScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    
    //MARK: - life cycle
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

    
    override func layoutSubviews() {
        super.layoutSubviews()
        config()
    }
    
    
    //MARK: - config UI
    //搭建；只在初始化时调用。
    private func setup() {
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        stateButton.addSubview(activityIndicator)
        
        stateButton.titleLabel?.font = textFont
        stateButton.setTitleColor(textColor, for: .normal)
        stateButton.addTarget(self,
                              action: #selector(onStateButtonClick),
                              for: .touchUpInside)
        addSubview(stateButton)
        
    }
    
    //配置
    private func config() {
        let indicatorOrigin = CGPoint(x: 0,
                                      y: (stateButton.frame.height - activityIndicator.frame.height) / 2)
        activityIndicator.frame = CGRect(origin: indicatorOrigin,
                                         size: activityIndicator.bounds.size)
        
        let leftInset = activityIndicator.isAnimating
            ? activityIndicator.frame.width
            : 0
        stateButton.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                     left: leftInset,
                                                     bottom: 0,
                                                     right: 0)
        stateButton.center = CGPoint(x: bounds.width / 2,
                                     y: bounds.height / 2)
    }

    //根据state更新UI
    private func updateUI(byState state: JTLoadMoreControlState) {
        switch state {
        case .loading:
            stateButton.setTitle("正在加载…", for: .normal)
            activityIndicator.startAnimating()
            break
        case .noMoreData:
            stateButton.setTitle("没有数据了", for: .normal)
            activityIndicator.stopAnimating()
            break
        case .PleaseTryAgain:
            stateButton.setTitle("加载失败，请重试", for: .normal)
            activityIndicator.stopAnimating()
            break
        default:
            break
        }
        
        stateButton.sizeToFit()
    }
    
    //MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            updateStateIfNeeded()
        }
    }
    
    //MARK: -

    func onStateButtonClick() {
        
    }
    
    private func updateStateIfNeeded() {
        guard let superScrollView = superScrollView else {return}
        
        let isReachBottom = superScrollView.contentOffset.y >= (superScrollView.contentSize.height - superScrollView.frame.height)
        
        if isReachBottom && (state == .idle) {
            state = .loading
        }
    }

    //找到容纳次控件的 scrollview
    private func findSuperScrollView(forView v:UIView) -> UIScrollView? {
        guard let container = v.superview else { return nil }
        
        if let scrollView = container as? UIScrollView {
            return scrollView
        } else {
            return findSuperScrollView(forView: container)
        }
    }
    
    //MARK: - public method
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

