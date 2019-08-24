//
//  CQTableViewController.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/24.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let cellID = "CQTableViewCellID"

class CQTableViewController: UIViewController {
    let disposeBag = DisposeBag()
    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "tableView"
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.tableView.register(CQTableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView)
        
        let items = Observable.just(CQTableViewCellModel().array)
        items.bind(to: self.tableView.rx.items) { (tableView, row, model) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? CQTableViewCell
            cell?.titlteLabel?.text = model.title as String?
            cell?.nameLabel?.text = model.subTitle as String?
            return cell!

        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CQDataModel.self).subscribe(onNext:{ (model) in
            print(model)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            print("indexPath \(indexPath.row)")
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("finished")
        }).disposed(by: disposeBag)
//        self.tableView.rx.sec
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class CQTableViewCell: UITableViewCell {
    
    var titlteLabel:UILabel?
    var nameLabel:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titlteLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: self.contentView.bounds.height))
        self.contentView.addSubview(self.titlteLabel!)
        
        self.nameLabel = UILabel(frame: CGRect(x: self.titlteLabel!.bounds.maxX, y: 0, width: 100, height: self.contentView.bounds.height))
        self.contentView.addSubview(self.nameLabel!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getvalue(titleStr:String,nameStr:String){
        self.titlteLabel?.text = titleStr
        self.nameLabel?.text = nameStr
    }
    
}
