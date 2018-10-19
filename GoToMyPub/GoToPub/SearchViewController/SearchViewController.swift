//
//  SwiftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//



import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTabView: UIView!
    @IBOutlet weak var normalSearchWindow: UIView!
    
    @IBOutlet weak var advanceSearchWindow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "Search"
         self.setNavigationBarItem()
    }
    override func viewWillAppear(_ animated: Bool) {
         self.searchTabView.transform = .identity
        self.normalSearchWindow.transform = .identity
        self.advanceSearchWindow.transform = .identity
    }
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchTabView.transform = CGAffineTransform(translationX: 0, y: 90)
        }) { (completed) in
            UIView.animate(withDuration: 0.5, animations: {
               self.normalSearchWindow.transform = CGAffineTransform(translationX: 0, y: 230)
            })
        }
    
    }
    @IBAction func SearchOptionChanged(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.advanceSearchWindow.transform = .identity
            }) { (completed) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.normalSearchWindow.transform = CGAffineTransform(translationX: 0, y: 230)
                })
            }
        }
        else
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.normalSearchWindow.transform = .identity
            }) { (completed) in
                UIView.animate(withDuration: 0.5, animations: {
                   self.advanceSearchWindow.transform = CGAffineTransform(translationX: 0, y: 430)
                })
            }
        }
    }
    
    
}
