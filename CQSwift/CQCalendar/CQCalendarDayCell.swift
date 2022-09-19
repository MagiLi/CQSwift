//
//  CQCalendarDayCell.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/19.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCalendarDayCell: UICollectionViewCell {
    
    
    //static let reuseIdentifier = String(describing: CQCalendarDayCell.self)
    
    var day:CQCDay? {
        didSet {
            guard let day = day else { return }
            
            numberLabel.text = day.number
            
            if day.isSelected {
                numberLabel.textColor = .white
                
                selectionBackgroundView.isHidden = false
            } else {
                if day.isWithinDisplayedMonth {
                    numberLabel.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
                } else {
                    numberLabel.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                }
                
                selectionBackgroundView.isHidden = true
            }
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
        let selectionBackgroundViewW = traitCollection.horizontalSizeClass == .compact ?
        min(min(frame.width, frame.height) - 10, 60) : 30.0
        //let  selectionBackgroundViewW:CGFloat = 30.0
        let selectionBackgroundViewH:CGFloat = selectionBackgroundViewW
        let selectionBackgroundViewX:CGFloat = (self.frame.width - selectionBackgroundViewW) * 0.5
        let selectionBackgroundViewY:CGFloat =  (self.frame.height - selectionBackgroundViewH) * 0.5
        self.selectionBackgroundView.frame = CGRect(x: selectionBackgroundViewX, y: selectionBackgroundViewY, width: selectionBackgroundViewW, height: selectionBackgroundViewH)
        self.selectionBackgroundView.layer.cornerRadius = selectionBackgroundViewW * 0.5
        
        self.numberLabel.frame = self.selectionBackgroundView.frame
//                let  numberLabelW:CGFloat = 30.0
//                let  numberLabelH:CGFloat = numberLabelW
//                let  numberLabelX:CGFloat = (self.frame.width - numberLabelW) * 0.5
//                let  numberLabelY:CGFloat =  (self.frame.height - numberLabelH) * 0.5
//                self.numberLabel.frame = CGRect(x: numberLabelX, y: numberLabelY, width: numberLabelW, height: numberLabelH)
    }
    
    //MARK: setupUI
    func setupUI() {
        self.contentView.addSubview(self.selectionBackgroundView)
        self.contentView.addSubview(self.numberLabel)
    }
    
    //MARK: lazy
    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemRed
        return view
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        return label
    }()
}
