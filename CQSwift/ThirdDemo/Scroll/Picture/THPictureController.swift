//
//  THPictureController.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/7/20.
//  Copyright © 2022 李超群. All rights reserved.
//参考文章 https://blog.csdn.net/Px01Ih8/article/details/113749837

import UIKit

class THPictureController: UIViewController {
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateDebugState()
    }

    // MARK: - Private
    
    private let bgImageView = UIImageView()
    private var pipContainer = PipContainer()
    
    private var isDebug = true {
        didSet {
            updateDebugState()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(bgImageView)
        bgImageView.contentMode = .scaleAspectFill
        
        view.addSubview(pipContainer)
        
        setupLayout()
    }
    
    private func setupLayout() {
        let inset: CGFloat = 24
        
        pipContainer.translatesAutoresizingMaskIntoConstraints = false
        pipContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset)
            .isActive = true
        pipContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: inset)
            .isActive = true
        pipContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
            .isActive = true
        pipContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -inset)
            .isActive = true
            
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bgImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bgImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func updateDebugState() {
        pipContainer.isDebug = isDebug
        bgImageView.image = isDebug ? nil : UIImage(named: "face_02")
    }

}
