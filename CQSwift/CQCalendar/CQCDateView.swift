//
//  CQCDateView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/10/13.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCDateView: UIControl {
     
    var date: String? {
        didSet {
            self.dateLabel.text = date
        }
    }
    
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
        
        let dateLabelW:CGFloat = viewWidth - arrowViewW
        let dateLabelX:CGFloat = 0.0
        let dateLabelY:CGFloat = 0.0
        let dateLabelH = viewHeight
        self.dateLabel.frame = CGRect(x: dateLabelX, y: dateLabelY, width: dateLabelW, height: dateLabelH)
        
        let arrowViewH:CGFloat = dateLabelH
        let arrowViewX:CGFloat = self.dateLabel.frame.maxX
        let arrowViewY:CGFloat = dateLabelY
        self.arrowView.frame = CGRect(x: arrowViewX, y: arrowViewY, width: arrowViewW, height: arrowViewH)
    }
    //MARK: setupUI
    func setupUI() {
        self.addSubview(self.dateLabel)
        self.addSubview(self.arrowView)
    }
    
    //MARK: lazy
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = UIColor.colorHex(hex: "#4A7AE0")
        label.textAlignment = .right
        return label
    }()
    lazy var arrowView: UIImageView = {
        let view = UIImageView()
        view.image =  UIImage.init(named: "arrow_top")
        view.contentMode = .center
        view.transform = CGAffineTransform(rotationAngle: .pi)
        view.tintColor = UIColor.colorHex(hex: "#4A7AE0")
        return view
    }()
    
}
