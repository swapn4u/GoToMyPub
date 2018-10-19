//
//  PMSTransactionServiceManager.swift
//  MOAMC
//
//  Created by Swapnil Katkar on 09/04/18.
//  Copyright © 2018 Anurag Kulkarni. All rights reserved.
//

import UIKit

import Foundation
class MapViewRequestHander: NSObject {
  
    class func getPostResponseFor(request:String,withParameter:[String:Any], completed:@escaping((Result<MapDataMapper, ServerError>) -> Void))
    {
        ServerManager.postRequestfor(urlString: request, parameter: withParameter){ (result) in
            switch result
            {
            case .success(let response):
                
                guard let responseDict = response.dictionaryObject else {
                    completed(.failure(.unknownError(message: NO_DATA_ERROR, statusCode: 000)))
                    return
                }
                guard let success = responseDict["IsStatus"] as? Bool else {
                    completed(.failure(.unknownError(message: UnknownError, statusCode: 000)))
                    return
                }
                if success
                {
                    let MapDataMapperResponse = MapDataMapper(dict: responseDict)
                    completed(.success(MapDataMapperResponse))
                }
                else
                {
                    completed(.failure(.unknownError(message: NO_DATA_ERROR, statusCode: 000)))
                }
                break
            case .failure(let error):
                completed(.failure(error))
                break
            }
        }
    }
}
