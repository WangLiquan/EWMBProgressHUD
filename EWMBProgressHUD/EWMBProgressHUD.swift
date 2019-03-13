//
//  EWMBProgressHUD.swift
//  EWMBProgressHUD
//
//  Created by Ethan.Wang on 2018/10/25.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit
import MBProgressHUD

struct EWScreenInfo {
    static let Frame = UIScreen.main.bounds
    static let Height = Frame.height
    static let Width = Frame.width
    static let navigationHeight:CGFloat = navBarHeight()
    static func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    static private func navBarHeight() -> CGFloat {
        return isIphoneX() ? 88 : 64
    }
}
/// 默认hub显示时间
private let hudShowTime = 1.5

class EWMBProgressHud {
    static var hud : MBProgressHUD?
    /// 创建Hud
    ///
    /// - Parameters:
    ///   - view: 加载到哪个View展示.
    ///   - isMask: 是否是蒙层形式,背景半透明.
    ///   - isTranslucent: 项目中navigationBar是否计算frame,默认是false,如果项目中有调用self.navigationController?.navigationBar.isTranslucent = true则传入true
    private class func createHud(view : UIView? = UIApplication.shared.keyWindow, isMask : Bool = false ,isTranslucent: Bool = false) -> MBProgressHUD? {
        guard let supview = view ?? UIApplication.shared.keyWindow else {return nil}
        let HUD = MBProgressHUD.showAdded(to: supview
            , animated: true)
        let top = isTranslucent ? 0 : EWScreenInfo.navigationHeight
        HUD.frame = CGRect(x: 0, y: top, width: EWScreenInfo.Width, height: EWScreenInfo.Height - top)
        HUD.animationType = .zoom
        if isMask {
            /// 蒙层type,背景半透明.
            HUD.backgroundView.color = UIColor(white: 0.0, alpha: 0.4)
        } else {
            /// 非蒙层type,没有背景.
            HUD.backgroundView.color = UIColor.clear
            HUD.bezelView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
            HUD.contentColor = UIColor.white
        }
        HUD.removeFromSuperViewOnHide = true
        HUD.show(animated: true)
        return HUD
    }
    /// 创建hud,覆盖navigationbar
    ///
    /// - Parameters:
    ///   - navigationController: 如果想要覆盖navigationBar则需要传入navigationController
    ///   - isMask:  是否蒙层覆盖
    /// - Returns: hud实例
    private class func createHud(navigationController : UINavigationController?, isMask : Bool = false) -> MBProgressHUD? {
        guard let navc = navigationController else {return nil}
        guard let supview = navc.view else {return nil}
        let HUD = MBProgressHUD.showAdded(to: supview
            , animated: true)
        HUD.frame = CGRect(x: 0, y: 0, width: EWScreenInfo.Width, height: EWScreenInfo.Height)
        HUD.animationType = .zoom
        if isMask {
            /// 蒙层type,背景半透明.
            HUD.backgroundView.color = UIColor(white: 0.0, alpha: 0.4)
        } else {
            /// 非蒙层type,没有背景.
            HUD.backgroundView.color = UIColor.clear
            HUD.bezelView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
            HUD.contentColor = UIColor.white
        }
        HUD.removeFromSuperViewOnHide = true
        HUD.show(animated: true)
        return HUD
    }
    /// 直接展示Hud
    ///
    /// - Parameters:
    ///   - message: 显示信息
    ///   - icon: 显示图片
    ///   - view: 加载到哪个View上展示
    ///   - coverNavigationController: 要覆盖NavigationBar,需要传入NavigationController
    ///   - isTranslucent: 自己项目中navigationBar是否参与frame设置,默认为False,如果项目中主动将其设置为true,可以传入True.不传的话中弹出view会有半个navigationBar.height的向下偏移.
    ///   - completeBlock: UD消失后调用block
    private class func showHudTips (message : String?, icon : String?, view : UIView?, coverNavigationController: UINavigationController? = nil, isTranslucent: Bool = false,completeBlock : (() -> Void)?) {
        var HUD: MBProgressHUD?
        if coverNavigationController != nil {
            HUD = self.createHud(navigationController: coverNavigationController!)
        } else {
            HUD = self.createHud(view: view, isMask: false, isTranslucent: isTranslucent)
        }
        HUD?.label.text = message
        HUD?.label.numberOfLines = 0
        /// 如果有Icon展示.
        if let icon = icon {
            HUD?.customView = UIImageView.init(image: UIImage.init(named: "\(icon)"))
        }
        HUD?.mode = .customView
        /// 在hud消失时调用completeBlock.
        DispatchQueue.main.asyncAfter(deadline: .now() + hudShowTime) {
            HUD?.hide(animated: true)
            guard let completeBlock = completeBlock else {
                return
            }
            completeBlock()
        }
    }
}

extension EWMBProgressHud {
    /// 展示loadingHUD,可用于网络请求
    ///
    /// - Parameters:
    ///   - view: 父级View,默认是当前展示View
    ///   - message: 展示文字
    ///   - isMask: 是否是蒙层形式,true是半透明背景的蒙层模式,false是只有Hub不带背景
    ///   - isTranslucent: 自己项目中navigationBar是否参与frame设置,默认为False,如果项目中主动将其设置为true,可以传入True.不传的话中弹出view会有半个navigationBar.height的向下偏移.
    class func showLoadingHudView (view : UIView? = UIApplication.shared.keyWindow ,message:String?, isMask : Bool = false,isTranslucent: Bool = false) {
        let HUD = self.createHud(view: view,isMask: isMask, isTranslucent: isTranslucent)
        HUD?.mode = .indeterminate
        HUD?.label.text = message
        hud = HUD
    }
    /// 展示loadingHUD,可用于网络请求
    ///
    /// - Parameters:
    ///   - NAVC: 要覆盖NavigationBar,需要传入NavigationController
    ///   - message: 展示文字
    ///   - isMask: 是否是蒙层形式,true是半透明背景的蒙层模式,false是只有Hub不带背景
    class func showLoadingHudView (NAVC : UINavigationController? ,message:String?) {
        let HUD = self.createHud(navigationController: NAVC, isMask: true)
        HUD?.mode = .indeterminate
        HUD?.label.text = message
        hud = HUD
    }
    /// 生成实例的loadingHUD,可以再对实例进行自定义修改
    ///
    /// - Parameters:
    ///   - view: 父级View,默认是当前展示View
    ///   - message: 展示文字
    ///   - isMask: 是否是蒙层形式,true是半透明背景的蒙层模式,false是只有Hub不带背景
    ///   - isTranslucent: 自己项目中navigationBar是否参与frame设置,默认为False,如果项目中主动将其设置为true,可以传入True.不传的话中弹出view会有半个navigationBar.height的向下偏移.
    /// - Returns: hud示例,可以自己为实例进行修改
    class func showLoadingHudInView (view : UIView? = UIApplication.shared.keyWindow ,message:String?, isMask : Bool = false,isTranslucent: Bool = false) -> MBProgressHUD? {
        let HUD = self.createHud(view: view, isMask: isMask, isTranslucent: isTranslucent)
        HUD?.mode = .indeterminate
        HUD?.label.text = message
        hud = HUD
        return hud
    }
    /// 展示类ToastHUD
    ///
    /// - Parameters:
    ///   - message: 展示文字
    ///   - view: 父级View,默认是当前展示View
    ///   - isMask: 是否是蒙层形式,true是半透明背景的蒙层模式,false是只有Hub不带背景
    ///   - afterDelay: view消失时间
    ///   - isTranslucent: 自己项目中navigationBar是否参与frame设置,默认为False,如果项目中主动将其设置为true,可以传入True.不传的话中弹出view会有半个navigationBar.height的向下偏移.
    class func showTextHudTips(message : String?, view : UIView? = UIApplication.shared.keyWindow , isMask : Bool = false,afterDelay:Double = hudShowTime,isTranslucent: Bool = false) {
        let HUD = self.createHud(view: view, isMask: isMask, isTranslucent: isTranslucent)
        HUD?.mode = .text
        HUD?.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        HUD?.detailsLabel.text = message
        HUD?.hide(animated: true, afterDelay: afterDelay)
    }
    /// 覆盖NavigationBar的l类ToastHUD
    ///
    /// - Parameters:
    ///   - NAVC: 要覆盖NavigationBar,需要传入NavigationController
    ///   - message: 展示文字
    ///   - isMask: 是否是蒙层形式,true是半透明背景的蒙层模式,false是只有Hub不带背景
    ///   - afterDelay: view消失时间
    class func showTextHudTips(NAVC : UINavigationController? ,message:String?, isMask : Bool = false,afterDelay: Double = hudShowTime) {
        let HUD = self.createHud(navigationController: NAVC,isMask :isMask)
        HUD?.mode = .text
        HUD?.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        HUD?.detailsLabel.text = message
        HUD?.hide(animated: true, afterDelay: afterDelay)
    }
    /// 生成实例的类ToastHUD,可以再对实例进行自定义修改
    ///
    /// - Parameters:
    ///   - message: 展示文字
    ///   - view: 父级View,默认是当前展示View
    ///   - isMask: 是否是蒙层形式,true是半透明背景的蒙层模式,false是只有Hub不带背景
    ///   - afterDelay: view消失时间
    ///   - isTranslucent: 自己项目中navigationBar是否参与frame设置,默认为False,如果项目中主动将其设置为true,可以传入True.不传的话中弹出view会有半个navigationBar.height的向下偏移.
    /// - Returns: hud示例,可以自己为实例进行修改
    class func showTextHud (message : String?, view : UIView? = UIApplication.shared.keyWindow , isMask : Bool = false,afterDelay:Double = hudShowTime,isTranslucent: Bool = false) -> MBProgressHUD? {
        let HUD = self.createHud(view: view, isMask: isMask, isTranslucent: isTranslucent)
        HUD?.mode = .text
        HUD?.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        HUD?.detailsLabel.text = message
        HUD?.hide(animated: true, afterDelay: afterDelay)
        return HUD
    }
    // 展示成功HUD,可自己修改图片,icon图片需要自己添加到项目中,建议大小为64X64
    ///
    /// - Parameters:
    ///   - message: 展示文字
    ///   - view: 父级View,默认是当前展示View
    ///   - afterDelay: view消失时间
    ///   - isTranslucent: 自己项目中navigationBar是否参与frame设置,默认为False,如果项目中主动将其设置为true,可以传入True.不传的话中弹出view会有半个navigationBar.height的向下偏移.
    class func showSuccesshTips (message : String?, view : UIView? = UIApplication.shared.keyWindow ,afterDelay:Double = hudShowTime,isTranslucent: Bool = false) {
        self.showHudTips(message: message, icon: "Success.png", view: view, isTranslucent: isTranslucent, completeBlock: nil)
    }
    // 展示成功HUD,可传入HUD隐藏后调用Block
    ///
    /// - Parameters:
    ///   - message: 展示文字
    ///   - view: 父级View,默认是当前展示View
    ///   - isTranslucent: 自己项目中navigationBar是否参与frame设置,默认为False,如果项目中主动将其设置为true,可以传入True.不传的话中弹出view会有半个navigationBar.height的向下偏移.
    ///   - completeBlock: 成功回调,在view隐藏后会执行回调
    class func showSuccesshTips (message : String?, view : UIView? = UIApplication.shared.keyWindow ,isTranslucent: Bool = false, completeBlock : (() -> Void)?) {
        self.showHudTips(message: message, icon: "success.png", view: view, isTranslucent: isTranslucent, completeBlock: completeBlock)
    }
    // 展示失败HUD,可自己修改图片,icon图片需要自己添加到项目中,建议大小为64X64
    ///
    /// - Parameters:
    ///   - message: 展示文字
    ///   - view: 父级View,默认是当前展示View
    ///   - isTranslucent: 自己项目中navigationBar是否参与frame设置,默认为False,如果项目中主动将其设置为true,可以传入True.不传的话中弹出view会有半个navigationBar.height的向下偏移.
    class func showErrorMessage(message : String?, view : UIView? = UIApplication.shared.keyWindow,isTranslucent: Bool = false) {
        self.showHudTips(message: message, icon: "error.png", view: view, isTranslucent: isTranslucent, completeBlock: nil)
    }
    // 展示失败HUD,可传入HUD隐藏后调用Block
    ///
    /// - Parameters:
    ///   - message: 展示文字
    ///   - view: 父级View,默认是当前展示View
    ///   - isTranslucent: 自己项目中navigationBar是否参与frame设置,默认为False,如果项目中主动将其设置为true,可以传入True.不传的话中弹出view会有半个navigationBar.height的向下偏移.
    ///   - completeBlock: 成功回调,在view隐藏后会执行回调
    class func showErrorMessage (message : String?, view : UIView? = UIApplication.shared.keyWindow,isTranslucent: Bool = false, completeBlock : (() -> Void)?) {
        self.showHudTips(message: message, icon: "error.png", view: view, isTranslucent: isTranslucent, completeBlock: nil)
    }
    /// 隐藏HUD
    class func hideHud () {
        guard let HUD = hud else {
            return
        }
        HUD.hide(animated: true)
        hud = nil
    }
}
