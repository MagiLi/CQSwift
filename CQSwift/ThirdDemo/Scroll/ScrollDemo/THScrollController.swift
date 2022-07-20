//
//  THScrollController.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/7/20.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class THScrollController: UIViewController {
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }

    // MARK: - Private
    
    private let scrollView = SimpleScrollView()
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = UIColor(white: 0.16, alpha: 1.0)
        
        let img = UIImage(named: "metro_scheme")!
        let imgView = UIImageView(image: img)
        scrollView.contentView = imgView
        scrollView.contentSize = img.size
        scrollView.contentOffset = CGPoint(x: (img.size.width - view.bounds.width) / 2,
                                           y: (img.size.height - view.bounds.height) / 2)
    }

}
