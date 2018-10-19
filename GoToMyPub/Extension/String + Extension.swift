//
//  String + Extension.swift
//  GoToMyPub
//
//  Created by Swapnil Katkar on 18/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

 public extension String {
        public func toFloat() -> Float? {
            return Float.init(self)
        }
        
        public func toDouble() -> Double? {
            return Double.init(self) ?? 0.0
        }
    }
extension String
{
    public func km() -> Float?
    {
        return (self.toFloat() ?? 0.0) / 1000.00
    }
}
