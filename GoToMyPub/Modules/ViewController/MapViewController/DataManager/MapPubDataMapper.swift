//
//  PMSTransactionMapper.swift
//  MOAMC
//
//  Created by Swapnil Katkar on 10/04/18.
//  Copyright © 2018 Anurag Kulkarni. All rights reserved.
//

import Foundation

struct MapDataMapper{
    var success : Bool
    var message : String
    var mapData : [MapResult]
    init(dict:[String:Any])
    {
        self.success = dict["IsStatus"] as? Bool ?? false
        self.message = dict["StatusMessage"] as? String ?? ""
        let mapDataListArr = dict["Data"] as? [[String:Any]] ?? [[String:Any]]()
        self.mapData = mapDataListArr.map{MapResult(dict: $0)}
    }
}

struct MapResult
{
    var UserId : String
   var active : Int
   var address1 : String
   var address2 : String
   var address3 : String
   var ales : String
   var brewery : String
   var city : String
   var county : String
   var distance : String
   var email1 : String
   var geoLoc : String
   var id : Int
   var lat : Double
   var lng : Double
   var localAuth : String
   var name : String
   var postcode : String
   var searchstring : String
   var soc_face : String
   var soc_insta : String
   var soc_twitter : String
   var summary : String
   var telephone1 : String
  var type : String
   var website : String
    init(dict:[String:Any]) {
        self.UserId = dict["UserId"] as? String ?? ""
        self.active = dict["active"] as? Int ?? 0
        self.address1 = dict["address1"] as? String ?? ""
        self.address2 = dict["address2"] as? String ?? ""
        self.address3 = dict["address3"] as? String ?? ""
        self.ales = dict["ales"] as? String ?? ""
        self.brewery = dict["brewery"] as? String ?? ""
        self.city = dict["city"] as? String ?? ""
        self.county = dict["county"] as? String ?? ""
        self.distance = dict["distance"] as? String ?? ""
        self.email1 = dict["email1"] as? String ?? ""
        self.geoLoc = dict["geoLoc"] as? String ?? ""
        self.id = dict["id"] as? Int ?? 0
        self.lat = dict["lat"] as? Double ?? 0.00
        self.lng = dict["lng"] as? Double ?? 0.00
        self.localAuth = dict["localAuth"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.postcode = dict["postcode"] as? String ?? ""
        self.searchstring = dict["searchstring"] as? String ?? ""
        self.soc_face = dict["soc_face"] as? String ?? ""
        self.soc_insta = dict["soc_insta"] as? String ?? ""
        self.soc_twitter = dict["soc_twitter"] as? String ?? ""
        self.summary = dict["summary"] as? String ?? ""
        self.telephone1 = dict["telephone1"] as? String ?? ""
        self.type = dict["type"] as? String ?? ""
        self.website = dict["website"] as? String ?? ""
    }
}
