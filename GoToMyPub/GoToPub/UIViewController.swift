//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
import Foundation
extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        let serchbtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        serchbtn.addTarget(self, action:#selector(openSearchVC), for: .touchUpInside)
        serchbtn.setImage(UIImage(named: "Search"), for: .normal)
        let barButtonRight = UIBarButtonItem(customView: serchbtn)
        self.navigationItem.rightBarButtonItem = barButtonRight
        let textAtrributes = [NSAttributedStringKey.foregroundColor :UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAtrributes
        self.navigationController!.navigationBar.barTintColor = UIColor(hex: "F2522A")
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    @objc func openSearchVC()
    {
     if let leftMenuVC = slideMenuController()?.leftViewController as? LeftViewController
     {
        leftMenuVC.slideMenuController()?.changeMainViewController(leftMenuVC.searchViewController, close: true)
    }
    }
    func loadViewController(identifier:String) -> UIViewController
    {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
}
