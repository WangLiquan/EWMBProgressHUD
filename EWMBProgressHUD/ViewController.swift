//
//  ViewController.swift
//  EWMBProgressHUD
//
//  Created by Ethan.Wang on 2018/10/25.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let topButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 250) / 2 , y: 100, width: 250, height: 50))
        button.setTitle("蒙层式HUD", for: .normal)
        button.addTarget(self, action: #selector(onClickTopButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 5
        return button
    }()
    private let coverNavigaionButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 250) / 2 , y:190, width: 250, height: 50))
        button.setTitle("覆盖navigationBar蒙层HUD", for: .normal)
        button.addTarget(self, action: #selector(onClicKCoverNavigationBarButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 5
        return button
    }()
    private let middleButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 250) / 2 , y:280, width: 250, height: 50))
        button.setTitle("弹出式HUD", for: .normal)
        button.addTarget(self, action: #selector(onClickCenterButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 5
        return button
    }()
    private let loadButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 250) / 2 , y:370, width: 250, height: 50))
        button.setTitle("LoadingHUD", for: .normal)
        button.addTarget(self, action: #selector(onClickLoadingButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 5
        return button
    }()
    private let secondLoadingButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 250) / 2 , y:460, width: 250, height: 50))
        button.setTitle("蒙层LoadingHUD", for: .normal)
        button.addTarget(self, action: #selector(onClickSecondLoadingButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 5
        return button
    }()
    private let coverNavigaionLoadingButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 250) / 2 , y:550, width: 250, height: 50))
        button.setTitle("覆盖navigationBarLoadingHUD", for: .normal)
        button.addTarget(self, action: #selector(onClickCoverNavigationBarLoadingButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 5
        return button
    }()
    private let successButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 250) / 2 , y:640, width: 250, height: 50))
        button.setTitle("成功式HUD", for: .normal)
        button.addTarget(self, action: #selector(onClickSuccessButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 5
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "啦啦啦"
        self.view.backgroundColor = UIColor.white
        /// 控制navigationBar是否参与frame计算.默认为false
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.addSubview(topButton)
        self.view.addSubview(middleButton)
        self.view.addSubview(loadButton)
        self.view.addSubview(secondLoadingButton)
        self.view.addSubview(successButton)
        self.view.addSubview(coverNavigaionLoadingButton)
        self.view.addSubview(coverNavigaionButton)
    }

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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            EWMBProgressHud.hideHud()
        }
    }
    @objc private func onClickSuccessButton(){
        EWMBProgressHud.showSuccesshTips(message: "Success",afterDelay: 1, isTranslucent: true)
    }
    @objc private func onClickCoverNavigationBarLoadingButton(){
        /// 覆盖navigationBar需要从NavitionController中添加View,所以需要传入navigationController
        EWMBProgressHud.showLoadingHudView(NAVC: self.navigationController, message: "覆盖NavigationBar的LoadingView",isMask: true)
        /// loadingView必需手动隐藏!!!结束loading请调用hideHud()!!!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            EWMBProgressHud.hideHud()
        }
    }
    @objc private func onClicKCoverNavigationBarButton(){
        EWMBProgressHud.showTextHudTips(NAVC: self.navigationController, message: "覆盖NavigationBar的蒙层", isMask: true,afterDelay: 1)
    }
}

