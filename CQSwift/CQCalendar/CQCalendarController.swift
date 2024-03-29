//
//  CQCalendarController.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/16.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

enum CalendarDataError: Error {
    case metadataGeneration
}

class CQCalendarController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CQCalendarDateHeaderDelegate {
    
    private var show:Bool = true
    private let weekCellHeight:CGFloat = 30.0 // 周的高度
    private let stowHeight:CGFloat = 35.0 // 收缩footer的高度
    //private let calendarHeight:CGFloat = 268.0 * CQScaleH
    private let dayCellHeight:CGFloat = 55.0
    
    private let section2MarginLeft:CGFloat = 15.0
    private let section2MarginBottom:CGFloat = 15.0
    
    private var tipsFooterHeight:CGFloat = 80.0
    private var tipsFooterText:NSAttributedString?
    private var selectedDate:Date
    /*
       NSCalendarIdentifierGregorian         公历
       NSCalendarIdentifierBuddhist          佛教日历
       NSCalendarIdentifierChinese           中国农历
       NSCalendarIdentifierHebrew            希伯来日历
       NSCalendarIdentifierIslamic           伊斯兰日历
       NSCalendarIdentifierIslamicCivil      伊斯兰教日历
       NSCalendarIdentifierJapanese          日本日历
       NSCalendarIdentifierRepublicOfChina   中华民国日历（台湾）
       NSCalendarIdentifierPersian           波斯历
       NSCalendarIdentifierIndian            印度日历
       NSCalendarIdentifierISO8601           ISO8601
     */
    //private let calendar = Calendar.current
    private let calendar = Calendar(identifier: .gregorian)
//    lazy var calendar: Calendar = {
//        var calendar = Calendar(identifier: .gregorian)
//        calendar.locale = Locale.init(identifier: "zh_Hans_CN")
//        return calendar
//    }()
    private var baseDate: Date {
        didSet {
            self.days = self.generateDaysInMonth(for: baseDate)
            
            self.collectionView.reloadData()
            //headerView.baseDate = baseDate
            let indexPath = IndexPath(item: 0, section: 0)
            guard let header = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? CQCalendarDateHeader else { return}
            header.date = monthFormatter.string(from: self.baseDate)
        }
    }
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        dateFormatter.locale = Locale.init(identifier: "zh_Hans_CN")
        dateFormatter.timeZone = .current
        //dateFormatter.locale = .autoupdatingCurrent
        //dateFormatter.timeZone = .autoupdatingCurrent
        return dateFormatter
    }()
    private lazy var monthFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.calendar = Calendar(identifier: .gregorian)
      dateFormatter.locale = Locale.autoupdatingCurrent
      //dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
        dateFormatter.dateFormat = "yyyy年MM月"
      return dateFormatter
    }()
    private var days:[CQCDay] = []
    private var  currentEvents:[EKEvent]? // 当前展示日期范围内的事件
    private var selectionDay:CQCDay? // 选中的天
    
    private var numberOfWeeksInBaseDate: Int {
        self.calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }
    
    func getYearData() {
        let formatter = DateFormatter()
        formatter.timeZone = .autoupdatingCurrent
        formatter.locale = .current
        formatter.dateFormat = "yyyyMMdd"
        guard let startDay = formatter.date(from: "20220101") else { return }
        guard let endDay = formatter.date(from: "20411231") else { return }
        let dateComponents = self.calendar.dateComponents([.year], from: startDay, to: endDay)
        var currentMonth = self.calendar.component(.month, from: startDay)
        print("currentMonth: \(currentMonth)")
        
        let yearCount = dateComponents.year ?? 0
        let minYear:Int = 2022
//        var currentYear = minYear
//        for i in 0..<yearCount {
//            currentYear += 1
//            print("currentYear: \(currentYear)")
//        }
        let count = self.calendar.range(of: .month, in: .year, for: startDay)?.count
        //print("count: \(count)")
        //print("dateComponents: \(dateComponents.year!)-- \(dateComponents.month)")

        //self.calendar.component(.year, from: <#T##Date#>)
//        let firstM = self.calendar.component(<#T##component: Calendar.Component##Calendar.Component#>, from: <#T##Date#>)
//        print("firstM: \(firstM)")
        
    }
    
    //MARK: 月 的数据
    func monthMetadata(for baseDate: Date) throws -> CQCMonth {
        let dateComponents = self.calendar.dateComponents([.year, .month], from: baseDate)
        guard
            let numberOfDaysInMonth = self.calendar.range(of: .day, in: .month, for: baseDate)?.count,
            let firstDayOfMonth = self.calendar.date(from: dateComponents)
        else {
            throw CalendarDataError.metadataGeneration
        }
        //print("firstDayOfMonth:\(firstDayOfMonth)")
        // firstDayOfMonth在这周是第几天（默认星期天是第一天）
        // firstDayOfMonth如果是周一计算出的firstDayWeekday就是2
        let firstDayWeekday = self.calendar.component(.weekday, from: firstDayOfMonth)
        //print("firstDayWeekday:\(firstDayWeekday)")
        return CQCMonth(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday
        )
    }
    
    //MARK: 日 的数据
    func generateDaysInMonth(for baseDate: Date) -> [CQCDay] {
        guard let metadata = try? self.monthMetadata(for: baseDate) else {
            preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay // 当前月的第一天
        
        var days:[CQCDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
            .map { day in
                
                ////print("day: \(day)  offsetInInitialRow:\(offsetInInitialRow)")
                // 是否 在显示的月份内
                let isWithinDisplayedMonth = day >= offsetInInitialRow
                
                let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
                ////print("datyOffset: \(dayOffset)")
                return self.generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
            }
        
        days += self.generateStartOfNextMonth(using: firstDayOfMonth)
        days = self.matchEvent(days: days)
        return days
    }
    
    //MARK: 生成 日
    func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> CQCDay {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        return CQCDay(
            date: date,
            number: dateFormatter.string(from: date),
            isToday: calendar.isDate(date, inSameDayAs: selectedDate),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }
    
    //MARK: 下个月的开始几天
    func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [CQCDay] {
        // 下个月 前一天（也就是下个月第一天的前一天，即这个月的最后一天）
        let dateComp = DateComponents(month: 1, day: -1)
        // firstDayOfDisplayedMonth所在月份的最后一天
        guard
            let lastDayInMonth = self.calendar.date(byAdding: dateComp, to: firstDayOfDisplayedMonth)
        else {
            return []
        }
        
        let additionalDays = self.weekData.count - self.calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }
        
        let days:[CQCDay] = (1...additionalDays).map {
            self.generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)
        }
        
        return days
    }
    
    //MARK: 匹配事件
    func matchEvent(days:[CQCDay]) -> [CQCDay] {
        if let firstDay = days.first, let lastDay = days.last {
            self.currentEvents = CQCalenderEventManager.query(startDate: firstDay.date, endDate: lastDay.date, calendars: nil)
            guard let currentEvents = currentEvents, currentEvents.count > 0 else {
                return self.matchSelectionDay(days: days)
            }
            var newDays:[CQCDay] = []
            days.enumerated().forEach { i, day in
                // 匹配节日事件
                var newDay = day
                currentEvents.forEach { event in
                    //event.startDate.compare(day.date)
                    let compare1 = event.startDate <= day.date
                    let compare2 = day.date <= event.endDate
                    if compare1 && compare2 {
                        newDay.event = event
                    }
                }
                if let selectionDay = selectionDay, selectionDay.date == day.date {
                    newDay.isSelected = true
                }
                newDay.index = i
                newDays.append(newDay)
            }
            return newDays
            //return self.matchSelectionDay(days: newDays)
        } else {
            // 清空节日事件
            self.currentEvents = nil
            return self.matchSelectionDay(days: days)
        }
    }
    
    // 1.匹配选中的 day。2.设置在集合中的索引。
    fileprivate func matchSelectionDay(days:[CQCDay]) -> [CQCDay] {
        var newDays:[CQCDay] = []
        days.enumerated().forEach { i, day in
            var newDay = day
            if let selectionDay = selectionDay, selectionDay.date == day.date {
                newDay.isSelected = true
            }
            newDay.index = i
            newDays.append(newDay)
        }
        return newDays
    }
    
    //MARK: CQCalendarDateHeaderDelegate
    func dateViewClickedEvent() {
        let frame = UIScreen.main.bounds
        let pickerView = PHCalendarDatePickerView(frame: frame, currentDate: self.baseDate)
        pickerView.selectedBlock = { [weak self] date in
            self?.baseDate = date
        }
        UIApplication.shared.keyWindow?.addSubview(pickerView)
    }
    func addButtonClickedEvent(_ sender: UIButton) {
        
    }
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.weekData.count
        } else if section == 1 {
            if self.show {
            //if self.collectionView.collectionViewLayout.isKind(of: CQCFlowLayoutShow.self) {
                return self.days.count
            } else  {
                return 7
            }
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQCalendarWeekCellID", for: indexPath) as!  CQCalendarWeekCell
            if self.weekData.count <= indexPath.item { return cell }
            cell.week = self.weekData[indexPath.item]
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQCalendarDayCellID", for: indexPath) as!  CQCalendarDayCell
            if self.days.count <= indexPath.item { return cell }
            cell.day = self.days[indexPath.item]
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CQCalendarEventCellID", for: indexPath) as!  CQCalendarEventCell
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CQCalendarDateHeaderID", for: indexPath) as! CQCalendarDateHeader
                header.date = self.monthFormatter.string(from: self.baseDate)
                header.delegate = self
                return header
            }
        } else if indexPath.section == 1 {
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CQCalendarFooterID", for: indexPath) as! CQCalendarFooter
                footer.stowBlock = { [weak self] stow in
                    guard let self = self else { return }
                    self.show = !stow
                    self.showCollectionView(animate: true)
                }
                footer.previousBlock = {
                    guard let baseDate = self.calendar.date(byAdding: .month, value: -1, to: self.baseDate)  else { return }
                    self.baseDate = baseDate
                }
                footer.nextBlock = {
                    guard let baseDate = self.calendar.date(byAdding: .month, value: 1, to: self.baseDate)  else { return }
                    self.baseDate = baseDate
                }
                return footer
            }
        } else if indexPath.section == 2 {
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CQCalendarEventHeaderID", for: indexPath) as! CQCalendarEventHeader
                return header
            } else if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CQCalendarTipsFooterID", for: indexPath) as! CQCalendarTipsFooter
                footer.descLabel.attributedText = self.tipsFooterText
                return footer
            }
        }
        
        return UICollectionReusableView()
    }
    
    //MARK: 展开/收起 
    fileprivate func showCollectionView(animate:Bool) {
//        if stow {
//            self.collectionView.setCollectionViewLayout(CQCFlowLayoutStow(), animated: true)
//        } else {
//            self.collectionView.setCollectionViewLayout(CQCFlowLayoutShow(), animated: true)
//        }

        if animate {
            var indexPaths:[IndexPath] = []
            self.days.enumerated().forEach { (i, day) in
                if i < 7 { return }
                let indexPath = IndexPath(item: i, section: 1)
                indexPaths.append(indexPath)
            }
            self.collectionView.performBatchUpdates {
                if self.show {
                    self.collectionView.insertItems(at: indexPaths)
                } else {
                    self.collectionView.deleteItems(at: indexPaths)
                }
            }
        } else {
            self.collectionView.reloadData()
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = collectionView.frame.width / CGFloat(self.weekData.count)
            return CGSize(width: width, height: weekCellHeight)
        } else if indexPath.section == 1 {
//            let conH = collectionView.frame.height - stowHeight - weekCellHeight
//            var height:CGFloat = conH / CGFloat(numberOfWeeksInBaseDate)
////            if self.show {
////                height = conH / CGFloat(numberOfWeeksInBaseDate)
////            } else {
////                height = conH / 5.0
////            }
//            return CGSize(width: width, height: height)
            let width = collectionView.frame.width / CGFloat(self.weekData.count)
            return CGSize(width: width, height: dayCellHeight)
        } else if indexPath.section == 2 {
            let width = collectionView.frame.width - section2MarginLeft * 2.0
            return CGSize(width: width, height: 112.0)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 55.0)
        } else if section == 2 {
            return CGSize(width: collectionView.frame.width, height: 55.0)
        } else {
            return .zero
        }
        //return CGSize(width: collectionView.frame.width, height: 30.0 * CQScaleH)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: stowHeight)
        } else if section == 2 {
            return CGSize(width: collectionView.frame.width, height: self.tipsFooterHeight)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return 15.0
        } else {
            return 0.0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return UIEdgeInsets(top: 0.0, left: section2MarginLeft, bottom: section2MarginBottom, right: section2MarginLeft)
        } else {
            return .zero
        }
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 1 { return }
        if self.days.count <= indexPath.item { return }
        var day = self.days[indexPath.item]
        if day.isSelected { return }
        if var selectionDay = selectionDay { // 将上次选中的day 设置为非选中状态
            selectionDay.isSelected = false
            let index = selectionDay.index
            if self.days.count > index {
                self.days.remove(at: selectionDay.index)
                self.days.insert(selectionDay, at: selectionDay.index)
            }
        }
        day.isSelected = true  // 将当前点击的day 设置为选中状态
        self.selectionDay = day
        self.days.remove(at: indexPath.item)
        self.days.insert(day, at: indexPath.item)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 1)
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CQCalendarDayCell else { return }
        cell.setHighlightStatus()
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CQCalendarDayCell else { return }
        cell.setUnhighlightStatus()
    }
    
    //MARK: rightItemClicked
    @objc func rightItemClicked() {
        let vc = CQEventListController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: init
    init(baseDate: Date = Date()) {
        self.selectedDate = baseDate
        self.baseDate = baseDate
        
        super.init(nibName: nil, bundle: nil)
        
        //      modalPresentationStyle = .overCurrentContext
        //      modalTransitionStyle = .crossDissolve
        //      definesPresentationContext = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorHex(hex: "#F7F7F7")
        self.days = self.generateDaysInMonth(for: self.baseDate)
        self.title = "智能日历"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "EventEdit", style: .plain, target: self, action: #selector(rightItemClicked))
        self.view.addSubview(self.collectionView)
        
        let msg = "1.您可查询年度账单生成日、归还本金和利息日期等提醒信息。\n2.您可根据需要设置缴费、工资发放、纪念日等提醒信息。"
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.paragraphSpacing = 5.0
        let attributes:[NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.colorHex(hex: "#666666"),
            .font: UIFont.systemFont(ofSize: 16.0),
            .paragraphStyle: paragraphStyle
        ]
        let attText = NSAttributedString(string: msg, attributes: attributes)
        let size = CGSize(width: CQScreenW - 30.0, height: CGFloat.greatestFiniteMagnitude)
        let rect = attText.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        self.tipsFooterHeight = rect.size.height + 45.0
        self.tipsFooterText = attText
//        if #available(iOS 11.0, *) {
//            self.collectionView.contentInsetAdjustmentBehavior = .never
//        } else { }
        
        self.getYearData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController as? CQMainNavController {
            
            let color = UIColor.colorHex(hex: "#EBF3FE")
            //let color = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
            nav.setNavigationBar(color)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nav = self.navigationController as? CQMainNavController {
            
            nav.setNavigationBar(nil)
        }
    }
    
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let collectionViewX:CGFloat = 0.0
//        let collectionViewY:CGFloat = self.navigationController?.navigationBar.frame.maxY ?? 64.0
//        let collectionViewW:CGFloat = self.view.frame.width
//        let collectionViewH:CGFloat = 268.0 * CQScaleH
//        self.collectionView.frame = CGRect(x: collectionViewX, y: collectionViewY, width: collectionViewW, height: collectionViewH)
        
        self.collectionView.frame = self.view.bounds
    }
    
    //MARK: lazy
    private lazy var collectionView: UICollectionView = {
        let layout = CQCFlowLayoutShow()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView.isScrollEnabled = false
        //collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(CQCalendarDateHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CQCalendarDateHeaderID")
        collectionView.register(CQCalendarDayCell.self, forCellWithReuseIdentifier: "CQCalendarDayCellID")
        collectionView.register(CQCalendarWeekCell.self, forCellWithReuseIdentifier: "CQCalendarWeekCellID")
        collectionView.register(CQCalendarFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CQCalendarFooterID")
        collectionView.register(CQCalendarEventHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CQCalendarEventHeaderID")
        collectionView.register(CQCalendarEventCell.self, forCellWithReuseIdentifier: "CQCalendarEventCellID")
        collectionView.register(CQCalendarTipsFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CQCalendarTipsFooterID")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let weekData: [String] = {
        return ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    }()
    
}
