//
//  InterfaceController.swift
//  watch_custom WatchKit Extension
//
//  Created by Aaron Rotem on 11/25/17.
//  Copyright © 2017 Aaron Rotem. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire

class InterfaceController: WKInterfaceController {

    @IBOutlet var label1: WKInterfaceLabel!
    @IBAction func button1() {
        
        //getJSON(tick: "ethereum")
        getJSON(tick: "neo")
       // label1.setText("Fuck you")
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getJSON(tick: String) {
        let url = "https://api.coinmarketcap.com/v1/ticker/" + tick
        Alamofire.request(url, encoding: JSONEncoding.default)
            .responseJSON { response in
                //to get JSON return value
                if let result = response.result.value {
                     let JSON = result as! [[String:Any]]
                    print(JSON[0]["price_usd"])
                    let price = JSON[0]["price_usd"]
                    self.label1.setText(String(describing: price))
                }
        }
        }
    }
