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
        
        // 强制开启侧滑返回操作
        interactivePopGestureRecognizer?.delegate = self
//        self.title = "MAIN"
//        self.navigationBar.items.
//        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 10.0)]
//        self.navigationBar.backgroundColor = UIColor(red: 66.0, green: 176.0, blue: 216.0, alpha: 1.0)
//        let backView : UIView = self.navigationBar.value(forKeyPath: "backgroundView") as! UIView
//        backView.backgroundColor = UIColor.orange;
        if #available(iOS 13.0, *){
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes  = [.font:UIFont.systemFont(ofSize: 18.0), .foregroundColor:UIColor.white]
            //appearance.backgroundColor = navBarTintColor
            appearance.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
            //appearance.shadowColor = .clear
            appearance.backgroundImageContentMode = .scaleToFill
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }else{
            // 1、设置导航栏标题属性：设置标题颜色
            // 2、设置导航栏前景色：设置item指示色
            navigationController?.navigationBar.titleTextAttributes = [.font:UIFont.systemFont(ofSize: 18.0), .foregroundColor:UIColor.white]
            // 4、设置导航栏背景图片
            //self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            // 5、设置导航栏阴影图片
            //self.navigationBar.shadowImage = UIImage()
        }
        self.navigationBar.tintColor = .white

//        self.navigationBar.isTranslucent = true
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
