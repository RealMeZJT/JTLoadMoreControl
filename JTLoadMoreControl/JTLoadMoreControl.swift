//
//  JTLoadMoreControl.swift
//  JTLoadMoreControl
//
//  Created by ZhouJiatao on 10/02/2017.
//  Copyright © 2017 ZhouJiatao. All rights reserved.
//

import UIKit

class JTLoadMoreControl: UIControl {

    public enum JTLoadMoreControlState {
        case idle //空闲
        case loading //加载中
        case noMoreData //没有更多数据
        case PleaseTryAgain //请重试（加载失败后的状态）
    }
    
    public private(set) var jt_state: JTLoadMoreControlState = .idle {
        didSet {
            if oldValue != jt_state {
                updateUI(byState: jt_state)
            }
            if jt_state == .loading {
                self.sendActions(for: .valueChanged)
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
    
    
    private var jt_stateButton = UIButton()
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
        jt_stateButton.addSubview(activityIndicator)
        
        jt_stateButton.titleLabel?.font = textFont
        jt_stateButton.setTitleColor(textColor, for: .normal)
        jt_stateButton.addTarget(self,
                              action: #selector(onStateButtonClick),
                              for: .touchUpInside)
        addSubview(jt_stateButton)
        
    }
    
    //配置
    private func config() {
        let indicatorOrigin = CGPoint(x: 0,
                                      y: (jt_stateButton.frame.height - activityIndicator.frame.height) / 2)
        activityIndicator.frame = CGRect(origin: indicatorOrigin,
                                         size: activityIndicator.bounds.size)
        
        let leftInset = activityIndicator.isAnimating
            ? activityIndicator.frame.width
            : 0
        jt_stateButton.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                     left: leftInset,
                                                     bottom: 0,
                                                     right: 0)
        jt_stateButton.center = CGPoint(x: bounds.width / 2,
                                     y: bounds.height / 2)
    }

    //根据jt_state更新UI
    private func updateUI(byState jt_state: JTLoadMoreControlState) {
        switch jt_state {
        case .loading:
            jt_stateButton.setTitle("正在加载…", for: .normal)
            activityIndicator.startAnimating()
            break
        case .noMoreData:
            jt_stateButton.setTitle("没有数据了", for: .normal)
            activityIndicator.stopAnimating()
            break
        case .PleaseTryAgain:
            jt_stateButton.setTitle("加载失败，请重试", for: .normal)
            activityIndicator.stopAnimating()
            break
        default:
            break
        }
        
        jt_stateButton.sizeToFit()
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
        
        if isReachBottom && (jt_state == .idle) {
            jt_state = .loading
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
        jt_state = .idle
    }
    
    public func endLoadingDueToFailed() {
        jt_state = .PleaseTryAgain
    }
    
    public func endLoadingDueToNoMoreData() {
        jt_state = .noMoreData
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}

