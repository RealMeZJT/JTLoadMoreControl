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
        case pleaseTryAgain //请重试（加载失败后的状态）
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
    
    public var loadingText = "正在加载…"
    public var noMoreDataText = "没有数据了"
    public var pleaseTryAgainText = "点击重试"
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
        addSubview(activityIndicator)
        
        jt_stateButton.titleLabel?.font = textFont
        jt_stateButton.setTitleColor(textColor, for: .normal)
        jt_stateButton.clipsToBounds = true
        jt_stateButton.addTarget(self,
                              action: #selector(onStateButtonClick),
                              for: .touchUpInside)
        addSubview(jt_stateButton)
        
    }
    
    //配置
    private func config() {
        
        //为了让 jt_stateButton 和 activityIndicator 整体居中
        let btnCenterOffset = activityIndicator.isAnimating
            ? activityIndicator.frame.width / 2
            : 0
        
        jt_stateButton.center = CGPoint(x: (frame.width / 2) + btnCenterOffset,
                                     y: frame.height / 2)
        
        let indicatorOrigin = CGPoint(x: jt_stateButton.frame.minX - activityIndicator.frame.size.width,
                                      y: (frame.height - activityIndicator.frame.height) / 2)
        activityIndicator.frame = CGRect(origin: indicatorOrigin,
                                         size: activityIndicator.bounds.size)
    }

    //根据jt_state更新UI
    private func updateUI(byState jt_state: JTLoadMoreControlState) {
        jt_stateButton.isHidden = jt_state == .idle
        jt_stateButton.isEnabled = jt_state == .pleaseTryAgain
        
        switch jt_state {
        case .loading:
            jt_stateButton.setTitle(loadingText, for: .normal)
            activityIndicator.startAnimating()
            break
        case .noMoreData:
            jt_stateButton.setTitle(noMoreDataText, for: .normal)
            activityIndicator.stopAnimating()
            break
        case .pleaseTryAgain:
            jt_stateButton.setTitle(pleaseTryAgainText, for: .normal)
            activityIndicator.stopAnimating()
            break
        default:
            jt_stateButton.setTitle("", for: .normal)
            activityIndicator.stopAnimating()
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
        jt_state = .loading
    }
    
    private func updateStateIfNeeded() {
        guard let superScrollView = superScrollView else {return}
        guard superScrollView.contentOffset.y > 0 else {return}
        
        let isReachBottom = superScrollView.contentOffset.y >= (superScrollView.contentSize.height - superScrollView.frame.height)
        
        if isReachBottom && (jt_state == .idle){
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
        jt_state = .pleaseTryAgain
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

