

import UIKit
class PubListViewController: UIViewController {
    @IBOutlet weak var pubListTableview: UITableView!
    @IBOutlet weak var moreInfoView: UIView!
    @IBOutlet weak var extraInfoHolderHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var extraTitleImageCollectionView: UICollectionView!
    @IBOutlet weak var extraInfoCollectionView: UICollectionView!
    
    @IBOutlet weak var detailMenuStackView: UIStackView!
    var imageArr = [UIImage]()
    var selectedProductImages = [UIImage](){didSet{extraInfoCollectionView.reloadData()
        extraTitleImageCollectionView.reloadData()}}
    
    override func viewDidLoad() {
        
        self.title = "Pub List"
        for images in ["resort","icecream","coffee","snacks","wineCup","chiken","wineCup2"]
        {
            imageArr.append(UIImage(named: images)!)
        }
        extraInfoHolderHightConstraint.constant = self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)!
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        extraInfoHolderHightConstraint.constant = self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)!
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
        self.extraInfoCollectionView.reloadData()
        self.extraTitleImageCollectionView.reloadData()
        self.moreInfoView.layoutIfNeeded()
    }
    
}
//Handle IBActions
extension PubListViewController
{
    @IBAction func closeExtrainfo(_ sender: UIButton)
    {
        manageExtraInfoView()
    }
}
//Handle UI Information
extension PubListViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PubListDisplayCell") as? PubListDisplayCell
        cell?.productImages = imageArr
        cell?.AvailabelProductsCollectionView.reloadData()
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let detailVC = self.loadViewController(identifier:"PubDetailViewController") as! PubDetailViewController
        detailVC.pubFeatureImages = imageArr
        self.present(detailVC, animated: true, completion: nil)
        //manageExtraInfoView()
    }
    func manageExtraInfoView()
    {
        if moreInfoView.transform == .identity
        {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations:
                {
                    self.moreInfoView.transform =  CGAffineTransform.init(translationX: 0, y:-self.extraInfoHolderHightConstraint.constant)
                    
            }) { (cmpleted) in
                
            }
        }
        else
        {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations:
                {
                    self.moreInfoView.transform =  .identity
                    
            }) { (cmpleted) in
                
            }
        }
    }
}
//Handle PUBList data
extension PubListViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return selectedProductImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == extraInfoCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableProductCollectionViewCell", for: indexPath) as! AvailableProductCollectionViewCell
            cell.productMenuImageview.image = selectedProductImages[indexPath.item]
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
        if collectionView == extraTitleImageCollectionView
        {
            return CGSize(width: collectionView.bounds.size.width , height: collectionView.bounds.size.height)
        }
        else
        {
            return CGSize(width: collectionView.bounds.size.width / CGFloat(selectedProductImages.count), height: collectionView.bounds.size.height)
        }
    }
}
//Handle slideMenuDelegate
extension PubListViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
