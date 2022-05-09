//
//  CQMainHeaderView.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/28.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

class CQMainHeaderView: UITableViewHeaderFooterView {
    lazy var waveView: CQWaveView = {
    
        let view = CQWaveView(frame: CGRect(x: 0.0, y: 0.0, width: CQScreenW, height: 50.0), color: UIColor.white, image: UIImage.init(named: "") )
//        let view = CQWaveView(frame: CGRect(x: 0, y: 0, w: CQScreenW, h: 185), color: UIColor.white, image: UIImage.init(named: "") )
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.orange
        self.addSubview(waveView)
        waveView.start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func layoutSubviews() {
         super.layoutSubviews()
        
//        waveView.frame = CGRect(x: 0.0, y: 0.0, width: self.cq_width, height: self.cq_height)
    }
    
}

