# EWMBProgressHUD
<h3>对MBProgressHUD进行封装</h3>

<p>对调用方法进行封装,实现一行代码弹出HUD</p>

<p>实现五种形式:1.背景半透明显示文字,2.背景透明显示文字,3.背景半透明显示Loading,4.背景透明显示Loading,5.背景透明显示自定义icon+文字</p>

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
EWMBProgressHud.showTextHudTips(message: "Toast")
}
@objc private func onClickLoadingButton(){
EWMBProgressHud.showLoadingHudView(message: "Loading")
/// loadingView必需手动隐藏!!!结束loading请调用hideHud()!!!
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
EWMBProgressHud.hideHud()
}
}
@objc private func onClickSecondLoadingButton(){
EWMBProgressHud.showLoadingHudView(view: self.view, message: "蒙层Loading", isMask: true)
/// loadingView必需手动隐藏!!!结束loading请调用hideHud()!!!
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
EWMBProgressHud.hideHud()
}
}
@objc private func onClickSuccessButton(){
EWMBProgressHud.showSuccesshTips(message: "Success")
}
```

