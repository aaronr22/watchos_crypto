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


    
    /*
        Runs when user data is received from iphone
    */
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(" received")
        if let tmp = applicationContext["key"] as? [String]{
            print(tmp)
            
            self.localDefault = tmp
            let myDefaults = UserDefaults(suiteName:
                "group.com.arotem.watch-custom")
            myDefaults?.set(self.localDefault, forKey:"coins")
            print(self.localDefault)
            getAllData()
        } else {
            print("no application context for key")
        }
    }
    
    /*
        Converts the received userDefault from iPhone into an array with each index being a token
        Run in the didReceiveAppContext class
    */
    func convertToArray(s:[String]) -> [String]{
        var arr = [String]()
        var str = ""
        for char in s[0]{
            if char == "," {
                arr.append(str)
                str = ""
            }else if char != " " {
                str += String(char)
            }

        }
        arr.append(str)
        return arr
        
    }
    
    func getData(str : Any){
        dataArray = str
        print(dataArray)
    }
    
    var dataArray: Any = ""
    var session: WCSession!
    @IBOutlet var tableOutlet: WKInterfaceTable!
    
    //array for crypto token-price tuples
    var cryptoPrices = [(String, String)]()
    //symbols for the coins to display: TODO: user data, pull this from else where in the app file structure
    var symbols = ["ETH", "BTC", "NEO", "POWR", "LTC"]
    var localDefault = [String]()
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        //defaults stuff
        let myDefaults = UserDefaults(suiteName:
            "group.com.arotem.watch-custom")
        guard let x = myDefaults?.array(forKey: "coins") else {
            print("error")
            return
        }
        self.localDefault = x as! [String]
        print(self.localDefault)
        
        
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
        getAllData()
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
                for s in self.localDefault {
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
    }
    
    
    
}
