//
//  PubDetailViewController.swift
//  GoToPub
//
//  Created by Swapnil Katkar on 15/05/18.
//  Copyright © 2018 Swapnil Katkar. All rights reserved.
//

import UIKit

class PubDetailViewController: UIViewController {

    //IBOutlet Connections
    @IBOutlet weak var detailMenuStackView: UIStackView!
    @IBOutlet weak var pubPicCollectionView: UICollectionView!
    @IBOutlet weak var pubName: UILabel!
    @IBOutlet weak var pubAddressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet var collectionViewer: [UIStackView]!
    @IBOutlet weak var bearCollectionView: UICollectionView!
    
    @IBOutlet weak var barTimmingLabel: UILabel!
    @IBOutlet weak var featureListLabel: UILabel!
    @IBOutlet weak var bearListCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var featureCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var featureListCollectionView: UICollectionView!
    @IBOutlet weak var contactNoLabel: UILabel!
    //variables and constant
    var pubFeatureImages = [UIImage]()
    var galleryImage = [UIImage]()
    var presentIndex = 0
    var id = Int()
    var pubDetails = PubDetail(dict:[:])
    var timr=Timer()
    var scrollCount = 0
    var featureListArr = [String]()
    
    //View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        //manage DataSource and Delegtes
        pubPicCollectionView.dataSource=self
        pubPicCollectionView.delegate = self
        pubPicCollectionView.reloadData()
   
        //featureListLabel.text =
        barTimmingLabel.text =  " Mon   : \(pubDetails.OpenTime_0) - \(pubDetails.ClosedTime_0) \n Tue    : \(pubDetails.OpenTime_1) - \(pubDetails.ClosedTime_1) \n Wed   : \(pubDetails.OpenTime_2) - \(pubDetails.ClosedTime_2) \n Thu    : \(pubDetails.OpenTime_3) - \(pubDetails.ClosedTime_3) \n Fri      : \(pubDetails.OpenTime_4) - \(pubDetails.ClosedTime_4) \n Sat     : \(pubDetails.OpenTime_5) - \(pubDetails.ClosedTime_5) \n Sun    : \(pubDetails.OpenTime_6) - \(pubDetails.ClosedTime_6) \n "
        
        let mirror = Mirror(reflecting: pubDetails)
        featureListArr = mirror.children.filter{$0.value as? String == "True"}.map{$0.label!.capitalized}
        //featureListLabel.text = features.isEmpty ? "" : "☑︎ " + features.joined(separator: " ☑︎ ")
      
        //assign Data
        pubName.text = pubDetails.name
        pubAddressLabel.text = pubDetails.address1
        distanceLabel.text = String(format: "%.2f km away", pubDetails.distance.km()!)
        discriptionLabel.text = pubDetails.summary
        contactNoLabel.text = pubDetails.telephone1 == "" ? "Contact : NA" : "Contact : " + pubDetails.telephone1
        
        var displayCount = pubDetails.ales.split(separator: ",").count / 4
        displayCount = pubDetails.ales.split(separator: ",").count % 4 == 0 ? displayCount  : displayCount + 1
        bearListCollectionViewHeight.constant = CGFloat(displayCount  * 60 + (20 * displayCount))
        
        var featureCount = featureListArr.count / 2
        featureCount = featureListArr.count % 2 == 0 ? featureCount : featureCount + 1
        featureCollectionViewHeightConstraint.constant = CGFloat(featureCount * 20 + (10 * featureCount))
        
        configAutoscrollTimer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // custome navigation bar
        customizeNavigationbar(isBackBtnVisible: true, hideNavigationBar: false,isMapSwitchVisible: false, headingText: "Pub Details")
        featureListCollectionView.reloadData()
        bearCollectionView.reloadData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape
        {
            print("Landscape")
            detailMenuStackView.axis = .horizontal
        }
        else
        {
            print("Portrait")
            detailMenuStackView.axis = .vertical
        }
        pubPicCollectionView.reloadData()
        self.viewDidLayoutSubviews()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        deconfigAutoscrollTimer()
    }

}
//Handle PUBList data
extension PubDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch collectionView {
        case pubPicCollectionView:
            return 8
        case featureListCollectionView:
            return featureListArr.count
        case bearCollectionView:
            return pubDetails.ales.split(separator: ",").count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == pubPicCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHeaderCollectionViewCell", for: indexPath) as! ProductHeaderCollectionViewCell
            cell.productMenuImageview.loadImage(id: pubDetails.id, tag: indexPath.row+1)
            return cell
        }
        else if collectionView == featureListCollectionView
        {
            let cell = featureListCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeatureCell
            cell.featureNameLabel.text = "☑︎ " + featureListArr[indexPath.item]
            return cell
        }
        else
        {
            let cell = bearCollectionView.dequeueReusableCell(withReuseIdentifier: "BearListCollectionCell", for: indexPath) as! BearListCollectionCell
            let bearList = pubDetails.ales.split(separator: ",").map{$0.replacingOccurrences(of: "\"", with: "")}
            cell.bearImageview.loadImageWith(url:String(bearList[indexPath.item]))
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == pubPicCollectionView
        {
            return CGSize(width: collectionView.bounds.size.width , height: collectionView.bounds.size.height)
        }
            else if collectionView == featureListCollectionView
        {
            return CGSize(width: (collectionView.bounds.size.width - 40) / 2, height: 20)
        }
        else
        {
            return CGSize(width: (collectionView.frame.size.width - 30) / 5, height: (collectionView.frame.size.width - 30) / 5)
        }
    }
}
//handle Outlet Actions
extension PubDetailViewController
{
    @IBAction func closeButtonPressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func PrevOrNextPressd(_ sender: UIButton)
    {
       presentIndex =  scrollCount
        timr.invalidate()
        if sender.tag==0
        {
            //kkk
           presentIndex = presentIndex - 1 == -1 ? 0 : presentIndex - 1
            let indexPath = IndexPath(row: presentIndex, section: 0)
            self.pubPicCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        else
        {
            presentIndex = presentIndex + 1 > 7 ? 7 : presentIndex + 1
            let indexPath = IndexPath(row: presentIndex, section: 0)
            self.pubPicCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        }
        configAutoscrollTimer()
    }
}
//Handle Other Task
extension PubDetailViewController
{
    func configAutoscrollTimer()
    {
        scrollCount = presentIndex
        timr=Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(autoScrollView), userInfo: nil, repeats: true)
    }
    func deconfigAutoscrollTimer()
    {
        timr.invalidate()
        
    }
    func onTimer()
    {
        autoScrollView()
    }
    
    @objc func autoScrollView()
    {
        let indexPath = IndexPath(row: scrollCount, section: 0)
        self.pubPicCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        scrollCount = scrollCount==7 ? 0 : scrollCount + 1
    }
}



