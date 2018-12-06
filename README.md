# EWMBProgressHUD
<h3>对MBProgressHUD进行封装</h3>
  
对调用方法进行封装,实现一行代码弹出HUD
  
实现七种形式:
* 不遮盖navigationBar背景半透明显示文字
* 遮盖navigationBar背景半透明显示文字
* 背景透明显示文字
* 背景透明显示Loading 
* 不遮盖navigationBar背景半透明显示Loading
* 遮盖navigationBar背景半透明显示Loading
* 背景透明显示自定义icon+文字

![效果图预览](https://github.com/WangLiquan/EWMBProgressHUD/raw/master/images/demonstration.gif)

# 使用方法示例:
1.使用CocoaPods或手动将MBProgressHUD加入项目.   
   
2.将EWMBProgressHUD.swift文件加入项目.  
   
3.调用时:
```
@objc private func onClickTopButton(){
    EWMBProgressHud.showTextHudTips(message: "蒙层", view: self.view, isMask: true, afterDelay: 1)
}
@objc private func onClickCenterButton(){
    EWMBProgressHud.showTextHudTips(message: "Toast", isTranslucent: true)
}
@objc private func onClickLoadingButton(){
    EWMBProgressHud.showLoadingHudView(message: "Loading", isTranslucent: true)
    /// loadingView必需手动隐藏!!!结束loading请调用hideHud()!!!
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        EWMBProgressHud.hideHud()
        }
}
@objc private func onClickSecondLoadingButton(){
    EWMBProgressHud.showLoadingHudView(view: self.view, message: "蒙层Loading", isMask: true)
    /// loadingView必需手动隐藏!!!结束loading请调用hideHud()!!!
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()  + 1) {
        EWMBProgressHud.hideHud()
    }
}
@objc private func onClickSuccessButton(){
    EWMBProgressHud.showSuccesshTips(message: "Success",afterDelay: 1, isTranslucent: true)
}
@objc private func onClickCoverNavigationBarLoadingButton(){
    /// 覆盖navigationBar需要从NavitionController中添加View,所以需要传入navigationController
    EWMBProgressHud.showLoadingHudView(NAVC: self.navigationController, message: "覆盖NavigationBar的LoadingView")
    /// loadingView必需手动隐藏!!!结束loading请调用hideHud()!!!
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        EWMBProgressHud.hideHud()
    }
}
@objc private func onClicKCoverNavigationBarButton(){
    EWMBProgressHud.showTextHudTips(NAVC: self.navigationController, message: "覆盖NavigationBar的蒙层", isMask: true,afterDelay: 1)
}
```

