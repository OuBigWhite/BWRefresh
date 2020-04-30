//
//  File.swift
//  BWRefresh
//
//  Created by 冉彬 on 2020/4/23.
//  Copyright © 2020 BigWhite. All rights reserved.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screentHeight = UIScreen.main.bounds.size.height

// 底部安全距离
let bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0

//顶部的安全距离
let topSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0

//状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.height

//导航栏高度
let navigationHeight = CGFloat(44)

/// 颜色
func bgColorHEX(_ hexColor: Int) -> UIColor! {
    return UIColor(red: ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0,
    green: ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0,
    blue: ((CGFloat)(hexColor & 0xFF)) / 255.0,alpha: 1.0)
}

func bgColorHEX(hexColor: Int, alpha: Float) -> UIColor! {
    return UIColor(red: ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0,
    green: ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0,
    blue: ((CGFloat)(hexColor & 0xFF)) / 255.0,alpha: CGFloat(alpha))
}


/// 截屏
//func screenSnapshot() -> UIImage? {
//    let screenRect = UIScreen.main.bounds
//    UIGraphicsBeginImageContext(screenRect.size)
//    let ctx:CGContext = UIGraphicsGetCurrentContext()!
//    guard let window = UIApplication.shared.keyWindow else { return nil }
//    window.layer.render(in: ctx)
//    let image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext();
//    return image
//}
func screenSnapshot() -> UIImage? {
        guard UIScreen.main.bounds.size.height > 0 && UIScreen.main.bounds.size.width > 0 else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, UIScreen.main.scale)
        guard let window = UIApplication.shared.keyWindow else { return nil }
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)  // 高清截图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }






/// 圆角
/// - Parameters:
///   - view: view
///   - radiu: 圆半径
func cornerView(view: UIView, radiu: CGFloat) {
    view.layer.cornerRadius = radiu
    view.layer.masksToBounds = true
}

/// 圆角边框
/// - Parameters:
///   - view: view
///   - radii: 圆半径
///   - width: 边框宽
///   - color: 边框颜色
func cornerView(view: UIView, radiu: CGFloat, width: CGFloat, color: UIColor) {
    view.layer.cornerRadius = radiu
    view.layer.masksToBounds = true
    view.layer.borderWidth = width
    view.layer.borderColor = color.cgColor
}

/// 高性能圆角边框(在界面将显示时调用)
/// - Parameters:
///   - view: view
///   - radii: 半径
///   - width: 边框宽
///   - color: 边框颜色
func highCornerView(view: UIView, radiu: CGFloat, width: CGFloat, color: UIColor) {
    
    view.superview?.layoutIfNeeded()
    let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: radiu, height: radiu))
    let maskLayer = CAShapeLayer.init()
    maskLayer.frame = view.bounds
    maskLayer.path = maskPath.cgPath
    view.layer.mask = maskLayer
    
    let borderLayer = CAShapeLayer()
    borderLayer.frame = view.bounds
    borderLayer.path = maskPath.cgPath
    borderLayer.lineWidth = width;
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.strokeColor = color.cgColor
    view.layer.addSublayer(borderLayer)
}



/**
 字典转换为JSONString
 
 - parameter dictionary: 字典参数
 
 - returns: JSONString
 */
func getJsonStringFromDictionary(dictionary:NSDictionary) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String

}


/// 获取当前时间戳
func getNowTimeStamp() -> String {
    //获取当前时间
    let now = Date()
    //当前时间的时间戳
    let timeInterval:TimeInterval = now.timeIntervalSince1970
    let timeStamp = Int(timeInterval)
    return "\(timeStamp)"
}


/// 获取当前时间
/// - Parameter dateFormat: 时间格式（如：yyyy-MM-dd HH:mm:ss）
func getNowTimeString(dateFormat: String) -> String {
    //获取当前时间
    let now = Date()
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = dateFormat
    return dformatter.string(from: now)
}


