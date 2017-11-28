//
//  Coin.swift
//  watch_custom
//
//  Created by Aaron Rotem on 11/28/17.
//  Copyright © 2017 Aaron Rotem. All rights reserved.
//

import Foundation
import UIKit
class Coin {
    var symbol: String
    
    init?(sym: String){
        guard !sym.isEmpty else {
            return nil
        }
        self.symbol = sym
    }
}
