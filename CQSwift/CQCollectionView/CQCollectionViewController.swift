//
//  CQCollectionViewController.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/21.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CQCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var dataArray = NSMutableArray.init(array: ["The First metal demo ","Press me 1","Press me 2","Press me 3","Press me 4"])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView?.alwaysBounceVertical = true

//        self.collectionView?.backgroundColor = UIColor.randomColor()
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView!.register(CQCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CQCollectionViewCell
    
//        cell.content = "Press me " + String(format: "%d", indexPath.item) as NSString
        cell.content = dataArray[indexPath.item] as? NSString
        return cell
    }
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch indexPath.item {
        case 0:
            let mtlFirstVC = CQMetalFirstController()
            self.navigationController?.pushViewController(mtlFirstVC, animated: true)
        case 1:
             let mtlSecondVC = CQMetalSecondController()
             self.navigationController?.pushViewController(mtlSecondVC, animated: true)
            break
        default:
            break;
        }
    }
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50.0)
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let source = self.dataArray[sourceIndexPath.item]
        self.dataArray.remove(source)
        self.dataArray.insert(source, at: destinationIndexPath.item)
    }


}
