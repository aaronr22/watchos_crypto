//
//  CoinTableViewController.swift
//  watch_custom
//
//  Created by Aaron Rotem on 12/21/17.
//  Copyright © 2017 Aaron Rotem. All rights reserved.
//

import UIKit
import Alamofire
import WatchConnectivity

class CoinTableViewController: UITableViewController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("watch activated")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("active again")
    }
    
    //MARK: properties
    var coins = [Coin]()
    var coinStore = [Coin]()
    var session: WCSession!
    //controls the state of the favorites/all coins list
    var onFave = false
    @IBAction func favoritesButton(_ sender: UIButton) {
        //TODO: implement
        if onFave == false {
            loadFavoriteCoins()
            sender.setTitle("All Currencies", for: .normal)
        } else {
            loadCoinsTwo()
            sender.setTitle("My Favorites", for: .normal)
        }
    }
    @IBOutlet var tableview: UITableView!
    //MARK: private methods
    
        /*
            Loads sample coins to put into the table
        */
    private func loadSampleCoins(){
        guard let coin1 = Coin(symbol: "XRP", price: "93", change: "5") else {
            fatalError("Unable to laod coin1")
        }
        guard let coin2 = Coin(symbol: "BTC", price: "16000", change: "5") else {
            fatalError("Unable to laod coin1")
        }
        guard let coin3 = Coin(symbol: "LTC", price: "308", change: "5") else {
            fatalError("Unable to laod coin1")
        }
        coins += [coin1, coin2, coin3]
        
    }
    
    /*
        Loads the favorite coins from the userdefaults
    */
    private func loadFavoriteCoins(){
        //saves the coins as another array
        self.coinStore = self.coins
        print("loading favorite coins...")
        
        self.onFave = true
        //gets the user defalts
        let myDefaults = UserDefaults(suiteName:
            "group.com.arotem.watch-custom")
//        guard let test = myDefaults else {
//            print("could not get defualts")
//            return
//        }
//        print(test)
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
        
        
        //gets the 'coins' key from the defaults
        guard let x = myDefaults?.array(forKey: "coins") as? [String] else {
            print("error")
            return
        }
        
        //filters the coins down to favorite coins
        var tmpArray = [Coin]()
        tmpArray.removeAll()
        for c in x {
            for t in coins {
                if (t.symbol == c) {
                    tmpArray.append(t)
                }
            }
        }
        
        //sets the coins array to the new fave coins array
        self.coins = tmpArray
        //print("fave coins: \(self.coins)")
        //refresh the table
        tableview.reloadData()
    }
    
    /*
        resets the coins array to be all the coins not just favorites
    */
    private func loadCoinsTwo() {
        self.onFave = false
        self.coins = self.coinStore
        self.tableview.reloadData()
    }
    
    
    
    /*
        Loads the coins initially, but only once
        Pulls the actual coin data from coinmarketcap.com then adds it to the tableview
     */
    private func loadCoins(){
        print("loading coins...")
        if coins.count < coinStore.count{
            coins = coinStore
        }
        self.onFave = false
        
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/", encoding: JSONEncoding.default).responseJSON {
            response in if let object = response.result.value as? [Dictionary<String,AnyObject>] {
                for coin in object{
                    //need this guard syntax for optional variables, essentially variables that sometimes might not be there
                    guard let x = coin["symbol"] as? String else {
                        fatalError("no symbol")
                    }
                    guard let y = coin["price_usd"] as? String else {
                        fatalError("no price")
                    }
                    guard let z = coin["percent_change_24h"] as? String else {
                        fatalError("no daily change")
                    }
                    //print("\(x) price: \(y)")
                    
                    //creates the new coin
                    guard let c = Coin(symbol: x, price: y, change: z) else {
                        fatalError("Could not convert token to coin")
                    }
                    self.coins += [c]
                }
            }
            //print("all coins: \(self.coins)")
            self.tableview.reloadData()
        }
        
    }
    
    /*
        Runs when the app is loaded
        Loads all coins first
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        let myDefaults = UserDefaults(suiteName:
            "group.com.arotem.watch-custom")
        
        //guard statement not tested.  should only reset the defualts to base case array when it cannot pull
        guard let x = myDefaults?.array(forKey: "coins") as? [String] else {
        var tmp = ["ETH", "BTC", "LTC"]
        myDefaults?.set(tmp, forKey:"coins")
        return
        }
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        //loadSampleCoins()
        print("coins: \(coins)")
        loadCoins()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    //load the table with data.  im not sure how to call this from the end of loadCoins, that would probably solve the problem though.  tutorial will fix that though
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CoinTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CoinTableViewCell else {
            fatalError("The dequeed cell is not an instance of cointableviewcell")
        }
        let coin = coins[indexPath.row]
        cell.symbolLabel.text = coin.symbol
        cell.priceLabel.text = "$" + coin.price
        cell.changelLabel.text = coin.change + "%"
        //TODO: if the first character of the change var is negative, set color to red.  otherwise set it to green
        
        let index = coin.change.characters.index(coin.change.startIndex, offsetBy: 0)
        if coin.change[index] == "-" {
            cell.changelLabel.textColor = UIColor.red
        } else {
            cell.changelLabel.textColor = UIColor.green
        }
        return cell
    }

    //swipe feature
    //TODO: limit swipe to only swipe from left
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    //method that occurs when the swipe happens
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        if self.onFave == true {
            let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                print("deleting")
                
                print("Symbol to remove: \(self.coins[indexPath.row].symbol)")
                let myDefaults = UserDefaults(suiteName:
                    "group.com.arotem.watch-custom")
                
                //gets the 'coins' key from the defaults
                guard let x = myDefaults?.array(forKey: "coins") as? [String] else {
                    print("error")
                    return
                }
                
                //find index of self.coins[indexPath.row].symbol
                var index = x.index(of: self.coins[indexPath.row].symbol)
                //set x to a mutable array
                print("old defaults: \(x)")
                var tmp = x
                //remove index from two steps previous
                tmp.remove(at: index!)
                
                //set userdefaults to new array
                myDefaults?.set(tmp, forKey:"coins")
                guard let y = myDefaults?.array(forKey: "coins") else {
                    print("error")
                    return
                }
                print(x)
                print("new defaults: \(y)")
                //TODO: send to watch
                if self.sessionReachabilityDidChange(self.session) {
                    do {
                        try
                            self.session.updateApplicationContext(["key": y])
                        print("sent")
                    } catch {
                        print("error sending to watch")
                    }
                }else {
                    print("watch not ready")
                }
                self.coins.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                //remove from defaults then send defaults to watch
                
                completionHandler(true)
            }
                    return action
        } else {
            let action = UIContextualAction(style: .normal, title: "Add") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                print("adding to defaults")
                //remove next two lines, replace with adding to defaults code, then send to watch
                print("Symbol to add: \(self.coins[indexPath.row].symbol)")
                let myDefaults = UserDefaults(suiteName:
                    "group.com.arotem.watch-custom")
                
                //gets the 'coins' key from the defaults
                guard let x = myDefaults?.array(forKey: "coins") as? [String] else {
                    print("error")
                    return
                }
                if !x.contains(self.coins[indexPath.row].symbol) {
                print("Old defaults: \(x)")
                var t = x
                
                t.append(self.coins[indexPath.row].symbol)
                myDefaults?.set(t,  forKey: "coins")
                guard let y = myDefaults?.array(forKey: "coins") as? [String] else {
                    print("error")
                    return
                }
                print("New defaults: \(y)")
                    if self.sessionReachabilityDidChange(self.session) {
                        do {
                            try
                                self.session.updateApplicationContext(["key": y])
                            print("sent")
                        } catch {
                            print("error sending to watch")
                        }
                    }else {
                        print("watch not ready")
                    }
                } else {
                    print("already in defaults")
                }
                
                //TODO: send to watch
                
                completionHandler(true)
            }
            return action
        }
    }
    
    //MARK: functions to send data to watch
    private func sessionReachabilityDidChange(_ session: WCSession) -> Bool {
        print("Is reachable: ", terminator: "")
        print(session.isReachable ? "yes" : "no")
        return session.isReachable
    }
}
