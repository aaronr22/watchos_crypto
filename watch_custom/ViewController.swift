//
//  ViewController.swift
//  watch_custom
//
//  Created by Aaron Rotem on 11/25/17.
//  Copyright © 2017 Aaron Rotem. All rights reserved.
//TODO: 1. Display every token and price in a table
//      2. Swipe right on a row to add that token to favorites
//      3. Allow them to view favorites in the app easily 

import UIKit
import Alamofire
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activate")
    }
    
    @IBOutlet weak var sentLbl: UILabel!
    @IBAction func sendDataBtn(_ sender: Any) {
        if sessionReachabilityDidChange(session) {
                    let myDefaults = UserDefaults(suiteName:
                        "group.com.arotem.watch-custom")
                    guard let x = myDefaults?.array(forKey: "coins") else {
                        print("error")
                        return
                    }
            print(x)
            do {
            var t = ["BTC", "NEO"]
            print("sending")
            try 
                session.updateApplicationContext(["key": x])
            self.sentLbl.text="sent"
        } catch {
            print("Error sending to watch")
        }
        } else {
            print("watch not ready")
        }
    }

    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("active again")
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) -> Bool {
        print("Is Reachable: ", terminator: "")
        print(session.isReachable ? "Yes" : "No")
        return session.isReachable
    }
    
    var session: WCSession!
    var cryptoPrices = [(String, String)]()
    //symbols for the coins to display: TODO: user data, pull this from else where in the app file structure
    var symbols = ["ETH", "BTC", "NEO", "POWR", "LTC", "XRP"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //communication between watch and app
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        //persistent data
        let myDefaults = UserDefaults(suiteName:
            "group.com.arotem.watch-custom")
        
        //if
        let t = ["NEO", "BTC", "ETH", "XRP", "POWR"]
        myDefaults?.set(t, forKey:"coins")
        guard let x = myDefaults?.array(forKey: "coins") else {
            print("error")
            return
        }
        print(x)
        
        //getAllData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllData(){
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/", encoding: JSONEncoding.default).responseJSON {
            response in if let object = response.result.value as? [Dictionary<String,AnyObject>] {
                
                print(object)
                //solves the problem of multiple requests adding to the array
                //self.cryptoPrices.removeAll()
//                for s in self.symbols {
//                    let filteredArray = object.filter{$0["symbol"]! as! String == s}
//                    guard let t = filteredArray.first?["price_usd"] else {
//                        print("Not found")
//                        return
//                    }
//                    print(t)
//                    //self.getUsd(temp: t as! String, sym: s)
//                }
                //self.loadTableCrypto()
            }
        }
        
    }


}

