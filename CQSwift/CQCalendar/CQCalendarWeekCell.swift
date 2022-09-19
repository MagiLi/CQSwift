//
//  CQCalendarWeekCell.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/19.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCalendarWeekCell: UICollectionViewCell {
    
    var week: String? {
        didSet {
            self.weekLab.text = week
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
        self.weekLab.frame = self.bounds
//        let  weekLabW:CGFloat = 30.0
//        let  weekLabH:CGFloat = weekLabW
//        let  weekLabX:CGFloat = (self.frame.width - weekLabW) * 0.5
//        let  weekLabY:CGFloat =  (self.frame.height - weekLabH) * 0.5
//        self.weekLab.frame = CGRect(x: weekLabX, y: weekLabY, width: weekLabW, height: weekLabH)
    }
    //MARK: setupUI
    func setupUI() {
        self.contentView.addSubview(self.weekLab)
    }
    //MARK: lazy
    private lazy var weekLab: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        return label
    }()
    
}
