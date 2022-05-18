//
//  CQNestedMainTableView.swift
//  CQSwift
//
//  Created by 李超群 on 2022/5/18.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQNestedMainTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CQNestedCellDelegate {
    
    var canScroll = true
    var nestedCell:CQNestedCell?
    
    //MARK: CQNestedCellDelegate
    func mainTableViewCanScroll() {
        self.canScroll = true
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let rect = self.rectForHeader(inSection: 1)
        if scrollView.contentOffset.y >= rect.origin.y - 64.0 {
            scrollView.contentOffset = CGPoint(x: 0.0, y: rect.origin.y)
            self.canScroll = false
            self.nestedCell?.cellCanScroll = true
        } else {
            if !self.canScroll {
                scrollView.contentOffset = CGPoint(x: 0.0, y: rect.origin.y)
            }
        }
    }
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellID", for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.textLabel?.text = "第\(indexPath.section)组：第\(indexPath.row)行"
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CQNestedCellID", for: indexPath) as! CQNestedCell
            cell.delegate = self
            self.nestedCell = cell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellID", for: indexPath)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50.0
        } else if indexPath.section == 1 {
            return tableView.frame.height
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CQNestedHeaderViewID") as! CQNestedHeaderView
        headerView.section = section
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let view = otherGestureRecognizer.view, view.isKind(of: CQNestedScrollView.self) {
            return false
        }
        return true //同时响应多个手势
    }
    
    //MARK: init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        
        self.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellID")
        self.register(CQNestedCell.self, forCellReuseIdentifier: "CQNestedCellID")
        self.register(CQNestedHeaderView.self, forHeaderFooterViewReuseIdentifier: "CQNestedHeaderViewID")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
