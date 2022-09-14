//
//  CQTextScrollVC.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/8/25.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQTextScrollVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(self.textScrollView)
        
        self.textPage()
        
        self.view.addSubview(self.typeView)
    }
    
    // 计算一行放多少文字
    func textPage() {
        /*根据lab的size计算每行需要展示的文字索引*/
        let msg = "口角是非款酸辣粉挥洒舒服了科技发达是匡扶汉室卡夫卡数据恢复数据开发哈佛回家撒反馈"
        let att:[NSAttributedString.Key : Any] = [
            .font: UIFont(name: "PingFangSC-Semibold", size: 13.0)!,
            .foregroundColor:UIColor.red
        ]
        let attMsg = NSAttributedString(string: msg, attributes: att)
        
        let labW:CGFloat = 200.0
        let labH:CGFloat = 20.0
        let size = CGSize(width: labW, height: labH)
        let rangeArray = attMsg.pageRangeArrayWithConstrained(to: size)
        let labX:CGFloat = 20.0
        rangeArray.enumerated().forEach { (i, element) in
            guard let range = element as? NSRange else { return }
            let attText = attMsg.attributedSubstring(from: range)
            
            let labY:CGFloat = 150.0 + CGFloat(i) * (labH + 10.0)
            let lab = UILabel(frame: CGRect(x: labX, y: labY, width: labW, height: labH))
            lab.attributedText = attText
            lab.backgroundColor = .gray
            self.view.addSubview(lab)
            print(range)
        }
        print(rangeArray)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let x:CGFloat = 20.0
        let width = self.view.frame.width - x * 2.0
        self.textScrollView.frame = CGRect(x: x, y: 100.0, width:width, height: 30.0)
        
        self.typeView.frame = CGRect(x: 0.0, y: 250.0, width: self.view.frame.width, height: 50.0)
    }
    
    lazy var textScrollView: CQTextScrollView = {
        let view = CQTextScrollView()
        return view
    }()
    
//    lazy var lab: UILabel = {
//        let lab = UILabel()
//        return lab
//    }()
    
    lazy var typeView: CQTypeView = {
        let view = CQTypeView(titleArray: self.titleArray)
        return view
    }()
    var titleArray:[[String:Any]] = [
        ["title":"全部"],
        ["title":"功能"],
        ["title":"产品"],
        ["title":"资讯"]
    ]
}
