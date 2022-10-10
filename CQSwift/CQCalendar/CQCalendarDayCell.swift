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
    let selectionColor = UIColor.colorHex(hex: "#4A7AE0")
    var day:CQCDay? {
        didSet {
            guard let day = day else { return }
            
            //print("date: \(day.date)  number: \(day.number)")
            if day.isSelected { // 1.选中状态
                print("day.isSelected: \(day.index)")
                self.selectionView.isHidden = false
                self.dotView.isHidden = true
                if let event = day.event {
                    self.selectionView.image = UIImage(named: "calendar_sel_bg_dot")
                } else {
                    self.selectionView.image = UIImage(named: "calendar_sel_bg")
                }
                
                numberLabel.text =  day.number
                numberLabel.textColor = .white
                self.numberLabel.layer.borderColor = UIColor.clear.cgColor
            } else { // 2.非选中状态
                self.selectionView.isHidden = true
                if day.isToday { // 2.1 今天
                    self.numberLabel.text = "今"
                    self.numberLabel.textColor = UIColor.colorHex(hex: "#FF9501")
                    self.numberLabel.layer.borderColor = UIColor.colorHex(hex: "#FF9501").cgColor
                    self.dotView.isHidden = true // 今天非选中状态隐藏“点”
                    //highlightView.backgroundColor = .systemRed
                } else { // 2.2 非今天
                    self.numberLabel.text = day.number
                    if day.isWithinDisplayedMonth { // 当月内
                        self.numberLabel.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
                    } else {
                        self.numberLabel.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                    }
                    self.numberLabel.layer.borderColor = UIColor.clear.cgColor
                    
                    if let event = day.event {
                        self.dotView.isHidden = false
                        let grayColor = UIColor.colorHex(hex: "#999999")
                        self.dotView.backgroundColor = day.isWithinDisplayedMonth ? selectionColor : grayColor
                    } else {
                        self.dotView.isHidden = true // 无节日隐藏“点”
                    }
                }
            }
            
            self.setNeedsLayout()
        }
    }
    
    func setHighlightStatus() {
        guard let day = day else { return }

        let highlighColor = UIColor(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
        highlightView.backgroundColor = highlighColor
        if day.isSelected { // 选中状态
            self.selectionView.isHidden = true
            numberLabel.textColor = selectionColor
        }
    }
    
    func setUnhighlightStatus() {
        guard let day = day else { return }
        highlightView.backgroundColor = .clear
        if day.isSelected {  // 选中状态
            self.selectionView.isHidden = false
            numberLabel.textColor = .white
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
        let min = min(min(frame.width, frame.height) - 10.0, 60)
        let highlightViewW = traitCollection.horizontalSizeClass == .compact ? min : 30.0
        //let  highlightViewW:CGFloat = 30.0
        let highlightViewH:CGFloat = highlightViewW
        let highlightViewX:CGFloat = (self.frame.width - highlightViewW) * 0.5
        let highlightViewY:CGFloat =  (self.frame.height - highlightViewH) * 0.5
        //let highlightViewY:CGFloat = 0.0
        self.highlightView.frame = CGRect(x: highlightViewX, y: highlightViewY, width: highlightViewW, height: highlightViewH)
        self.highlightView.layer.cornerRadius = highlightViewW * 0.5
        self.selectionView.frame = self.highlightView.frame
        self.numberLabel.frame = self.highlightView.frame
        if let day = self.day, day.isToday {
            self.numberLabel.layer.cornerRadius = highlightViewW * 0.5
        } else {
            self.numberLabel.layer.cornerRadius = 0.0
        }
 
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
        self.contentView.addSubview(self.highlightView)
        self.contentView.addSubview(self.selectionView)
        self.contentView.addSubview(self.numberLabel)
        self.contentView.addSubview(self.dotView)
    }
    
    //MARK: lazy
    lazy var highlightView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    lazy var selectionView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.clear.cgColor
        return label
    }()
    
    private lazy var dotView: UIView = {
        let dot = UIView()
        dot.isHidden = true
        return dot
    }()
}
