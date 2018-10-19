//
//  PubListDisplayCell.swift
//  GotoMyPub
//
//  Created by Swapnil Katkar on 11/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class PubListDisplayCell: UITableViewCell {

    @IBOutlet weak var listHolderView: UIView!
    
    var productImages = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // listHolderView.dropShadow()
        // Initialization code
    }
    @IBOutlet weak var AvailabelProductsCollectionView: UICollectionView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension PubListDisplayCell : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableProductCollectionViewCell", for: indexPath) as! AvailableProductCollectionViewCell
        cell.productMenuImageview.image = productImages[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / CGFloat(productImages.count), height: collectionView.bounds.size.height)
    }
}
