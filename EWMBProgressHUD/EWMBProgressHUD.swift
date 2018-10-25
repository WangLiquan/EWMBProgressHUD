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
    //FIXME:自定义view显示
    private class func createHud(view : UIView? = UIApplication.shared.keyWindow, isMask : Bool = false) -> MBProgressHUD? {
        guard let supview = view ?? UIApplication.shared.keyWindow else {return nil}
        let HUD = MBProgressHUD.showAdded(to: supview
            , animated: true)
        HUD.frame = CGRect(x: 0, y: EWScreenInfo.navigationHeight, width: EWScreenInfo.Width, height: EWScreenInfo.Height - EWScreenInfo.navigationHeight)
        HUD.animationType = .zoom
        if isMask {
            HUD.backgroundView.color = UIColor(white: 0.0, alpha: 0.4)
        } else {
            HUD.backgroundView.color = UIColor.clear
            HUD.bezelView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
            HUD.contentColor = UIColor.white
        }
        HUD.removeFromSuperViewOnHide = true
        HUD.show(animated: true)
        return HUD
    }

    //FIXME:自定义view显示
    private class func showHudTips (message : String?, icon : String?, view : UIView?, completeBlock : (()->(Void))?) {
        let HUD = self.createHud(view: view, isMask: false)
        HUD?.label.text = message
        HUD?.label.numberOfLines = 0
        if let icon = icon {
            HUD?.customView = UIImageView.init(image: UIImage.init(named: "\(icon)"))
        }
        HUD?.mode = .customView

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
    //TODO:加载提示框
    class func showLoadingHudView (view : UIView? = UIApplication.shared.keyWindow ,message:String?, isMask : Bool = false){
        let HUD = self.createHud(view: view, isMask: isMask)
        HUD?.mode = .indeterminate
        HUD?.label.text = message
        hud = HUD
    }
    class func showLoadingHudInView (view : UIView? = UIApplication.shared.keyWindow ,message:String?, isMask : Bool = false) -> MBProgressHUD?{
        let HUD = self.createHud(view: view, isMask: isMask)
        HUD?.mode = .indeterminate
        HUD?.label.text = message
        hud = HUD
        return hud
    }

    //TODO:提示文字
    class func showTextHudTips(message : String?, view : UIView? = UIApplication.shared.keyWindow , isMask : Bool = false,afterDelay:Double = hudShowTime) {
        let HUD = self.createHud(view: view, isMask: isMask)
        HUD?.mode = .text
        HUD?.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        HUD?.detailsLabel.text = message
        HUD?.hide(animated: true, afterDelay: afterDelay)
    }
    class func showTextHud (message : String?, view : UIView? = UIApplication.shared.keyWindow , isMask : Bool = false,afterDelay:Double = hudShowTime) -> MBProgressHUD? {
        let HUD = self.createHud(view: view, isMask: isMask)
        HUD?.mode = .text
        HUD?.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        HUD?.detailsLabel.text = message
        HUD?.hide(animated: true, afterDelay: afterDelay)
        return HUD
    }
    //TODO:成功后提示
    class func showSuccesshTips (message : String?, view : UIView? = UIApplication.shared.keyWindow ,afterDelay:Double = hudShowTime) {
        self.showHudTips(message: message, icon: "Success.png", view: view, completeBlock: nil)
    }
    class func showSuccesshTips (message : String?, view : UIView? = UIApplication.shared.keyWindow , completeBlock : (()->(Void))?) {
        self.showHudTips(message: message, icon: "success.png", view: view, completeBlock: completeBlock)
    }
    //TODO:失败后提示
    class func showErrorMessage(message : String?, view : UIView? = UIApplication.shared.keyWindow ){
        self.showHudTips(message: message, icon: "error.png", view: view, completeBlock: nil)
    }

    class func showErrorMessage (message : String?, view : UIView? = UIApplication.shared.keyWindow , completeBlock : (()->(Void))?) {
        self.showHudTips(message: message, icon: "error.png", view: view, completeBlock: nil)
    }
    //TODO:隐藏提示框
    class func hideHud () {
        guard let HUD = hud else {
            return
        }
        HUD.hide(animated: true)
        hud = nil
    }
}

