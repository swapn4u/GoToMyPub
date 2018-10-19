//
//  PMSTransactionServiceManager.swift
//  MOAMC
//
//  Created by Swapnil Katkar on 09/04/18.
//  Copyright © 2018 Anurag Kulkarni. All rights reserved.
//

import UIKit

import Foundation
class SearchRequestHander: NSObject {
    
    class func getBearList(request:String,completed:@escaping((Result<BeerMapper, ServerError>) -> Void))
    {
        ServerManager.getRequestfor(urlString: request){ (result) in
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
                    let BeerMapperResult  = BeerMapper(dict: responseDict)
                    completed(.success(BeerMapperResult))
               
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
    
    class func getPubFeatureFor(request:String,completed:@escaping((Result<PubFeatures, ServerError>) -> Void))
    {
        ServerManager.getRequestfor(urlString: request){ (result) in
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
                        let pubFeatureMapperResult = PubFeatures(dict: responseDict)
                        completed(.success(pubFeatureMapperResult))
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
    
    class func getPostResponseFor(request:String,withParameter:[String:Any], completed:@escaping((Result<PubList, ServerError>) -> Void))
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
                    let PubListResponse = PubList(dict: responseDict)
                    completed(.success(PubListResponse))
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
    
    class func getPostResponseForIdDetails(request:String,withParameter:[String:Any], completed:@escaping((Result<SelectedPubDetails, ServerError>) -> Void))
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
                    let PubListResponse = SelectedPubDetails(dict: responseDict)
                    completed(.success(PubListResponse))
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
