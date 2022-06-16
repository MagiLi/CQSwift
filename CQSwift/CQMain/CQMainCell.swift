//
//  TableViewCell.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/20.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

class CQMainCell: UITableViewCell {

    public var title: String? {
        didSet{
            titleLab?.text = title
        }
    }
    
    
    var titleLab : UILabel?
//    var line = UIView()
    //懒加载
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.white
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "CQMainCellID")
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.orange
        titleLab = UILabel()
//        line.backgroundColor = UIColor.white
        self.contentView.addSubview(titleLab!)
        self.contentView.addSubview(self.line)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLab?.frame = CGRect(x: 10.0, y: 0.0, width: self.frame.width - 20.0, height: self.frame.height)
        self.line.frame = CGRect(x: 0.0, y: self.frame.height - 1.0, width: self.frame.width, height: 1.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
