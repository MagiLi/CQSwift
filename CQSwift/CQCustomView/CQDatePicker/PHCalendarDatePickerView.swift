//
//  PHCalendarDatePickerView.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2022/10/14.
//  Copyright © 2022 yhb. All rights reserved.
//

import UIKit

enum PHCDatePickerType:Int {
    case yyyyMM = 0         // 展示 年、月
    case yyyyMMdd = 1      // 展示 年、月、日
}

let calendarDateFormatter = "yyyyMMddhhmmss"

class PHCalendarDatePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let calendar = Calendar(identifier: .gregorian)
    var yearsArray:[Int] = []
    fileprivate let monthCount = 12 // 一年12个月
    fileprivate var daysCount = 31 // 当前选中的月份有几天
    fileprivate let dateFormatter = "yyyyMMdd"
    var formatType:PHCDatePickerType = .yyyyMM
    var showFinished:Bool = false
    var selectedBlock:((_ date:Date)->())?
    
    //MARK: hidePickerView
    @objc func hidePickerView() {
        UIView.animate(withDuration: 0.25) {
            self.bgMaskView.alpha = 0.0
            self.contentView.cq_y = self.bounds.height
        } completion: { (success) in
            self.bgMaskView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    func showPickerView(_ finished:@escaping()->()) {
        self.showFinished = true
        self.setNeedsLayout()
        UIView.animate(withDuration: 0.25) {
            self.bgMaskView.alpha = 1.0
            self.layoutIfNeeded()
        } completion: { (success) in
            self.bgMaskView.alpha = 1.0
            finished()
        }
    }
    
    //MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if formatType == .yyyyMMdd {
            return 3
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.yearsArray.count
        } else if component == 1 {
            return self.monthCount // 一年12个月
        } else if component == 2 {
            return self.daysCount
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            if self.yearsArray.count <= row { return nil}
            let selectedYear = self.yearsArray[row]
            return "\(selectedYear)年"
        } else if component == 1 {
            return String(format: "%02d月", (row + 1))
        } else if component == 2 {
            return String(format: "%02d日", (row + 1))
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var contentView:PHCDatePickerContentView?
        if let conView = view as? PHCDatePickerContentView {
            contentView = conView
        } else {
            contentView = PHCDatePickerContentView()
        }
        contentView!.content = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return contentView!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if formatType == .yyyyMMdd {
            if component == 0 {
                let selectedMonth = pickerView.selectedRow(inComponent: 1)
                self.daysCount = self.getDaysCountInMonth(yearIndex: row, monthIndex: selectedMonth)
                self.pickerView.reloadAllComponents()
//                self.pickerView.reloadComponent(1)
            } else if component == 1 {
                let selectedYearRow = pickerView.selectedRow(inComponent: 0)
                self.daysCount = self.getDaysCountInMonth(yearIndex: selectedYearRow, monthIndex: row)
                self.pickerView.reloadAllComponents()
            }
        } else if formatType == .yyyyMM {
//            if component == 0 {
//                self.pickerView.reloadComponent(1)
//            }
        }
    }
    
    fileprivate func getDaysCountInMonth(yearIndex:Int, monthIndex:Int)-> Int {
        if yearIndex >= self.yearsArray.count { return self.daysCount }
        let selectedYear = self.yearsArray[yearIndex]
        if self.monthCount <= monthIndex  { return self.daysCount }
        let dateStr = String(format: "%d%02d01", selectedYear, (monthIndex + 1))
        guard let selDate = Date(fromString: dateStr, format: self.dateFormatter) else { return self.daysCount }
        guard let count = self.calendar.range(of: .day, in: .month, for: selDate)?.count  else { return self.daysCount }
        return count
    }
    
    //MARK: init
    convenience init(frame: CGRect, currentDate:Date?, formatType:PHCDatePickerType = .yyyyMM) {
        self.init(frame:frame)
        self.formatType = formatType
        guard let minDate = Date(fromString: "20220101", format: dateFormatter) else { return }
        guard let maxDate = Date(fromString: "20411231", format: dateFormatter) else { return }
        let dateComp = self.calendar.dateComponents([.year, .month], from: minDate, to: maxDate)
        
        var minYear = self.calendar.component(.year, from: minDate)
       
        var selectedYearIndex = 0
        var selectedDayIndex = 0
        let selDate = currentDate ?? Date()
        // 当前选中的年份
        let selectedYear = self.calendar.component(.year, from: selDate)
        // 当前选中的月 索引
        let selectedMonthIndex = self.calendar.component(.month, from: selDate) - 1
        
        if formatType == .yyyyMMdd {
            self.daysCount = self.calendar.range(of: .day, in: .month, for: selDate)?.count ?? 31
            // 当前选中的日 索引
            selectedDayIndex = self.calendar.component(.day, from: selDate) - 1
        }


        let count = dateComp.year ?? 0
        for i in 0...count {
            // 当前选中的年份索引
            if  minYear == selectedYear {
                selectedYearIndex = i
            }
            self.yearsArray.append(minYear)
            minYear += 1
        }
        
        self.setupUI()
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.showPickerView({ [weak self] in
                self?.pickerView.selectRow(selectedYearIndex, inComponent: 0, animated: true)
                self?.pickerView.selectRow(selectedMonthIndex, inComponent: 1, animated: true)
                if formatType == .yyyyMMdd { 
                    self?.pickerView.selectRow(selectedDayIndex, inComponent: 2, animated: true)
                }
                self?.isUserInteractionEnabled = true
            })
        })
    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    private lazy var yearFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = Locale.init(identifier: "zh_Hans_CN")
        dateFormatter.timeZone = .current
        return dateFormatter
    }()
    
    //MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bgMaskView.frame = self.bounds
        
        let contentViewH:CGFloat = 250.0 + self.safeAreaInsets.bottom
        var contentViewY:CGFloat!
        if self.showFinished {
            contentViewY = self.bounds.height - contentViewH
        } else {
            contentViewY = self.bounds.height
        }
        //let contentViewY = self.bounds.height
        let contentViewW = self.bounds.width
        self.contentView.frame = CGRect(x: 0.0, y: contentViewY, width: contentViewW, height: contentViewH)
        
        let headerViewH:CGFloat = 40.0
        let headerViewY = 0.0
        let headerViewW = self.contentView.frame.width
        self.headerView.frame = CGRect(x: 0.0, y: headerViewY, width: headerViewW, height: headerViewH)
        
        let pickerViewH = contentViewH - self.safeAreaInsets.bottom + 30.0
        let pickerViewY = 10.0
        let pickerViewW = headerViewW
        self.pickerView.frame = CGRect(x: 0.0, y: pickerViewY, width: pickerViewW, height: pickerViewH)
    }
    
    //MARK: setupUI
    func setupUI() {
        self.addSubview(self.bgMaskView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.pickerView)
        self.contentView.addSubview(self.headerView)
        
        self.headerView.sureBlock = { [weak self] in
            guard let self = self else { return }
            let selYear = self.pickerView.selectedRow(inComponent: 0)
            if selYear >= self.yearsArray.count { return }
            let year = self.yearsArray[selYear]
            let selMonth = self.pickerView.selectedRow(inComponent: 1)
            if selMonth >= self.monthCount  { return }

            if self.formatType == .yyyyMMdd {
                let selDay = self.pickerView.selectedRow(inComponent: 2)
                if selDay >= self.monthCount  { return }
                // 默认10点
                let dateStr = String(format: "%d%02d%02d100000", year, (selMonth + 1), (selDay + 1))
                guard let selDate = Date(fromString: dateStr, format: calendarDateFormatter) else { return }
                self.selectedBlock?(selDate)
            } else {
                let dateStr = String(format: "%d%02d01", year, (selMonth + 1))
                guard let selDate = Date(fromString: dateStr, format: self.dateFormatter) else { return }
                self.selectedBlock?(selDate)
            } 
            self.hidePickerView()
        }
        self.headerView.cancelBlock = {  [weak self] in
            self?.hidePickerView()
        }
    }
    //MARK: lazy
    fileprivate lazy var bgMaskView: UIView = {
        let mask = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePickerView))
        mask.addGestureRecognizer(tap)
        mask.backgroundColor = UIColor(white: 0, alpha: 0.5)
        mask.frame = UIScreen.main.bounds
        return mask
    }()
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        return contentView
    }()
    fileprivate lazy var headerView: PHCDatePickerHeaderView = {
        let view = PHCDatePickerHeaderView()
        return view
    }()
    
    fileprivate lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        
        return pickerView
    }()
}
