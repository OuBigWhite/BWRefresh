//
//  BWRefreshManager.swift
//  BWRefresh
//
//  Created by 冉彬 on 2020/4/23.
//  Copyright © 2020 BigWhite. All rights reserved.
//

import UIKit

let BWContentOffsetKey:String = "contentOffset"
let BWContentSizeKey:String = "contentSize"
let BWStateKey:String = "state"

class BWRefreshManager: NSObject {
    weak var scrollView: UIScrollView?  // 监听的scrollerView
    weak var gesture: UIPanGestureRecognizer?  // 监听手势
    
    
    deinit {
        self.removeObservers()
    }
    
    /// 绑定scrollerView
    /// - Parameter scrollView: scrollerView
    func bindingScrollerView(scrollView: UIScrollView) {
        self.scrollView = scrollView
        if scrollView is UITableView {
            // （预估高度设为0）避免滑动过程中contentSize不断变化， 坑！！！
            (self.scrollView as! UITableView).estimatedRowHeight = 0
        }
        self.addObservers()
    }
    
    /// 添加监听
    func addObservers() {
        self.scrollView?.addObserver(self, forKeyPath: BWContentOffsetKey, options: [.new,.old], context: nil)
        self.scrollView?.addObserver(self, forKeyPath: BWContentSizeKey, options: [.new,.old], context: nil)
        // 监听手势
        self.gesture = self.scrollView?.panGestureRecognizer
        self.gesture?.addObserver(self, forKeyPath: BWStateKey, options: [.new,.old], context: nil)
        
    }
    
    /// 移除监听
    func removeObservers() {
        self.scrollView?.removeObserver(self, forKeyPath: BWContentOffsetKey)
        self.scrollView?.removeObserver(self, forKeyPath: BWContentSizeKey)
        self.gesture?.removeObserver(self, forKeyPath: BWStateKey)
    }
    
    
    /// 监听触发
    /// - Parameters:
    ///   - keyPath: 监听的属性
    ///   - object: 被监听对象
    ///   - change: 改变后的数据
    ///   - context: context
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let scConH = scrollView?.contentSize.height ?? 0
        // content大小发生变化
        if keyPath == BWContentSizeKey {
            var rect = scrollView?.bw_footer?.view.frame
            rect?.origin.y = scConH
            scrollView?.bw_footer?.view.frame = rect!
        }
        
        // content位置改变
        if keyPath == BWContentOffsetKey {
            
            if scrollView?.bw_footer != nil {
                self.contentOffsetKeyChangeFoot()
            }
            if scrollView?.bw_header != nil {
                self.contentOffsetKeyChangeHead()
            }
            
            
        }
        
        // 手势状态发生改变
        if keyPath == BWStateKey {
            if scrollView?.bw_footer != nil {
                if gesture?.state == .ended && scrollView?.bw_footer?.state == .willRefresh  {
                    scrollView?.bw_footer?.state = .refreshing
                }
            }
            
            if scrollView?.bw_header != nil {
                if gesture?.state == .ended {
                    if scrollView?.bw_header?.state == .willRefresh  {
                        scrollView?.bw_header?.state = .refreshing
                    }
                }
            }
            
        }
        
    }
    
    
    
    func contentOffsetKeyChangeHead() {
        let scY = (scrollView?.contentOffset.y ?? 0) + (scrollView?.adjustedContentInset.top ?? 0)
        if (scY + (scrollView?.bw_header?.refreshHeight ?? 0)) < 0
            && scrollView?.bw_header?.state == .normal
            && gesture?.state == .changed
        {
            scrollView?.bw_header?.state = .willRefresh
        }
        
    }
    
    func contentOffsetKeyChangeFoot() {
        
        let scH = scrollView?.frame.size.height ?? 0
        let scConH = scrollView?.contentSize.height ?? 0
        let scY = scrollView?.contentOffset.y ?? 0
        let h = scConH - scH
        let refreshH = scrollView?.bw_footer?.refreshHeight ?? 0
        
        if scrollView?.bw_footer?.isQuick ?? false {
            // 急速模式
            if h>0
                && (scY-h) > 0
                && scrollView?.bw_footer?.state == .normal
            {
                scrollView?.bw_footer?.state = .refreshing
            }
        }else {
            
            if h>0
                && (scY-h) > refreshH
                && scrollView?.bw_footer?.state == .normal
                && gesture?.state == .changed
            {
                scrollView?.bw_footer?.state = .willRefresh
            }
            
        }
    }
    
    
    
    
}
