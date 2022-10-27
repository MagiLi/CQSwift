//
//  CQMainNavController.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/20.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit
import SwiftTheme

class CQMainNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationBar.barStyle = .default
        // 强制开启侧滑返回操作
        interactivePopGestureRecognizer?.delegate = self
//        self.title = "MAIN"
//        self.navigationBar.backgroundColor = UIColor(red: 66.0, green: 176.0, blue: 216.0, alpha: 1.0)

        //self.navigationBar.tintColor = .yellow

//        self.navigationBar.isTranslucent = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }

    func setNavigationBar(_ bgColor:UIColor?) {
        if #available(iOS 13.0, *){
            //var appearance = self.navigationBar.standardAppearance
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes  = [.font:UIFont.systemFont(ofSize: 18.0), .foregroundColor:UIColor.black]
            //appearance.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
            if let bgColor = bgColor {
                appearance.backgroundColor = bgColor
                appearance.shadowColor = nil
            } else {
                //appearance.backgroundColor = navBarTintColor
                appearance.backgroundColor = nil
                appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
                appearance.shadowColor = UIColor.colorHex(hex: "#0000004D")
                
            }
            
            //appearance.shadowColor = .clear
            appearance.backgroundImageContentMode = .scaleToFill
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }else{
            self.navigationBar.titleTextAttributes = [.font:UIFont.systemFont(ofSize: 18.0), .foregroundColor:UIColor.black]
            if let bgColor = bgColor {
                let img = UIImage.createImage(color: bgColor)
                self.navigationBar.setBackgroundImage(img, for: .default)
            } else {
                self.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationBar.backgroundColor = navBarTintColor
            }
            // 设置导航栏阴影图片
            //self.navigationBar.shadowImage = UIImage()
        }
    }
    
    /* info.plist:
        View controller-based status bar appearance
        状态栏外观是否基于当前视图控制器的首选样式。true:是 false:否
        设置为false时，preferredStatusBarStyle、childForStatusBarStyle方法不执行
    */
    // 实现 childForStatusBarStyle 方法后 preferredStatusBarStyle方法无效
    //（会调用子控制器的preferredStatusBarStyle方法）
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
//        if let style = self.topViewController?.preferredStatusBarStyle {
//            // 如果子控制器不重写 preferredStatusBarStyle 方法，默认返回default
//            return style
//        } else {
//            return .default
//        }
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
