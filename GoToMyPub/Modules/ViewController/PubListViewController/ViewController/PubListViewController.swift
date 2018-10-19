//
//  PubListViewController.swift
//  GoToMyPub
//
//  Created by Swapnil Katkar on 16/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
class PubListViewController: UIViewController {
    @IBOutlet weak var pubListTableview: UITableView!

    var imageArr = [UIImage]()
    var pubList = [PubDetail]()

    override func viewDidLoad() {
        //Customise navigation bar
        UserDefaults.standard.set(1, forKey:"switch")
        UserDefaults.standard.synchronize()
        customizeNavigationbar(isBackBtnVisible: true, hideNavigationBar: false,isMapSwitchVisible: true, headingText:"Pub List")
    }
}

//Handle UI Information
extension PubListViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pubList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PubListDisplayCell") as? PubListDisplayCell
        let pubInfo = pubList[indexPath.row]
        cell?.pubName.text = pubInfo.name
        cell?.addressLabel.text = pubInfo.address1
        cell?.distanceLabel.text = String(format: "%.2f km away", pubInfo.distance.km()!)
        cell?.infoHolderView.addShadow()
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        showLoaderFor(title: "Please wait ...")
        let parameter = ["id":pubList[indexPath.row].id]
        SearchRequestHander.getPostResponseForIdDetails(request: GET_PUBDETAILS_BY_ID_URL, withParameter: parameter) { (response) in
            switch response
            {
            case .success(let publists):
                print(publists)
                let detailVC = self.loadViewController(identifier:"PubDetailViewController") as! PubDetailViewController
                detailVC.pubDetails = publists.pubDetails.last!
                detailVC.pubFeatureImages = self.imageArr
                self.navigationController?.pushViewController(detailVC, animated: true)
                
            case .failure(let error):
                switch error {
                case .unknownError( _,_) :
                    self.showAlertFor(title: "Search Alert", description: NO_DATA_ERROR)
                default:
                    self.showAlertFor(title: "Search Alert", description: UnknownError)
                }
            }
            self.dissmissLoader()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    }
    
}

//Show pubs on Map
extension PubListViewController
{
    @objc func showMapVC()
    {
      self.navigationController?.popViewController(animated: true)
    }
}

