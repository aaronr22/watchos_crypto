//
//  ConfigurationModel.swift
//  watch_custom
//
//  Created by Aaron Rotem on 11/28/17.
//  Copyright © 2017 Aaron Rotem. All rights reserved.
//

import Foundation

class ConfigurationModel : NSObject {
    public static let storageKey = "group.com.arotem.watch-custom"
    public let userStorage = UserDefaults(suiteName: storageKey)
    
    public var savedCoins: [String] = ["Test array"]
}
