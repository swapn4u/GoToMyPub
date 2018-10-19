//
//  MenuViewController.swift
//  GoToMyPub
//
//  Created by Swapnil Katkar on 16/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    
    var menuList = ["Home","Search","Log Out"]
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //profileImage.layer.borderWidth = 2.0
       // profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        
//ll
    }

}
//menu list handler
extension MenuViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuList[indexPath.row], for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(true, forKey: "mapFromMenu")
        UserDefaults.standard.synchronize()
        print("clicked")
//
//        let cell = tableView.cellForRow(at: indexPath)
//        let label = cell?.viewWithTag(0) as? UILabel
//        label?.textColor=UIColor.black
//        cell?.backgroundColor = UIColor.black
    }
}
