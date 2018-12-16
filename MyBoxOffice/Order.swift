//
//  Order.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 16..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import Foundation

// This class is used to synchronize the sorting of table views and collection views.
class OrderType {
    
    // orderType - 0: reservtion rate, 1: curation, 2: release date
    private static var orderType: Int = 0
    
    class func getOrderType() -> Int {
        return self.orderType
    }
    
    class func setOrderType(_ orderType: Int) {
        if orderType < 0 || orderType > 3 { return }
        self.orderType = orderType
    }
}
