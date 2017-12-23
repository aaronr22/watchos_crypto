//THIS FILE IS THE FILE FOR THE FUNCTIONALITY OF THE VIEW ON THE RIGHT IN MAIN.STORYBOARD
//  ViewController.swift
//  watch_custom
//
//  Created by Aaron Rotem on 11/25/17.
//  Copyright © 2017 Aaron Rotem. All rights reserved.
//TODO: 1. Display every token and price in a table
//      2. Swipe right on a row to add that token to favorites
//      3. Allow them to view favorites in the app easily

//this file works to pull the persistent data from defaults and then sends that to the watch

import UIKit
import Alamofire
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activate")
    }
    
    @IBOutlet weak var phoneTable: UITableView!
    @IBOutlet weak var sentLbl: UILabel!
    //action for sending the favorites to the watch for it to display
    @IBAction func sendDataBtn(_ sender: Any) {
        
        
        if sessionReachabilityDidChange(session) {
                    //gets all persistant data from UserDefaults
                    let myDefaults = UserDefaults(suiteName:
                        "group.com.arotem.watch-custom")
            
                    //gets the 'coins' key from the defaults
                    guard let x = myDefaults?.array(forKey: "coins") else {
                        print("error")
                        return
                    }
            print(x)
            do {
            
            print("sending")
                //send the favorites to the watch
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

    override func viewDidLoad() {
        super.viewDidLoad()
        //communication between watch and iOS app
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        //persistent data
        let myDefaults = UserDefaults(suiteName:
            "group.com.arotem.watch-custom")
        
        //setting the persistant data
        
        //TODO: have the user set these from within the iOS app(one of the later steps)
        //t is the sample set of user fav because its not implemented
        let t = ["NEO", "BTC", "ETH", "XRP", "POWR"]
        //set the userdefaults
        myDefaults?.set(t, forKey:"coins")
        guard let x = myDefaults?.array(forKey: "coins") else {
            print("error")
            return
        }
        print(x)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

