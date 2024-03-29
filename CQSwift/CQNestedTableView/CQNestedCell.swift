//
//  CQNestedCell.swift
//  CQSwift
//
//  Created by 李超群 on 2022/5/18.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

enum CQNSubTableViewPosition:Int {
    case top = 0 // 子视图滚动到了顶部
    case bottom = 1 // 子视图滚动到了底部
    case between = 2 // 子视图滚动到了顶部和底部之间的位置
}

protocol CQNestedCellDelegate:NSObjectProtocol {
    func subTableViewPosition(_ position:CQNSubTableViewPosition)
    func reloadNestedCell()
}

class CQNestedCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource  {
    
    var delegate:CQNestedCellDelegate?
    var indexPath:IndexPath?
    var tableViewArray = [CQNestedSubTableView]()
    let tableViewCount = 4
    
    var canScoll:Bool = false  {
        didSet {
            if self.canScoll { return }
            if self.canScoll == oldValue { return }
            self.tableViewArray.enumerated().forEach { offset, tableView in
                if offset != CQNestedManager.shared.currentTableViewIndex {
                    tableView.contentOffset = .zero
                }
            }
        }
    }
    var position:CQNSubTableViewPosition = .top
    
    //MARK:
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("subTableView - scroll")
        if let tableView = scrollView as? CQNestedSubTableView {
            self.nestedTableViewScroll(tableView)
        } else if let scrollV = scrollView as? CQNestedScrollView {
            self.nestedScrollViewScroll(scrollV)
        }
      
    }
    
    fileprivate func nestedTableViewScroll(_ tableView:CQNestedSubTableView) { 
        if !self.canScoll { // 不能滚动
            tableView.contentOffset = .zero
        }
        let offsetY = tableView.contentOffset.y
        if offsetY <= 0 { // 滚动到顶部
            //print("position: top")
            tableView.contentOffset = .zero
            self.position = .top
            self.delegate?.subTableViewPosition(.top)
        } else {
            let contentSizeH = tableView.contentSize.height
            let height = tableView.frame.size.height
            if contentSizeH <= height + offsetY { // 滚动到底部
                self.position = .bottom
                self.delegate?.subTableViewPosition(.bottom)
            } else {
                self.position = .between
                self.delegate?.subTableViewPosition(.between)
            }
        }
    }
    fileprivate func nestedScrollViewScroll(_ scrollView:CQNestedScrollView) {
        
    }
     
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let scrollV = scrollView as? CQNestedScrollView {
            let index = ceilf(Float(scrollV.contentOffset.x / scrollV.frame.width))
            var currentIndex = Int(index)
            if CQNestedManager.shared.currentTableViewIndex == currentIndex { return }
            if currentIndex >= self.tableViewArray.count {
                currentIndex = self.tableViewArray.count - 1
            }
            CQNestedManager.shared.currentTableViewIndex = currentIndex
            CQNestedManager.shared.currentTableView = self.tableViewArray[currentIndex]
            self.delegate?.reloadNestedCell()
        }
    }
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CQNestedManager.shared.numberOfRows(tableView.tag)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellID", for: indexPath)
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.text = "第\(self.indexPath!.section)组：第\(tableView.tag)个，第\(indexPath.row)行"
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CQNestedManager.shared.subTableViewRowHeight
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.scrollContentView)
        self.tableViewArray.removeAll()
        for i in 0..<4 {
            let tableV = CQNestedSubTableView(frame: .zero, style: .plain)
            tableV.tag = i
            tableV.delegate = self
            tableV.dataSource = self
            tableV.backgroundColor = CQRandomColor
            tableV.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellID")
            self.scrollContentView.addSubview(tableV)
            self.tableViewArray.append(tableV)
            if i == 0 {
                CQNestedManager.shared.currentTableView = tableV
            }
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollContentView.frame = self.bounds
        let contentSizeW = self.bounds.width * CGFloat(self.tableViewCount)
        self.scrollContentView.contentSize = CGSize(width: contentSizeW, height: self.bounds.height)
        self.tableViewArray.enumerated().forEach { (i, tableV) in
            let tableVW = CGFloat(tableV.tag) * self.bounds.width
            tableV.frame = CGRect(x: tableVW, y: 0.0, width: self.bounds.width, height: self.bounds.height)
        }
    }
    
    //MARK: lazy
    lazy var scrollContentView: CQNestedScrollView = {
        let view = CQNestedScrollView(frame: .zero)
        view.isPagingEnabled = true
        view.delegate = self
        return view
    }()
    
}
