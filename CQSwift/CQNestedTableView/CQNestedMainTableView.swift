//
//  CQNestedMainTableView.swift
//  CQSwift
//
//  Created by 李超群 on 2022/5/18.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQNestedMainTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CQNestedCellDelegate {
    
    let navH:CGFloat = 44.0

    let starBarH = CQStatusBarFrame?.size.height ?? 20.0
    let headerH:CGFloat = 30.0
    
    var subPosition:CQNSubTableViewPosition = .top
    var nestedCell:CQNestedCell?
    
    var lastContentOffsetY:CGFloat = 0.0
    
    //MARK: CQNestedCellDelegate
    func subTableViewPosition(_ position: CQNSubTableViewPosition) {
        self.subPosition = position
    }
    func reloadNestedCell() {
        self.reloadData()
        //self.reloadSections([1], animationStyle: .none)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffsetY = scrollView.contentOffset.y
    }
    // 主tableView的滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let rect1 = self.rectForHeader(inSection: 1)
        // section1 是否到了顶部 true:到了顶部 false:还未到顶部
        let overTop = scrollView.contentOffset.y >= rect1.origin.y - navH - starBarH
        if scrollView.contentOffset.y < self.lastContentOffsetY { // 向上滑动↑↑↑
            print("向上↑↑↑")
            if nestedCell?.position == .top {
                nestedCell?.canScoll = false
            } else {
                nestedCell?.canScoll = true
                scrollView.contentOffset = CGPoint(x: 0.0, y: rect1.origin.y - navH - starBarH)
            }
        } else if (scrollView.contentOffset.y > self.lastContentOffsetY ) { // 向下滑动 ↓↓↓
            print("向下滑动 ↓↓↓")
            if overTop { // section1 达到了顶部
                
                nestedCell?.canScoll = true
                scrollView.contentOffset = CGPoint(x: 0.0, y: rect1.origin.y - navH - starBarH)
            } else { // section1 还未到顶部
                nestedCell?.canScoll = false
            }
        } else {
        }
        self.lastContentOffsetY = scrollView.contentOffset.y
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
            cell.contentView.backgroundColor = .clear
            cell.textLabel?.text = "第\(indexPath.section)组：第\(indexPath.row)行"
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CQNestedCellID", for: indexPath) as! CQNestedCell
            cell.indexPath = indexPath
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
            return CQScreenH - navH - starBarH - headerH
//            let maxHeight = CQScreenH - navH - starBarH - headerH
//            return CQNestedManager.shared.calculateSubTableViewHeight(maxHeight)
        } else if indexPath.section == 2 {
            return 50.0
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CQNestedHeaderViewID") as! CQNestedHeaderView
        headerView.section = section
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerH
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      
        if let view = otherGestureRecognizer.view, view.isKind(of: CQNestedScrollView.self) {
            return false
        }
        return true //同时响应多个手势
    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        return false
//    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print("event: \(event)")
//        return CQNestedManager.shared.currentTableView
//        let hitView = super.hitTest(point, with: event)
//        if hitView == self {
//            return nil
//        } else {
//            return hitView
//        }
//    }
    
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
