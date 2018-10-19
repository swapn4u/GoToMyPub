//
//  MenuViewController.swift
//  GoToMyPub
//
//  Created by Swapnil Katkar on 10/04/18.
//  Copyright © 2018 Apple. All rights reserved.
//
import UIKit
import GooglePlaces

class SearchViewController: UIViewController {
  // IBOutlet Collection
    @IBOutlet weak var searchTabView: UIView!
    @IBOutlet weak var normalSearchWindow: UIView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var pubFeatureButton: UIButton!
    @IBOutlet weak var beerListButton: UIButton!
    @IBOutlet weak var advanceSearchWindow: UIView!
    @IBOutlet weak var searchSegmentController: UISegmentedControl!
    @IBOutlet weak var advanceSearchTextfield: UITextField!
    @IBOutlet weak var searchPlaceTextField: UITextField!
    @IBOutlet weak var advancSubContentHolderView: UIView!
    
    //variables and constants
    var barFeatureArr = [String]()
    var bearArr = [String]()
    var isBarlistIsSelected = true
    var selectedBarListArr = [String]()
    var selectedFeaturArr = [String]()
    var IsSearchWithCurrentLocationEnable = false
    
    //location
    var placesClient: GMSPlacesClient!
    var selectedPlaceCordinate : CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var currentLocation : CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
       //for getting current place cordinated
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //customise navigation
        customizeNavigationbar(isBackBtnVisible: false, hideNavigationBar: false,isMapSwitchVisible: false, headingText: "Search")
        
        //Load webServices
        loadRequestFor(request: GET_BEARLIST_URL,parameter: [:], tag: 0)
        advancSubContentHolderView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
        
        self.searchTabView.transform = .identity
        self.normalSearchWindow.transform = .identity
        self.advanceSearchWindow.transform = .identity
        
        //configure segment
        self.searchSegmentController.layer.cornerRadius = searchSegmentController.frame.size.height/2
        self.searchSegmentController.layer.borderColor = UIColor.white.cgColor
        self.searchSegmentController.layer.borderWidth = 1.0
        self.searchSegmentController.layer.masksToBounds = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchTabView.transform = CGAffineTransform.init(translationX: 0, y: 90)
            
        }) { (completed) in
            self.searchSegmentController.selectedSegmentIndex = 0
            self.SearchOptionChanged(self.searchSegmentController)
        }
    }
    
}

//Handle Outlet Actions
extension SearchViewController
{
    @IBAction func SearchOptionChanged(_ sender: UISegmentedControl)
    {
        IsSearchWithCurrentLocationEnable = false
        selectedBarListArr.removeAll()
        selectedFeaturArr.removeAll()
        beerListButton.setTitle("Select Beer List", for: .normal)
        pubFeatureButton.setTitle("Select Feature", for: .normal)
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
                    self.advanceSearchWindow.transform = CGAffineTransform(translationX: 0, y: 510)
                })
            }
        }
    }
    
    @IBAction func searchOnMapPressed(_ sender: UIButton)
    {
        if searchPlaceTextField.text == "" && !IsSearchWithCurrentLocationEnable
        {
            showAlertFor(title: SEARCHVC_TITLE, description:searchSegmentController.selectedSegmentIndex==0 ? SELECT_PUB_NORMAL_ALERT : SELCET_PUB_ADVANCE_ALERT)
        }
        else if searchSegmentController.selectedSegmentIndex == 1 && pubFeatureButton.titleLabel?.text == "Select Feature from Pub" && beerListButton.titleLabel?.text == "Select Beer List"
        {
            showAlertFor(title: SEARCHVC_TITLE, description:SELECT_FEATURE_OR_BEER_ALERT)
        }
        else
        {
            UserDefaults.standard.set(false, forKey: "mapFromMenu")
            UserDefaults.standard.synchronize()
            //normal Search
            var requestParameter = [String:Any]()
            if let cordinates = selectedPlaceCordinate
            {
                if searchSegmentController.selectedSegmentIndex == 0
                {
                    requestParameter = [
                        "lat":cordinates.latitude,
                        "lng": cordinates.longitude
                    ]
                }
                else
                {
                    //advance search
                    requestParameter=["lat":cordinates.latitude,"lng":cordinates.longitude,"LstBeer":selectedBarListArr]
                    for feature in selectedFeaturArr
                    {
                        requestParameter[feature] = "1"
                    }
                }
                
                //request
                loadRequestFor(request: SEARCH_PUB_URL,parameter:requestParameter, tag: 2)
            }
        }
    }
    @IBAction func SelectBeerListPressed(_ sender: UIButton)
    {
        isBarlistIsSelected = true
        self.showOptionViewFor(title: "Select Beer list", dataSource:bearArr,previousSelectedItem:selectedBarListArr).selectedOptiondelegate=self
    }
    @IBAction func PubFeaturePressed(_ sender: UIButton)
    {
        isBarlistIsSelected = false
        self.showOptionViewFor(title: "Select Feature list", dataSource:barFeatureArr,previousSelectedItem:selectedFeaturArr).selectedOptiondelegate=self
    }
    @IBAction func searchWithCurrentLocationPressed(_ sender: UIButton)
    {
        selectedPlaceCordinate = currentLocation
        advanceSearchTextfield.text = ""
        IsSearchWithCurrentLocationEnable = true
    }
}

//Handle WebServices
extension SearchViewController
{
    func loadRequestFor(request:String,parameter:[String:Any],tag:Int)
    {
       
        if tag == 0
        {
            SearchRequestHander.getBearList(request: request) { (response) in
                switch response
                {
                case .success(let beerList):
                    print(beerList.pubListData)
                     self.bearArr = beerList.pubListData.map{$0.name}
                    self.loadRequestFor(request: GET_PUB_FEATURES_URL,parameter:[:], tag: 1)
                    
                case .failure(let error):
                    switch error {
                    case .unknownError( _,_) :
                        self.showAlertFor(title: "Search Alert", description: NO_DATA_ERROR)
                    default:
                        self.showAlertFor(title: "Search Alert", description: UnknownError)
                    }
                }
            }
        }
        if tag == 1
        {
            SearchRequestHander.getPubFeatureFor(request: request) { (response) in
                switch response
                {
                case .success(let featureList):
                    print(featureList)
                    self.barFeatureArr = featureList.features.map{$0.name}.sorted()
                
                    
                case .failure(let error):
                    switch error {
                    case .unknownError( _,_) :
                        self.showAlertFor(title: "Search Alert", description: NO_DATA_ERROR)
                    default:
                        self.showAlertFor(title: "Search Alert", description: UnknownError)
                    }
                }
            }
        }
        if tag == 2
        {
             showLoaderFor(title: "Please wait ...")
            SearchRequestHander.getPostResponseFor(request: request, withParameter: parameter) { (response) in
                switch response
                {
                case .success(let publist):
                   // print(publist)
                   
                    let latitudeArr = publist.pubDetails.map{$0.lat}
                    if latitudeArr.count>0
                    {
                        let maptVc = self.loadViewController(identifier: "MapViewController") as! MapViewController
                        maptVc.pubDetails = publist.pubDetails
                        maptVc.selectedLocation = self.selectedPlaceCordinate
                        self.navigationController?.pushViewController(maptVc, animated: true)
                    }
                    else
                    {
                        self.showAlertFor(title: "Near Pubs", description: NO_NEER_PUB_ALERT)
                    }
                    
                    
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
    }
}

// open search controller
extension SearchViewController:UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchPlaceTextField.endEditing(true)
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        return false
    }
}

//Google Autocompletion handler
extension SearchViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        searchPlaceTextField.text = place.name
        advanceSearchTextfield.text = place.name
        selectedPlaceCordinate = place.coordinate
  
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

//Handle Selected Beers and Features
extension SearchViewController:selectionOptionProtocol
{
    func selectedItems(items: [String])
    {
        let selectedTitle = items.joined(separator: ",")
        if isBarlistIsSelected
        {
            selectedBarListArr.removeAll()
            selectedBarListArr = items
            beerListButton.setTitle(selectedBarListArr.count>0 ? selectedTitle : "Select Beer List", for: .normal)
        }
        else
        {
            selectedFeaturArr.removeAll()
            selectedFeaturArr = items
            pubFeatureButton.setTitle(selectedFeaturArr.count>0 ? selectedTitle : "Select Feature", for: .normal)
        }
        print(items)
    }
}

//Fetch Current Location
extension SearchViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locationManager.location?.coordinate
        locationManager.stopUpdatingLocation()
    }
}


