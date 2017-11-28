//
//  InterfaceController.swift
//  watch_custom WatchKit Extension
//
//  Created by Aaron Rotem on 11/25/17.
//  Copyright © 2017 Aaron Rotem. All rights reserved.
//TODO: 1. add UI for iPhone to edit the symbols array -- *how to store user app preferences/data locally
//      2. add Complications
//      3. add loading graphic until the first row appears


import WatchKit
import Foundation
import Alamofire
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session activated")
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print(" received")
        if let tmp = applicationContext["key"] {
            print(tmp)
        } else {
            print("no application context for key")
        }

    }
        
        
    var session: WCSession!
    @IBOutlet var tableOutlet: WKInterfaceTable!
    
    //array for crypto token-price tuples
    var cryptoPrices = [(String, String)]()
    //symbols for the coins to display: TODO: user data, pull this from else where in the app file structure
    var symbols = ["ETH", "BTC", "NEO", "POWR", "LTC"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        //defaults stuff
        let myDefaults = UserDefaults(suiteName:
            "group.com.arotem.watch-custom")
        guard let x = myDefaults?.object(forKey: "coins") else {
            print("error")
            return
        }
        print(x)
    }
    
    
    /*
     Fills the labels with the data from cryptoPrices
     */
    func loadTableCrypto() {
        //Sets the number of rows to the length of the array
        tableOutlet.setNumberOfRows(cryptoPrices.count, withRowType: "row")
        
        for i in 0..<cryptoPrices.count {
            let row = tableOutlet.rowController(at:i) as? rowController
            let labelValue = cryptoPrices[i].1
            let labelSymbol = cryptoPrices[i].0
            row?.rowSymbol.setText(labelSymbol)
            row?.rowLabel.setText(labelValue)
        }
    }
    
    /* **DEPRECATED**
     Wrapper function to get prices of coins
     */
    func getPrices() {
        cryptoPrices.removeAll()
        getJSON(tick: "ethereum")
        getJSON(tick: "neo")
        getJSON(tick: "bitcoin")
        getJSON(tick: "litecoin")
        getJSON(tick: "power-ledger")
    }
    
    /*
     Gets run every time 
     */
    override func willActivate() {
        if(WCSession.isSupported()){
            self.session = WCSession.default;
            self.session.delegate = self;
            self.session.activate();
        }
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    /* **DEPRECATED**
     Gets the price and ticker for a specific token
     uses getUsd to update the array
     
     */
    func getJSON(tick: String) {
        self.cryptoPrices.removeAll()
        let url = "https://api.coinmarketcap.com/v1/ticker/" + tick
        print(url)
        Alamofire.request(url, encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let result = response.result.value as? [[String: Any]],
                    let string = result.first?["price_usd"] as? String,
                    let usd = Double(string) else {
                        print("not found")
                        return
                }
                guard let r = response.result.value as? [[String: Any]],
                    let s = r.first?["symbol"] as? String else {
                        print("Error")
                        return
                }
                print(s)
                self.getUsd(temp: String(describing: usd), sym: s)
        }
    }
    
    /*
     New getJson:  gets the entire json from https://api.coinmarketcap.com/v1/ticker/
     */
    func getAllData(){
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/", encoding: JSONEncoding.default).responseJSON {
            response in if let object = response.result.value as? [Dictionary<String,AnyObject>] {
                
                //solves the problem of multiple requests adding to the array
                self.cryptoPrices.removeAll()
                for s in self.symbols {
                let filteredArray = object.filter{$0["symbol"]! as! String == s}
                    guard let t = filteredArray.first?["price_usd"] else {
                        print("Not found")
                        return
                    }
                    self.getUsd(temp: t as! String, sym: s)
                }
                self.loadTableCrypto()
            }
        }
        
    }
    
    
    /*
     Adds the token key value to cryptoPrices
     */
    func getUsd(temp: String, sym: String) {
        cryptoPrices.append((sym, temp))
        for element in cryptoPrices {
            print(element)
        }
    }
    
    
    
}
