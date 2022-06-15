//
//  CQNestedMainTableView.swift
//  CQSwift
//
//  Created by 李超群 on 2022/5/18.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQNestedMainTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CQNestedCellDelegate {
    
    let navH:CGFloat = 64.0
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
        if CQNestedManager.shared.hiddenSubTableViewScroll { return }
        
//        // 滑动方向
//                let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
//                if (translatedPoint.y < 0) {
//                    self.isDown = false
//                    NSLog("上滑")
//                }
//                if (translatedPoint.y > 0) {
//                    self.isDown = true
//                    NSLog("下滑")
//                }
        
        let rect1 = self.rectForHeader(inSection: 1)
        let rect2 = self.rectForHeader(inSection: 2)
        // section1 是否到了顶部 true:越过了顶部 false:还未到顶部
        let overTop = scrollView.contentOffset.y >= rect1.origin.y - navH
        // section2 是否到了底部 true:越过了底部 false:还未到底部
        let height = scrollView.bounds.height
        let overBottom = scrollView.contentOffset.y > rect2.origin.y - height
        if scrollView.contentOffset.y < self.lastContentOffsetY { // 向上滑动↑↑↑
            print("向上")
            if overBottom { // section2 越过了底部
                print("section2 越过了底部")
                self.nestedCell?.canScoll = false
            } else { // section2 还未到底部
                print("section2 还未到底部")
                if overTop { // section1 越过了顶部
                    print("section1 越过了顶部")
                    if self.subPosition == .top {
                        print("top")
                        self.nestedCell?.canScoll = false
                    } else if self.subPosition == .bottom {
                        print("bottom")
                        self.nestedCell?.canScoll = true
                        scrollView.contentOffset = CGPoint(x: 0.0, y: rect1.origin.y - navH)
                    } else if self.subPosition == .between {
                        print("between")
                        self.nestedCell?.canScoll = true
                        scrollView.contentOffset = CGPoint(x: 0.0, y: rect1.origin.y - navH)
                    }
                } else {  // section1 还未到顶部
                    print("section1 还未到顶部")
                    if self.subPosition == .top {
                        print("top")
                        self.nestedCell?.canScoll = false
                    } else if self.subPosition == .bottom {
                        print("bottom")
                        self.nestedCell?.canScoll = true
                        scrollView.contentOffset = CGPoint(x: 0.0, y: rect1.origin.y - navH)
                    } else if self.subPosition == .between {
                        print("between")
                        self.nestedCell?.canScoll = true
                        scrollView.contentOffset = CGPoint(x: 0.0, y: rect1.origin.y - navH)
                    }
                }
            }
        } else if (scrollView.contentOffset.y > self.lastContentOffsetY ) { // 向下滑动 ↓↓↓
            print("向下")
            if overTop { // section1 越过了顶部
                print("section1 越过了顶部")
                if overBottom { // section2 越过了底部
                    print("section2 越过了底部")
                    if self.subPosition == .top {
                        print("top")
                        self.nestedCell?.canScoll = true
                        scrollView.contentOffset = CGPoint(x: 0.0, y: rect1.origin.y - navH)
//                        self.nestedCell.current
                    } else if self.subPosition == .bottom {
                        print("bottom")
                        self.nestedCell?.canScoll = false
                    } else if self.subPosition == .between {
                        print("between")
                        self.nestedCell?.canScoll = true
                        scrollView.contentOffset = CGPoint(x: 0.0, y: rect1.origin.y - navH)
                    }
                } else { // section2 还未到底部
                    print("section2 还未到底部")
                    if self.subPosition == .top {
                        print("top")
                        self.nestedCell?.canScoll = true
                        scrollView.contentOffset = CGPoint(x: 0.0, y: rect1.origin.y - navH)
                    } else if self.subPosition == .bottom {
                        print("bottom")
                        self.nestedCell?.canScoll = false
                    } else if self.subPosition == .between {
                        print("between")
                        self.nestedCell?.canScoll = true
                        scrollView.contentOffset = CGPoint(x: 0.0, y: rect1.origin.y - navH)
                    }
                }
            } else { // section1 还未到顶部
                print("section1 还未到顶部")
                self.nestedCell?.canScoll = false
            }
        } else {
            //self.nestedCell?.canScoll = true
            print("----no-----")
        }
        self.lastContentOffsetY = scrollView.contentOffset.y
    }
//    scr
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
            cell.indexPath = indexPath
            cell.delegate = self
            self.nestedCell = cell
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellID", for: indexPath)
            cell.contentView.backgroundColor = .white
            cell.textLabel?.text = "第\(indexPath.section)组：第\(indexPath.row)行"
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
            let maxHeight = tableView.frame.height - navH - headerH
            return CQNestedManager.shared.calculateSubTableViewHeight(maxHeight)
            //return tableView.frame.height - navH - headerH
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
//
//        if let view = super.hitTest(point, with: event) {
//            print("\(view.self)")
//            return view
//        }
//
//        return nil
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
