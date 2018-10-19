//
//  PMSTransactionMapper.swift
//  MOAMC
//
//  Created by Swapnil Katkar on 10/04/18.
//  Copyright © 2018 Anurag Kulkarni. All rights reserved.
//

import Foundation

struct SearchMapper{
    var success : Bool
    var message : String
    var searchData : [SearData]
    init(dict:[String:Any])
    {
        self.success = dict["IsStatus"] as? Bool ?? false
        self.message = dict["StatusMessage"] as? String ?? ""
        let dataListArr = dict["Data"] as? [[String:Any]] ?? [[String:Any]]()
        self.searchData = dataListArr.map{SearData(dict: $0)}
    }
}

struct SearData
{
    var UserId : String
    var active : Int
    var address1 : String
    
    init(dict:[String:Any]) {
        self.UserId = dict["UserId"] as? String ?? ""
        self.active = dict["active"] as? Int ?? 0
        self.address1 = dict["address1"] as? String ?? ""
    }
}
//GET PUBLIST
struct BeerMapper{
    var success : Bool
    var message : String
    var pubListData : [BeerDetails]
    init(dict:[String:Any])
    {
        self.success = dict["IsStatus"] as? Bool ?? false
        self.message = dict["StatusMessage"] as? String ?? ""
        let dataListArr = dict["Data"] as? [[String:Any]] ?? [[String:Any]]()
        self.pubListData = dataListArr.map{BeerDetails(dict: $0)}
    }
}

struct BeerDetails
{
    var item_id : Int
    var url : String
    var name : String
    init(dict:[String:Any]) {
        self.item_id = dict["item_id"] as? Int ?? 0
        self.url = dict["url"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
    }
}
//GET PUB FEATURE
struct PubFeatures
{
    var success : Bool
    var message : String
    var features : [Feature]
    init(dict:[String:Any])
    {
        self.success = dict["IsStatus"] as? Bool ?? false
        self.message = dict["StatusMessage"] as? String ?? ""
        let dataListArr = dict["Data"] as? [[String:Any]] ?? [[String:Any]]()
        self.features = dataListArr.map{Feature(dict: $0)}
    }
}
struct Feature
{
     var id : Int
    var name : String
    init(dict:[String:Any]) {
        self.id = dict["ID"] as? Int ?? 0
        self.name = dict["Name"] as? String ?? ""
    }
}

struct PubList
{
    var IsStatus : Bool
    var StatusMessage : String
    var pubDetails : [PubDetail]
    init(dict:[String:Any]) {
        self.IsStatus = dict["IsStatus"] as? Bool ?? false
        self.StatusMessage = dict["StatusMessage"] as? String ?? ""
        let pubListArr = dict["Data"] as? [[String:Any]] ?? [[String:Any]]()
        self.pubDetails = pubListArr.flatMap{PubDetail(dict: $0)}
    }
}
struct SelectedPubDetails
{
    
    var IsStatus : Bool
    var StatusMessage : String
    var pubDetails : [PubDetail]
    init(dict:[String:Any]) {
        self.IsStatus = dict["IsStatus"] as? Bool ?? false
        self.StatusMessage = dict["StatusMessage"] as? String ?? ""
        let pubList = dict["Data"] as? [String:Any] ?? [String:Any]()
        let pubDataArr : [[String:Any]] = [pubList]
        self.pubDetails = pubDataArr.flatMap{PubDetail(dict: $0)}
    }
}
struct PubDetail
{
   var id : Int
   var active : Bool
   var name : String
   var postcode : String
    var lat : Double
    var lng : Double
    var geoLoc : String
    var summary : String
    var telephone1 : String
    var email1 : String
    var type : String
    var address1 : String
    var address2 : String
    var address3 : String
    var city : String
    var county : String
    var website : String
    var brewery : String
    var UserId : String
    var soc_face : String
    var soc_twitter : String
    var soc_insta : String
    var localAuth : String
    var ales : String
    var distance : String
    var searchstring : String
    var ales_ids : String
    var OpenTime_0 : String
    var ClosedTime_0 : String
    var OpenTime_1 : String
    var ClosedTime_1 : String
    var OpenTime_2 : String
    var ClosedTime_2 : String
    var OpenTime_3 : String
    var ClosedTime_3 : String
    var OpenTime_4 : String
    var ClosedTime_4 : String
    var OpenTime_5 : String
    var ClosedTime_5 : String
    var OpenTime_6 : String
    var ClosedTime_6 : String
    var skytv : String
    var children : String
    var garden : String
    var fireplace : String
    var music : String
    var quiet : String
    var darts : String
    var food : String
    var fruitmachine : String
    var accommodation : String
    var dogs : String
    var parking : String
    var function : String
    var quiz : String
    var btsport : String
    var dj : String
    var wifi : String
    var LstBeer : String
    var LstFeatures : String
    init(dict:[String:Any]) {
        self.id = dict["id"] as? Int ?? -1
        self.active = dict["active"] as? Bool ?? false
        self.name = dict["name"] as? String ?? ""
        self.postcode = dict["postcode"] as? String ?? ""
        self.lat = dict["lat"] as? Double ?? 0.0
        self.lng = dict["lng"] as? Double ?? 0.0
        self.geoLoc = dict["geoLoc"] as? String ?? ""
        self.summary = dict["summary"] as? String ?? ""
        self.telephone1 = dict["telephone1"] as? String ?? ""
        self.email1 = dict["email1"] as? String ?? ""
        self.type = dict["type"] as? String ?? ""
        self.address1 = dict["address1"] as? String ?? ""
        self.address2 = dict["address2"] as? String ?? ""
        self.address3 = dict["address3"] as? String ?? ""
        self.city = dict["city"] as? String ?? ""
        self.county = dict["county"] as? String ?? ""
        self.website = dict["website"] as? String ?? ""
        self.brewery = dict["brewery"] as? String ?? ""
        self.UserId = dict["UserId"] as? String ?? ""
        self.soc_face = dict["soc_face"] as? String ?? ""
        self.soc_twitter = dict["soc_twitter"] as? String ?? ""
        self.soc_insta = dict["soc_insta"] as? String ?? ""
        self.localAuth = dict["localAuth"] as? String ?? ""
        self.ales = dict["ales"] as? String ?? ""
        self.distance = dict["distance"] as? String ?? ""
        self.searchstring = dict["searchstring"] as? String ?? ""
        self.ales_ids = dict["ales_ids"] as? String ?? ""
        self.OpenTime_0 = dict["OpenTime_0"] as? String ?? ""
        self.ClosedTime_0 = dict["ClosedTime_0"] as? String ?? ""
        self.OpenTime_1 = dict["OpenTime_1"] as? String ?? ""
        self.ClosedTime_1 = dict["ClosedTime_1"] as? String ?? ""
         self.OpenTime_2 = dict["OpenTime_2"] as? String ?? ""
         self.ClosedTime_2 = dict["ClosedTime_2"] as? String ?? ""
        self.OpenTime_3 = dict["OpenTime_3"] as? String ?? ""
         self.ClosedTime_3 = dict["ClosedTime_3"] as? String ?? ""
         self.OpenTime_4 = dict["OpenTime_4"] as? String ?? ""
         self.ClosedTime_4 = dict["ClosedTime_4"] as? String ?? ""
         self.OpenTime_5 = dict["OpenTime_5"] as? String ?? ""
        self.ClosedTime_5 = dict["ClosedTime_5"] as? String ?? ""
         self.OpenTime_6 = dict["OpenTime_6"] as? String ?? ""
         self.ClosedTime_6 = dict["ClosedTime_6"] as? String ?? ""
         self.skytv = dict["skytv"] as? String ?? ""
        self.children = dict["children"] as? String ?? ""
        self.garden = dict["garden"] as? String ?? ""
        self.fireplace = dict["fireplace"] as? String ?? ""
        self.music = dict["music"] as? String ?? ""
        self.quiet = dict["quiet"] as? String ?? ""
        self.darts = dict["darts"] as? String ?? ""
        self.food = dict["food"] as? String ?? ""
        self.fruitmachine = dict["fruitmachine"] as? String ?? ""
        self.accommodation = dict["accommodation"] as? String ?? ""
        self.dogs = dict["dogs"] as? String ?? ""
        self.parking = dict["parking"] as? String ?? ""
        self.function = dict["function"] as? String ?? ""
        self.quiz = dict["quiz"] as? String ?? ""
        self.btsport = dict["btsport"] as? String ?? ""
        self.dj = dict["dj"] as? String ?? ""
        self.wifi = dict["wifi"] as? String ?? ""
        self.LstBeer = dict["LstBeer"] as? String ?? ""
        self.LstFeatures = dict["LstFeatures"] as? String ?? ""
    }
}
