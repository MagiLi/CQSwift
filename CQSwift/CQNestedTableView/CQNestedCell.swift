//
//  CQNestedCell.swift
//  CQSwift
//
//  Created by 李超群 on 2022/5/18.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

protocol CQNestedCellDelegate:NSObjectProtocol {
    func mainTableViewCanScroll()
}

class CQNestedCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource  {
    var delegate:CQNestedCellDelegate?
    var tableViewArray = [CQNestedSubTableView]()
    let tableViewCount = 4
    
    
    var cellCanScroll: Bool = false {
        didSet {
            self.tableViewArray.enumerated().forEach { (i, tableV) in
                tableV.canScroll = cellCanScroll
                if cellCanScroll {
                    print("子tableView可以滑动")
                } else {
                    tableV.contentOffset = .zero
                }
            }
        }
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? CQNestedSubTableView else { return }
        if tableView.canScroll {
            print("CQNestedSubTableView-\(tableView.tag): 可以滑动")
        } else {
            tableView.contentOffset = .zero
        }
        if tableView.contentOffset.y <= 0 {
            self.cellCanScroll = false
            tableView.canScroll = false
            tableView.contentOffset = .zero
            self.delegate?.mainTableViewCanScroll()
        }
    }
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellID", for: indexPath)
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.text = "第\(tableView.tag)个：第\(indexPath.row)行"
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        return view
    }()
    
}
