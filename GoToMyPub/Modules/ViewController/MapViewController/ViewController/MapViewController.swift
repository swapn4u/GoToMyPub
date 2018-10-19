//
//  MapViewController.swift
//  GMapsDemo
//
//  Created by Swapnil Katkar on 20/5/18.
//  Copyright (c) 2018 Appcoda. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
class MapViewController: UIViewController, GMSMapViewDelegate {
   //Outlet Collections
    @IBOutlet weak var viewMap: GMSMapView!

    //Variables and Constance
    var didFindMyLocation = false
    var pubDetails : [PubDetail]!
    var selectedLocation : CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var isBackButtonEnable = true
    var placesOnes = false

    //View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = pubDetails
        {
            isBackButtonEnable = true
           ConfigurePubData()
        }
        else
        {
            isBackButtonEnable = false
            //for getting current place cordinated
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //customise navigation bar
        UserDefaults.standard.set(0, forKey:"switch")
        UserDefaults.standard.synchronize()
        customizeNavigationbar(isBackBtnVisible: isBackButtonEnable ? true : false, hideNavigationBar: false,isMapSwitchVisible: true ,  headingText: "Pub near you")
    }
}

//Handle Other Thask
extension MapViewController
{
    //Show Pubs In Listed Form
    @objc func showPubListVC()
    {
        if pubDetails.count > 0
        {
            let pubListVC = self.loadViewController(identifier: "PubListViewController") as! PubListViewController
            pubListVC.pubList=pubDetails
            self.navigationController?.pushViewController(pubListVC, animated: true)
        }
        else
        {
            showAlertFor(title: "pub list", description: "no near pubs to preview")
        }
    }
    
    //Configure Pub data
    func ConfigurePubData()
    {
        self.viewMap.clear()
     
        //Show List of Pubs Near By Selected Locations
        for pubInfo in pubDetails
        {
            DispatchQueue.main.async {
                let camera = GMSCameraPosition.camera(withLatitude:CLLocationDegrees(pubInfo.lat), longitude: CLLocationDegrees(pubInfo.lng), zoom: 14.0)
                self.showMarker(position: camera.target, pubName: pubInfo.name, description: pubInfo.address1)
                self.viewMap.camera = camera
            }
        }
        //Show Selected Location On Map
        if !UserDefaults.standard.bool(forKey: "mapFromMenu")
        {
            DispatchQueue.main.async {
                let camera: GMSCameraPosition = GMSCameraPosition.camera(withTarget: self.selectedLocation!, zoom: 14.0)
                self.viewMap.camera = camera
                self.viewMap.delegate = self
                self.showMarker(position: camera.target, pubName: "", description: "")
            }
        }
    }
    
    //Plote pubs on map
    func showMarker(position: CLLocationCoordinate2D, pubName:String,description:String)
    {
        let marker = GMSMarker()
        marker.position = position
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = pubName=="" ? #imageLiteral(resourceName: "redPin"): #imageLiteral(resourceName: "markerImage")
        marker.iconView = imageView
        if pubName != ""
        {
            marker.title = pubName
            marker.snippet = description
        }
        marker.map = self.viewMap
    }
    
    //OPEN details of selected pub on map
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        let selectedMarkerIndex = pubDetails.map{$0.name}.index(of: marker.title)
        
        showLoaderFor(title: "Please wait ...")
        let parameter = ["id":pubDetails[selectedMarkerIndex!].id]
        SearchRequestHander.getPostResponseForIdDetails(request: GET_PUBDETAILS_BY_ID_URL, withParameter: parameter) { (response) in
            switch response
            {
            case .success(let publists):
                print(publists)
                let detailVC = self.loadViewController(identifier:"PubDetailViewController") as! PubDetailViewController
                detailVC.pubDetails = publists.pubDetails.last!
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
}
//Fetch Current Location
extension MapViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Show Selected Location On Map
        DispatchQueue.main.async {
            self.viewMap.clear()
            self.locationManager.stopUpdatingLocation()
            if UserDefaults.standard.bool(forKey: "mapFromMenu")
            {
                if !self.placesOnes
                {
                    let requestParameter = [
                        "lat":locations.last!.coordinate.latitude,
                        "lng": locations.last!.coordinate.longitude
                    ]
                    
                    self.loadRequestFor(request: SEARCH_PUB_URL,parameter:requestParameter, completed: {(completed) in
                        DispatchQueue.main.async {
                            let camera: GMSCameraPosition = GMSCameraPosition.camera(withTarget:(self.locationManager.location?.coordinate)!, zoom: 12)
                            self.viewMap.camera = camera
                            self.viewMap.delegate = self
                            self.showMarker(position: camera.target, pubName:"" , description: "")
                        }
                    })
                    self.placesOnes = !self.placesOnes
                }
            }
            else
            {
                let camera: GMSCameraPosition = GMSCameraPosition.camera(withTarget:(self.locationManager.location?.coordinate)!, zoom: 12)
                self.viewMap.camera = camera
                self.viewMap.delegate = self
                self.showMarker(position: camera.target, pubName:"" , description: "")
                
            }
            
        }
        
    }
}
extension MapViewController
{
    func loadRequestFor(request:String,parameter:[String:Any],completed:@escaping (Bool)-> Void)
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
                   self.pubDetails =  publist.pubDetails
                    self.ConfigurePubData()
                    self.dissmissLoader()
                    completed(true)
                }
                else
                {
                    self.dissmissLoader()
                    self.showAlertFor(title: "Near Pubs", description: NO_NEER_PUB_ALERT)
                    completed(true)
                }
                
                
            case .failure(let error):
                self.dissmissLoader()
                completed(true)
                switch error {
                case .unknownError( _,_) :
                    self.showAlertFor(title: "Search Alert", description: NO_DATA_ERROR)
                default:
                    self.showAlertFor(title: "Search Alert", description: UnknownError)
                }
            }
           
        }
    }
}
