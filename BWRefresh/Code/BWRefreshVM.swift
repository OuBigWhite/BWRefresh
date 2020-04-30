//
//  BWRefreshViewProtocol.swift
//  BWRefresh
//
//  Created by 冉彬 on 2020/4/26.
//  Copyright © 2020 BigWhite. All rights reserved.
//

import Foundation
import UIKit

enum BWRefreshVMState {
    case normal
    case willRefresh
    case refreshing
}

protocol BWRefreshVM: class {
    var view: UIView { get set }
    var state: BWRefreshVMState {get set}
    var isShow: Bool {get set}
    var refreshHeight: CGFloat {get set}  // 滑动超过内容高度 此数值后进入 willRefresh
    var isQuick: Bool {get set} // 是否是急速模式（滑动超过内容高度立即进入refreshing）
    
    var refreshAction: (() -> Void)? {get}
    func stateChanged(state: BWRefreshVMState)
    
    
}

protocol BWRefreshHeaderProtocol: BWRefreshVM{
    //
}


protocol BWRefreshFooterProtocol: BWRefreshVM{
    //
}





var stateKey = "stateKey"
var isShowKey = "isShowKey"
extension BWRefreshVM {
    
    var isShow: Bool {
        get {
            return objc_getAssociatedObject(self, &isShowKey) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &isShowKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.view.isHidden = !newValue
            
        }
    }
    
    func endRefresh() {
        self.state = .normal
    }
    
    
    
}

extension BWRefreshHeaderProtocol {
    var state: BWRefreshVMState {
            get {
                return objc_getAssociatedObject(self, &stateKey) as? BWRefreshVMState ?? BWRefreshVMState.normal
            }
            set {
                objc_setAssociatedObject(self, &stateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                self.stateChanged(state: newValue)
                let sView = self.view.superview as! UIScrollView
                let viewH = self.view.frame.size.height
                var isscro = false
                if sView.contentInset.bottom == viewH  {
                    isscro = true
                }
                
                if self.isShow && newValue == .refreshing {
                    UIView.animate(withDuration: 0.2) {[weak self, sView] in
                        sView.contentInset = UIEdgeInsets(top: viewH, left: 0, bottom: 0, right: 0)
                        self?.refreshAction?()
                    }
                    
                }else {
                    UIView.animate(withDuration: 0.2) {[weak self, sView] in
                        sView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    }
                    
                }
            }
    }

}

extension BWRefreshFooterProtocol {
    
    var state: BWRefreshVMState {
        get {
            return objc_getAssociatedObject(self, &stateKey) as? BWRefreshVMState ?? BWRefreshVMState.normal
        }
        set {
            objc_setAssociatedObject(self, &stateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.stateChanged(state: newValue)
            let sView = self.view.superview as! UIScrollView
            let viewH = self.view.frame.size.height
            var isscro = false
            if sView.contentInset.bottom == viewH  {
                isscro = true
            }
            
            if self.isShow && newValue == .refreshing {
                UIView.animate(withDuration: 0.2) {[weak self, sView] in
                    sView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: viewH, right: 0)
                    self?.refreshAction?()
                }
                
            }else {
                sView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                if isscro {
                    // 处理界面闪动
                    sView.contentOffset = CGPoint(x: sView.contentOffset.x, y: sView.contentOffset.y + viewH)
                }
            }
        }
    }
}



