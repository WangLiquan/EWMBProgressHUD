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
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 150) / 2 , y: 150, width: 150, height: 50))
        button.setTitle("蒙层式HUD", for: .normal)
        button.addTarget(self, action: #selector(onClickTopButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        return button
    }()
    private let middleButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 150) / 2 , y:250, width: 150, height: 50))
        button.setTitle("弹出式HUD", for: .normal)
        button.addTarget(self, action: #selector(onClickCenterButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        return button
    }()
    private let loadButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 150) / 2 , y:350, width: 150, height: 50))
        button.setTitle("LoadingHUD", for: .normal)
        button.addTarget(self, action: #selector(onClickLoadingButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        return button
    }()
    private let secondLoadingButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 150) / 2 , y:450, width: 150, height: 50))
        button.setTitle("蒙层LoadingHUD", for: .normal)
        button.addTarget(self, action: #selector(onClickSecondLoadingButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        return button
    }()
    private let successButton: UIButton = {
        let button = UIButton(frame: CGRect(x:( UIScreen.main.bounds.size.width - 150) / 2 , y:550, width: 150, height: 50))
        button.setTitle("成功式HUD", for: .normal)
        button.addTarget(self, action: #selector(onClickSuccessButton), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(topButton)
        self.view.addSubview(middleButton)
        self.view.addSubview(loadButton)
        self.view.addSubview(secondLoadingButton)
        self.view.addSubview(successButton)
    }

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
}

