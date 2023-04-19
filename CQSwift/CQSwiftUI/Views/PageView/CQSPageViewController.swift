//
//  CQSPageViewController.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/19.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI
import UIKit

struct CQSPageViewController<CQSPage: View>: UIViewControllerRepresentable  {
    
    var pages:[CQSPage]
    @Binding var currentPage:Int
    
    
    /**创建自定义实例，用于将更改从视图控制器传递到SwiftUI界面的其他部分。
     * 如果视图控制器的更改可能会影响应用程序的其他部分，请实现此方法。在实现中，创建一个自定义Swift实例，该实例可以与接口的其他部分通信。例如，您可以提供一个实例，将其变量绑定到SwiftUI属性，从而使两者保持同步。如果您的视图控制器不与应用程序的其他部分进行交互，则不需要提供协调器。
     * SwiftUI 在调用``UIViewControllerRepresentable/makeUIViewController(context:)`` 方法之前调用该方法。当调用可表示实例的其他方法时，系统直接 或 作为上下文结构的一部分提供coordinator（协调器）。
     */
    func makeCoordinator() -> CQSCoordinator {
        CQSCoordinator(self)
    }
    
    //MARK: UIViewControllerRestoration
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        // coordinator 视图的关联协调器。
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }
    
    //当应用程序的状态发生变化时，SwiftUI会更新受这些变化影响的界面部分。
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]],
            direction: .forward,
            animated: true)
    }
    
    //UIHostingController 每次SwiftUI视图更新时托管页面。管理SwiftUI视图层次结构的UIKit视图控制器。
    class CQSCoordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        var  parent: CQSPageViewController
        var controllers = [UIViewController]()
        
        init(_ pageViewController: CQSPageViewController) {
            parent = pageViewController
            controllers = parent.pages.map({ page in
                UIHostingController(rootView: page)
            })
        }
        
        //MARK: UIPageViewControllerDataSource
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.count {
                return controllers.first
            }
            return controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return controllers.last
            }
            return controllers[index - 1]
        }
        
        //MARK: UIPageViewControllerDelegate
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed {
                guard let visibleViewcontroller = pageViewController.viewControllers?.first else { return }
                guard let index = controllers.firstIndex(of: visibleViewcontroller) else { return }
                parent.currentPage = index
            }
        }
        
    }
    
}

