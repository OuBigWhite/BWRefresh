//
//  UIscrollerView+BWRefresh.swift
//  BWRefresh
//
//  Created by 冉彬 on 2020/4/23.
//  Copyright © 2020 BigWhite. All rights reserved.
//
import UIKit

private var headerkey = "header"
private var footerkey = "footer"
private var managerkey = "managerkey"

extension UIScrollView {
    
    /// 管理器
    var refreshManager: BWRefreshManager? {
        get{
            return objc_getAssociatedObject(self, &managerkey) as? BWRefreshManager
        }
        set(newValue) {
            objc_setAssociatedObject(self, &managerkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            refreshManager?.bindingScrollerView(scrollView: self)
        }
    }
    
    /// header
    var bw_header: BWRefreshHeaderProtocol? {
        get{
            return objc_getAssociatedObject(self, &headerkey) as? BWRefreshHeaderProtocol
        }
        set(newValue) {
            if newValue == nil {
                bw_header?.view.removeFromSuperview()
            }else{
                bw_header?.view.removeFromSuperview()
                self.insertSubview(newValue!.view, at: 0)
                var frame = newValue?.view.frame
                frame?.origin.x = 0
                frame?.origin.y = -(newValue?.view.frame.size.height ?? 0)
                newValue?.view.frame = frame!
            }
            objc_setAssociatedObject(self, &headerkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            // 设置管理器
            if self.bw_footer == nil && self.bw_header == nil {
                self.refreshManager = nil
            } else if self.refreshManager == nil {
                self.refreshManager = BWRefreshManager()
            }
        }
    }
    
    /// footer
    var bw_footer: BWRefreshFooterProtocol? {
        get{
            return objc_getAssociatedObject(self, &footerkey) as? BWRefreshFooterProtocol
        }
        set(newValue) {
            if newValue == nil {
                bw_footer?.view.removeFromSuperview()
            }else{
                bw_footer?.view.removeFromSuperview()
                self.addSubview(newValue!.view)
            }
            objc_setAssociatedObject(self, &footerkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            // 设置管理器
            if self.bw_footer == nil && self.bw_header == nil  {
                self.refreshManager = nil
            } else if self.refreshManager == nil {
                self.refreshManager = BWRefreshManager()
            }
        }
    }
    
    
    
    
}
