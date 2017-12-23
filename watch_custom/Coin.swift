//
//  Coin.swift
//  watch_custom
//
//  Created by Aaron Rotem on 12/21/17.
//  Copyright © 2017 Aaron Rotem. All rights reserved.
//

import UIKit
class Coin {
    //MARK: properties
    var symbol: String
    var price: String
    
    //MARK: initialization
    init?(symbol: String, price: String){
        if symbol.isEmpty || price.isEmpty {
            return nil
        }
        self.symbol = symbol
        self.price = price
    }
}
