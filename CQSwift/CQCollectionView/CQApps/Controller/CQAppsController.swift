//
//  PHHomeMoreController.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2019/9/25.
//  Copyright © 2019 yhb. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class CQAppsController: UIViewController,CQTopViewModelDelegate,CQMoreViewModelDelegate {
    
    var saveBlock:(()->())?
    
    // 设置属性保存导航的interactivePopGestureRecognizer的代理，记得使用weak标记弱引用
    weak var savedGestureRecognizerDelegate:UIGestureRecognizerDelegate?
    
    // MARK: CQTopViewModelDelegate
    func editAppEvent() {
        self.topViewModel.editStatus = true
        self.navigationItem.rightBarButtonItem?.title = "保存"
        self.collectionView.reloadData()
        self.topView.reloadData()
        
        self.view.setNeedsLayout()
    }
    func reduceAppEvent(_ cell: CQMoreCell) {
        if self.topViewModel.tempModelArray.count == 1 {
            //请至少保留1个菜单
            return
        }
        if let frequentlyModel = cell.model {
            // 1.修改对应model的状态
            if CQMoreDataManager.shared.sectionModelArray.count <= frequentlyModel.section { return }
            let sectionModel = CQMoreDataManager.shared.sectionModelArray[frequentlyModel.section]
            if sectionModel.list?.count ?? 0 <= frequentlyModel.item { return }
            guard let model = sectionModel.list?[frequentlyModel.item] else {
                return
            }
            model.status = .add
            /*
            CQMoreDataManager.shared.sectionModelArray.forEach({ (sectionModel) in
                let appModels = sectionModel.list?.filter({ (model) -> Bool in
                    if frequentlyModel.appId == model.appId {
                        model.status = .add
                        return true
                    }
                    return false
                })
                if let models = appModels, let model = models.first {
                    toIndexPath = IndexPath(item: Int(model.item), section: Int(model.section))
                    return
                }
            })
             */
            // 2.移除 常用model
            if let index = self.topViewModel.tempModelArray.firstIndex(of: frequentlyModel) {
                self.topViewModel.tempModelArray.remove(at: index)
            }
            self.topViewModel.tempModelArray = self.topViewModel.tempModelArray
            
            
            let totalLine = 4 // 共几列
            let headerH = CGFloat(45.0)
            let cellH = CGFloat(85.0)
            let lineSpacing = CGFloat(2.0)
            
            // 计算将要修改的cell的位置
            
            var toCellMaxY:CGFloat = 0.0
            for i in 0...model.section {
                debugPrint("toIndexPathsection: \(i)")
                
                let sectionModel = CQMoreDataManager.shared.sectionModelArray[i]
                guard let list = sectionModel.list else { return }
                var row:Int!
                if model.section == i {// 所在的组
                    row = model.item / totalLine //在第几行
                } else {
                    row = (list.count - 1) / totalLine //当前组共几行
                }
                let totalLineSpacingH = CGFloat(row) * lineSpacing
                let totalCellH = CGFloat(row + 1) * cellH
                toCellMaxY += totalCellH + totalLineSpacingH + headerH
            }
            
            let toCellCenterY = toCellMaxY - cellH * 0.5
            debugPrint("toCellCenterY: \(toCellCenterY)")
            let toLine = model.item % totalLine // 第几列
            let cellW = CQScreenW/4.0
            let toCellCenterX = CGFloat(toLine) * cellW + 0.5 * cellW
            
            let toCenter = CGPoint(x: toCellCenterX, y: toCellCenterY)
            var convertViewCellCenter = self.collectionView.convert(toCenter, to: self.view)
            if convertViewCellCenter.y < self.collectionView.frame.minY {
                convertViewCellCenter.y = self.collectionView.frame.minY
            }
            // 临时cell
            guard let tempCell = cell.snapshotView(afterScreenUpdates: false) else { return }
            let convertCenter = self.topView.convert(cell.center, to: self.view)
            tempCell.center = convertCenter
            self.view.addSubview(tempCell)
            
            // 移动cell
            cell.setAddPlaceholderStatus()
            if let indexPath = self.topView.indexPath(for: cell) {
                let moveToIndexPath = IndexPath(item: self.topViewModel.tempModelArray.count, section: 0)
                self.topView.moveItem(at: indexPath, to: moveToIndexPath)
            }
            
    
            UIView.animate(withDuration: 0.3, animations: {
                tempCell.center = convertViewCellCenter
                //tempCell?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                //tempCell?.alpha = 0
            }, completion: { (success) in
                // 3. 刷新
                //guard let indexPath = self.topView.indexPath(for: cell) else { return }
                //self.topView.deleteItems(at: [indexPath])
                //self.topView.reloadItems(at: [indexPath])
                //self.topView.insertItems(at: [indexPath])
                //self.topView.reloadData()
                
                self.collectionView.reloadData()
                
                tempCell.removeFromSuperview()
            })
            
   
        }
    }
    func moreView(_ collectionView: CQTopView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //        debugPrint("\(sourceIndexPath) +++ \(destinationIndexPath)")
    }
    
    func moreViewEndMove(_ collectionView: CQTopView, from originIndexPath: IndexPath?, to destinationIndexPath: IndexPath?) {
        guard let fromIndexPath = originIndexPath, let toIndexPath = destinationIndexPath else {
            return
        }
        if self.topViewModel.tempModelArray.count <= toIndexPath.item { return }
        let fromModel = self.topViewModel.tempModelArray[fromIndexPath.item]
        if let index = self.topViewModel.tempModelArray.firstIndex(of: fromModel) {
            self.topViewModel.tempModelArray.remove(at: index)
        }
        self.topViewModel.tempModelArray.insert(fromModel, at: toIndexPath.item)
        
        //        debugPrint("\(fromIndexPath) --- \(toIndexPath)")
    }
    // MARK: CQMoreViewModelDelegate
    func addAppEvent(_ cell: CQMoreCell) {
        if cell.model?.status == .added {
            return
        }
        if self.topViewModel.tempModelArray.count >= 7 {
            //展示最多添加7个菜单
            return
        }
        
        if let model = cell.model {
            // 1.
            model.status = .added
            cell.setAddedStatus()
            
            // 2.
            self.topViewModel.tempModelArray.append(model)
            
            // 计算将要添加的cell的位置
            let line = (self.topViewModel.tempModelArray.count - 1) % 4// 第几列
            let width = CQScreenW/4.0
            let centerX = CGFloat(line) * width + 0.5 * width
            let row = (self.topViewModel.tempModelArray.count - 1) / 4//第几行
            let height = CGFloat(85.0)
            let centerY = CGFloat(row) * (height + 2.0) + height * 0.5 + 45.0
            
            let center = CGPoint(x: centerX, y: centerY)
            let convertViewCellCenter = self.topView.convert(center, to: self.view)
            
            // 临时cell
            let tempCell = cell.snapshotView(afterScreenUpdates: false)
            let convertCenter = self.collectionView.convert(cell.center, to: self.view)
            tempCell?.center = convertCenter
            self.view.addSubview(tempCell!)
            
            let lastIndexPath = IndexPath(item: self.topViewModel.tempModelArray.count - 1, section: 0)
            UIView.animate(withDuration: 0.3, animations: {
                tempCell?.center = convertViewCellCenter
                //tempCell?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                //tempCell?.alpha = 0
            }, completion: { (success) in
                //self.topView.reloadData()
                //self.topView.reloadItems(at: [lastIndexPath])
                self.topView.insertItems(at: [lastIndexPath])
                
                tempCell?.removeFromSuperview()
            })
        }
    }
    // MARK:saveItemCliked
    @objc fileprivate func saveItemCliked(_ sender: UIBarButtonItem?) {
        if self.topViewModel.editStatus == false { return }
        self.topViewModel.editStatus = false
        self.navigationItem.rightBarButtonItem?.title = ""
        self.collectionView.reloadData()
        self.topView.reloadData()
        self.view.setNeedsLayout()
        
        self.save()
    }
    fileprivate func save() {
        CQMoreDataManager.shared.modelArray = self.topViewModel.tempModelArray
        CQFrequentlyAppModel.updateAllModels(self.topViewModel.tempModelArray)
        if let block = self.saveBlock {
            block()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topViewX = CGFloat(0.0)
        let topViewY = CGFloat(0.0)
        let topViewW = self.view.frame.width
        let topViewH = self.topViewModel.editStatus ? CGFloat(226.0) : CGFloat(70.0)
        self.topView.frame = CGRect(x: topViewX, y: topViewY, width: topViewW, height: topViewH)

        let collectionViewX = topViewX
        let collectionViewY = self.topView.frame.maxY
        let collectionViewW = topViewW
        let collectionViewH = self.view.frame.height - topViewH
        self.collectionView.frame = CGRect(x: collectionViewX, y: collectionViewY, width: collectionViewW, height: collectionViewH)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = true
        self.setupUI()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isTranslucent = false
//        savedGestureRecognizerDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = savedGestureRecognizerDelegate
//    }
//    //遵守UIGestureRecognizerDelegate协议，把手势返回的代理方法实现为空
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
//            return false
//        }
//        return true
//    }
    private func setupUI() {
        self.title = "更多"

        let rightItem = UIBarButtonItem(title: "", style: .plain, target: self, action:#selector(saveItemCliked(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.isTranslucent = false
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.topView)
        self.topViewModel.view = self.topView
    }
    //MARK: lazy
    lazy var topViewModel: CQTopViewModel = {
        let viewModel = CQTopViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    lazy var topView: CQTopView = {
        let flowLayout = UICollectionViewFlowLayout()
        let colView = CQTopView.init(frame: CGRect(x: 0.0, y: 0.0, width: CQScreenW, height: 216.0), collectionViewLayout: flowLayout)
        colView.delegate = self.topViewModel
        colView.dataSource = self.topViewModel
        colView.viewModel = self.topViewModel
        colView.register(CQMoreCell.self, forCellWithReuseIdentifier: self.topViewModel.cellID)
        colView.register(CQMoreHeader.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.topViewModel.appHeaderID)
        colView.register(CQMoreEditHeader.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.topViewModel.appEditHeaderID)
        colView.register(CQMoreFooter.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.topViewModel.appFooterID)
        return colView
    }()
    lazy var colViewModel: CQMoreViewModel = {
        let viewModel = CQMoreViewModel()
        viewModel.topViewModel = self.topViewModel
        viewModel.delegate = self
        return viewModel
    }()
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let colView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: CQScreenW, height: CQScreenH), collectionViewLayout: flowLayout)
        colView.delegate = self.colViewModel
        colView.dataSource = self.colViewModel
        colView.backgroundColor = .white
        colView.showsVerticalScrollIndicator = false
        colView.register(CQMoreCell.self, forCellWithReuseIdentifier: self.topViewModel.cellID)
        colView.register(CQMoreHeader.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.topViewModel.appHeaderID)
        return colView
    }()
}
