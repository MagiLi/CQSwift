//
//  CQDesktopMenuController.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/3/23.
//  Copyright © 2023 李超群. All rights reserved.
//

import UIKit
import Swifter

class CQDesktopMenuController: UIViewController {

    @objc func addButtonClicked(_ sender:UIButton) {
        guard let deeplink = URL(string: "other://profile") else {
            return
        }
        guard let shortcutUrl = URL(string: "http://localhost:8244/s") else {
            return
        }
        
        guard let iconData = UIImage(named: "feature_icon")?.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let html = htmlFor(title: "功能快捷方式", urlToRedirect: deeplink.absoluteString, icon: iconData.base64EncodedString())
        
        guard let base64 = html.data(using: .utf8)?.base64EncodedString() else {
            return
        }
        server["/s"] = { request in
            return .movedPermanently("data:text/html;base64,\(base64)")
        }
        try? server.start(8244)
        
        UIApplication.shared.open(shortcutUrl)
    }
    
    func htmlFor(title: String, urlToRedirect: String, icon: String) -> String {
        let shortcutsPath = Bundle.main.path(forResource: "shortcuts", ofType: "html")
        
        var shortcutsContent = try! String(contentsOfFile: shortcutsPath!) as String
        shortcutsContent = shortcutsContent.replacingOccurrences(of: "\\(title)", with: title)
        shortcutsContent = shortcutsContent.replacingOccurrences(of: "\\(urlToRedirect.absoluteString)", with: urlToRedirect)
        shortcutsContent = shortcutsContent.replacingOccurrences(of: "\\(feature_icon)", with: icon)

        print(shortcutsContent)
        return shortcutsContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.addBtn)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let addBtnX:CGFloat = 30.0
        let addBtnY:CGFloat = 100.0
        let addBtnW:CGFloat = 200.0
        let addBtnH:CGFloat = 60.0
        self.addBtn.frame = CGRect(x: addBtnX, y: addBtnY, width: addBtnW, height: addBtnH)
    }
    
   
    lazy var server: HttpServer = { // 服务器
        let server = HttpServer()
        return server
    }()
    
    lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(addButtonClicked(_ :)), for: .touchUpInside)
        //btn.setImage(UIImage(named: "calendar_custom_add"), for: .normal)
        btn.setTitle("将当前页面添加到桌面", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        //btn.adjustsImageWhenHighlighted = false
        return btn
    }()

}
