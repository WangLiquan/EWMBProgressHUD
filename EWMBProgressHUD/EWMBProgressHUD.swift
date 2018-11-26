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
        return isIphoneX() ? 88 : 64;
    }
}

private let hudShowTime = 1.5

class EWMBProgressHud {
    static var hud : MBProgressHUD?
    /// 创建Hud
    ///
    /// - Parameters:
    ///   - view: 加载到哪个View展示.
    ///   - isMask: 是否是蒙层形式,背景半透明.
    private class func createHud(view : UIView? = UIApplication.shared.keyWindow, isMask : Bool = false) -> MBProgressHUD? {
        guard let supview = view ?? UIApplication.shared.keyWindow else {return nil}
        let HUD = MBProgressHUD.showAdded(to: supview
            , animated: true)
        /// 默认不遮盖navigationBar
        HUD.frame = CGRect(x: 0, y: 0, width: EWScreenInfo.Width, height: EWScreenInfo.Height - EWScreenInfo.navigationHeight)
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
    ///   - navigationController:
    ///   - isMask:  是否蒙层覆盖
    /// - Returns: hud实例
    private class func createHud(navigationController : UINavigationController?, isMask : Bool = false) -> MBProgressHUD? {
        guard let navc = navigationController else {return nil}
        guard let supview = navc.view else {return nil}
        let HUD = MBProgressHUD.showAdded(to: supview
            , animated: true)
        /// 默认不遮盖navigationBar
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
    ///   - completeBlock: HUD消失后调用block
    private class func showHudTips (message : String?, icon : String?, view : UIView?, completeBlock : (()->(Void))?) {
        let HUD = self.createHud(view: view, isMask: false)
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
    class func showLoadingHudView (view : UIView? = UIApplication.shared.keyWindow ,message:String?, isMask : Bool = false){
        let HUD = self.createHud(view: view, isMask: isMask)
        HUD?.mode = .indeterminate
        HUD?.label.text = message
        hud = HUD
    }
    /// 展示loadingHUD,可用于网络请求
    class func showLoadingHudView (NAVC : UINavigationController? ,message:String?, isMask : Bool = false){
        let HUD = self.createHud(navigationController: NAVC,isMask :isMask)
        HUD?.mode = .indeterminate
        HUD?.label.text = message
        hud = HUD
    }
    /// 生成实例的loadingHUD,可以再对实例进行自定义修改
    class func showLoadingHudInView (view : UIView? = UIApplication.shared.keyWindow ,message:String?, isMask : Bool = false) -> MBProgressHUD?{
        let HUD = self.createHud(view: view, isMask: isMask)
        HUD?.mode = .indeterminate
        HUD?.label.text = message
        hud = HUD
        return hud
    }
    /// 展示类ToastHUD
    class func showTextHudTips(message : String?, view : UIView? = UIApplication.shared.keyWindow , isMask : Bool = false,afterDelay:Double = hudShowTime) {
        let HUD = self.createHud(view: view, isMask: isMask)
        HUD?.mode = .text
        HUD?.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        HUD?.detailsLabel.text = message
        HUD?.hide(animated: true, afterDelay: afterDelay)
    }
    /// 生成实例的类ToastHUD,可以再对实例进行自定义修改
    class func showTextHud (message : String?, view : UIView? = UIApplication.shared.keyWindow , isMask : Bool = false,afterDelay:Double = hudShowTime) -> MBProgressHUD? {
        let HUD = self.createHud(view: view, isMask: isMask)
        HUD?.mode = .text
        HUD?.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        HUD?.detailsLabel.text = message
        HUD?.hide(animated: true, afterDelay: afterDelay)
        return HUD
    }
    // 展示成功HUD,可自己修改图片,icon图片需要自己添加到项目中,建议大小为64X64
    class func showSuccesshTips (message : String?, view : UIView? = UIApplication.shared.keyWindow ,afterDelay:Double = hudShowTime) {
        self.showHudTips(message: message, icon: "Success.png", view: view, completeBlock: nil)
    }
    // 展示成功HUD,可传入HUD隐藏后调用Block
    class func showSuccesshTips (message : String?, view : UIView? = UIApplication.shared.keyWindow , completeBlock : (()->(Void))?) {
        self.showHudTips(message: message, icon: "success.png", view: view, completeBlock: completeBlock)
    }
    // 展示失败HUD,可自己修改图片,icon图片需要自己添加到项目中,建议大小为64X64
    class func showErrorMessage(message : String?, view : UIView? = UIApplication.shared.keyWindow ){
        self.showHudTips(message: message, icon: "error.png", view: view, completeBlock: nil)
    }
    // 展示失败HUD,可传入HUD隐藏后调用Block
    class func showErrorMessage (message : String?, view : UIView? = UIApplication.shared.keyWindow , completeBlock : (()->(Void))?) {
        self.showHudTips(message: message, icon: "error.png", view: view, completeBlock: nil)
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

