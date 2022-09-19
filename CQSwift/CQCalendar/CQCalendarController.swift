//
//  CQCalendarController.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/16.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

enum CalendarDataError: Error {
    case metadataGeneration
}

class CQCalendarController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private let weekHeight:CGFloat = 30.0
    private let stowHeight:CGFloat = 35.0
    private var selectedDate:Date
    private let calendar = Calendar(identifier: .gregorian)
    private var baseDate: Date {
        didSet {
            self.days = self.generateDaysInMonth(for: baseDate)
            self.collectionView.reloadData()
            //headerView.baseDate = baseDate
        }
    }
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    private var days:[CQCDay] = []
    
    private var numberOfWeeksInBaseDate: Int {
        self.calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }
    
    //MARK: data
    // 月 的数据
    func monthMetadata(for baseDate: Date) throws -> CQCMonth {
        
        guard
            let numberOfDaysInMonth = self.calendar.range(of: .day, in: .month, for: baseDate)?.count,
            let firstDayOfMonth = self.calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            throw CalendarDataError.metadataGeneration
        }
        
        let firstDayWeekday = self.calendar.component(.weekday, from: firstDayOfMonth)
        
        return CQCMonth(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }
    
    // 日 的数据
    func generateDaysInMonth(for baseDate: Date) -> [CQCDay] {
        guard let metadata = try? self.monthMetadata(for: baseDate) else {
            preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        
        var days:[CQCDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
            .map { day in
                
                print("day: \(day)  offsetInInitialRow:\(offsetInInitialRow)")
                // 是否 在显示的月份内
                let isWithinDisplayedMonth = day >= offsetInInitialRow
                
                let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
                print("datyOffset: \(dayOffset)")
                return self.generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
            }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        
        return days
    }
    
    // 生成 日
    func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> CQCDay {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        return CQCDay(
            date: date,
            number: dateFormatter.string(from: date),
            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }
    
    // 下个月的开始几天
    func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [CQCDay] {
        guard
            let lastDayInMonth = self.calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfDisplayedMonth)
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
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.weekData.count
        } else if section == 1 {
            return self.days.count
        } else {
            return 0
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
        } else {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 1 {
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CQCalendarFooterID", for: indexPath) as! CQCalendarFooter
                footer.stowBlock = { stow in
                    
                }
                return footer
            }
        }
        return UICollectionReusableView()
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / CGFloat(self.weekData.count)
        if indexPath.section == 0 {
            return CGSize(width: width, height: weekHeight)
        } else if indexPath.section == 1 {
            let conH = collectionView.frame.height - stowHeight - weekHeight
            let height = conH / CGFloat(numberOfWeeksInBaseDate)
            return CGSize(width: width, height: height)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
        //return CGSize(width: collectionView.frame.width, height: 30.0 * CQScaleH)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: stowHeight)
        } else {
            return .zero
        }
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.days = self.generateDaysInMonth(for: self.baseDate)
        self.view.addSubview(self.collectionView)
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else { }
    }
    
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let collectionViewX:CGFloat = 0.0
        let collectionViewY:CGFloat = self.navigationController?.navigationBar.frame.maxY ?? 64.0
        let collectionViewW:CGFloat = self.view.frame.width
        let collectionViewH:CGFloat = 268.0 * CQScaleH
        self.collectionView.frame = CGRect(x: collectionViewX, y: collectionViewY, width: collectionViewW, height: collectionViewH)
    }
    
    //MARK: lazy
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView.isScrollEnabled = false
        //collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(CQCalendarDayCell.self, forCellWithReuseIdentifier: "CQCalendarDayCellID")
        collectionView.register(CQCalendarWeekCell.self, forCellWithReuseIdentifier: "CQCalendarWeekCellID")
        collectionView.register(CQCalendarFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CQCalendarFooterID")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    let weekData: [String] = {
        return ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    }()
}
