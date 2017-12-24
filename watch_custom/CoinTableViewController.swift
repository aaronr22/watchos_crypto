//
//  CoinTableViewController.swift
//  watch_custom
//
//  Created by Aaron Rotem on 12/21/17.
//  Copyright © 2017 Aaron Rotem. All rights reserved.
//

import UIKit
import Alamofire
class CoinTableViewController: UITableViewController {
    //MARK: properties
    var coins = [Coin]()
    var coinStore = [Coin]()
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
        guard let coin1 = Coin(symbol: "XRP", price: "93") else {
            fatalError("Unable to laod coin1")
        }
        guard let coin2 = Coin(symbol: "BTC", price: "16000") else {
            fatalError("Unable to laod coin1")
        }
        guard let coin3 = Coin(symbol: "LTC", price: "308") else {
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
                    //print("\(x) price: \(y)")
                    
                    //creates the new coin
                    guard let c = Coin(symbol: x, price: y) else {
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
        cell.priceLabel.text = coin.price
        
        return cell
    }

    //swipe feature
    
    

}
