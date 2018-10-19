//
//  PubDetailViewController.swift
//  GoToPub
//
//  Created by Swapnil Katkar on 15/05/18.
//  Copyright © 2018 Swapnil Katkar. All rights reserved.
//

import UIKit

class PubDetailViewController: UIViewController {

    @IBOutlet weak var detailMenuStackView: UIStackView!
     @IBOutlet weak var pubFeatureCollectionView: UICollectionView!
    @IBOutlet weak var pubPicCollectionView: UICollectionView!
    
    //variables and constant
    var pubFeatureImages = [UIImage]()
    var galleryImage = [UIImage]()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        pubFeatureCollectionView.dataSource=self
        pubFeatureCollectionView.delegate = self
        pubPicCollectionView.dataSource=self
        pubPicCollectionView.delegate = self
        pubFeatureCollectionView.reloadData()
        pubPicCollectionView.reloadData()

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
        pubFeatureCollectionView.reloadData()
        pubPicCollectionView.reloadData()
        self.viewDidLayoutSubviews()
    }

}
//Handle PUBList data
extension PubDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return pubFeatureImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == pubFeatureCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableProductCollectionViewCell", for: indexPath) as! AvailableProductCollectionViewCell
            cell.productMenuImageview.image = pubFeatureImages[indexPath.item]
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHeaderCollectionViewCell", for: indexPath) as! ProductHeaderCollectionViewCell
            cell.productMenuImageview.image = UIImage(named: "launchImages")
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == pubPicCollectionView
        {
            return CGSize(width: collectionView.bounds.size.width , height: collectionView.bounds.size.height)
        }
        else
        {
            return CGSize(width: collectionView.bounds.size.width / CGFloat(pubFeatureImages.count), height: collectionView.bounds.size.height)
        }
    }
}
extension PubDetailViewController
{
    @IBAction func closeButtonPressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
