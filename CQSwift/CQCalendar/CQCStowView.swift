//
//  CQCStowView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/30.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCStowView: UIControl {

    
    func arrowRoate180(_ stow:Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            if stow {
                self.arrowView.transform = CGAffineTransform(rotationAngle: .pi)
                self.titleLab.text = "展开"
            } else {
                self.arrowView.transform = CGAffineTransform.identity
                self.titleLab.text = "收起"
            }
        }, completion: { cuccess in
            
        })
    }
    
//    func setTitle(_ stow:Bool) {
//    }

    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewWidth = self.frame.width
        let viewHeight = self.frame.height
        let arrowViewW:CGFloat = 17.0
        
        let titleLabW:CGFloat = viewWidth - arrowViewW
        let titleLabX:CGFloat = 0.0
        let titleLabY:CGFloat = 0.0
        let titleLabH = viewHeight
        self.titleLab.frame = CGRect(x: titleLabX, y: titleLabY, width: titleLabW, height: titleLabH)
        
        let arrowViewH:CGFloat = titleLabH
        let arrowViewX:CGFloat = self.titleLab.frame.maxX
        let arrowViewY:CGFloat = titleLabY
        self.arrowView.frame = CGRect(x: arrowViewX, y: arrowViewY, width: arrowViewW, height: arrowViewH)
    }
    //MARK: setupUI
    func setupUI() {
        self.addSubview(self.titleLab)
        self.addSubview(self.arrowView)
    }
    //MARK: lazy
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.text = "收起"
        lab.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        lab.font = UIFont.systemFont(ofSize: 13.0)
        return lab
    }()
    lazy var arrowView: UIImageView = {
        let view = UIImageView()
        view.image =  UIImage.init(named: "arrow_top")
        view.contentMode = .center
        view.tintColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        return view
    }()
}
