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
            
            //print("date: \(day.date)  number: \(day.number)")
            numberLabel.text = day.number
            
            if day.isSelected {
                numberLabel.textColor = .white
                selectionBackgroundView.backgroundColor = .systemRed
            } else {
                if day.isWithinDisplayedMonth {
                    numberLabel.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
                } else {
                    numberLabel.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                }
                selectionBackgroundView.backgroundColor = .clear
            }
            if let event = day.event {
                self.dotView.isHidden = false
                let normalColor = UIColor.colorHex(hex: "#4A7AE0")
                let grayColor = UIColor.colorHex(hex: "#999999")
                self.dotView.backgroundColor = day.isWithinDisplayedMonth ? normalColor : grayColor
            } else {
                self.dotView.isHidden = true
            }
            
            self.setNeedsLayout()
        }
    }
    
    func setHighlightStatus() {
        guard let day = day else { return }

        let highlighColor = UIColor(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
        if day.isSelected {
            numberLabel.textColor = .systemRed
            selectionBackgroundView.backgroundColor = highlighColor
        } else {
            selectionBackgroundView.backgroundColor = highlighColor
        }
    }
    
    func setUnhighlightStatus() {
        guard let day = day else { return } 
        if day.isSelected {
            numberLabel.textColor = .white
            selectionBackgroundView.backgroundColor = .systemRed
        } else {
            selectionBackgroundView.backgroundColor = .clear
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
        //let selectionBackgroundViewY:CGFloat = 0.0
        self.selectionBackgroundView.frame = CGRect(x: selectionBackgroundViewX, y: selectionBackgroundViewY, width: selectionBackgroundViewW, height: selectionBackgroundViewH)
        self.selectionBackgroundView.layer.cornerRadius = selectionBackgroundViewW * 0.5
        
        self.numberLabel.frame = self.selectionBackgroundView.frame
 
        if !self.dotView.isHidden {
            let  dotViewW:CGFloat = 8.0
            let  dotViewH:CGFloat = dotViewW
            let  dotViewX:CGFloat = (self.frame.width - dotViewW) * 0.5
            let  dotViewY:CGFloat =  self.frame.height - dotViewH
            self.dotView.frame = CGRect(x: dotViewX, y: dotViewY, width: dotViewW, height: dotViewH)
            self.dotView.layer.cornerRadius = dotViewW * 0.5
        }
    }
    
    //MARK: setupUI
    func setupUI() {
        self.contentView.addSubview(self.selectionBackgroundView)
        self.contentView.addSubview(self.numberLabel)
        self.contentView.addSubview(self.dotView)
    }
    
    //MARK: lazy
    lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        return label
    }()
    
    private lazy var dotView: UIView = {
        let dot = UIView()
        dot.isHidden = true
        return dot
    }()
}
