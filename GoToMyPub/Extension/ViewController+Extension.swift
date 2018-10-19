//
//  ViewController+Extension.swift
//  GoToMyPub
//
//  Created by Swapnil Katkar on 16/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController
{
   
    func customizeNavigationbar(isBackBtnVisible: Bool, hideNavigationBar : Bool,isMapSwitchVisible:Bool, headingText: String)
    {
        
        self.navigationController?.navigationItem.hidesBackButton = true
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "back"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.backButtonpressed), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "sideMenu"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        
        let mapView = UIButton(type: .custom)
        mapView.imageView?.tintColor = UIColor.white
        let status = UserDefaults.standard.value(forKey: "switch") as! Int
        let imagename = status == 0 ? "pubList" : "MapView"
        mapView.setImage(UIImage(named: imagename), for: .normal)
        mapView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if let mapOBJ = self as? MapViewController
        {
        mapView.addTarget(mapOBJ, action: #selector(MapViewController.showPubListVC), for: UIControlEvents.touchUpInside)
        }
        if let pubListOBJ = self as? PubListViewController
        {
          mapView.addTarget(pubListOBJ, action: #selector(PubListViewController.showMapVC), for: UIControlEvents.touchUpInside)
        }
         let mapViewItem = UIBarButtonItem(customView: mapView)
        
        let searchBtn = UIButton(type: .custom)
        searchBtn.setImage(UIImage(named: "Search"), for: .normal)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchBtn.addTarget(self, action: #selector(openSearchWindowOn(_:)), for: UIControlEvents.touchUpInside)
        let searchButtonItem = UIBarButtonItem(customView: searchBtn)
        
        self.navigationController?.navigationBar.barTintColor=UIColor.red
        let label = UILabel(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width/2 , height:44))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = headingText
        self.navigationItem.titleView = label
        
        if isBackBtnVisible {
            self.navigationItem.setLeftBarButtonItems([item1,item2], animated: true)
        } else {
            self.navigationItem.setLeftBarButtonItems([item2], animated: true)
        }
        //for search button
        
        self.navigationItem.setRightBarButtonItems(isMapSwitchVisible ? [searchButtonItem,mapViewItem] : [searchButtonItem], animated: true)
        
        if hideNavigationBar {
            self.navigationController?.isNavigationBarHidden = true
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        let topVc = self.navigationController?.topViewController
        
        if topVc == nil {
            return
        }
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    @objc func backButtonpressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadViewController(identifier:String) -> UIViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        return controller
    }
    
     @objc func openSearchWindowOn(_ viewController:UIViewController)
    {
        for controller: UIViewController? in navigationController?.viewControllers ?? [UIViewController?]() {
            if (controller is SearchViewController) {
                if let aController = controller {
                    navigationController?.popToViewController(aController, animated: true)
                }
                return
            }
            else
            {
                let searchVC = loadViewController(identifier: "SearchViewController") as! SearchViewController
                self.navigationController?.setViewControllers([searchVC], animated: false)
            }
        }
        
    }
   func showAlertFor(title: String, description: String)
   {
    let actionSheetController: UIAlertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
    let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
        //Just dismiss the action sheet
    }
    actionSheetController.addAction(cancelAction)
    self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func showOptionViewFor(title:String,dataSource:[String],previousSelectedItem:[String])->OptionviewPresenter
    {
        let optionMenuVC = loadViewController(identifier: "OptionviewPresenter") as! OptionviewPresenter
        optionMenuVC.modalPresentationStyle = .overCurrentContext
        optionMenuVC.dropdownTitleStr = title
        optionMenuVC.optionElementsArr = dataSource
        optionMenuVC.previousSelectedItems=previousSelectedItem
        self.present(optionMenuVC, animated: false)
        return optionMenuVC
    }
    
    func showLoaderFor(title:String)
    {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = title
    }
    func dissmissLoader()
    {
        DispatchQueue.main.async {
             MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
}

