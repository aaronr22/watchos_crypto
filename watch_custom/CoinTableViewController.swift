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
    var onFave = false
    @IBAction func favoritesButton(_ sender: Any) {
        //TODO: implement
        if onFave == false {
            loadFavoriteCoins()
        } else {
            loadCoins()
        }
        //loadFavorites
        print("pressed button")
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
        updates coins -> filter coins array with just the desired values
     
    */
    private func loadFavoriteCoins(){
        //TODO: implement
        self.onFave = true
        //take code from viewcontroller for user defaults
        
        //filter coins to just have the desired coins
        
        //refresh the table
        tableview.reloadData()
    }
    
    
    /*
        Pulls the actual coin data from coinmarketcap.com
        then parses each coin into Coin
        the problem is the rest reqest is recieved after the table loaded its data.  tutorial im working on should solve that
     */
    private func loadCoins(){
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
                    print(c.symbol)
                    self.coins += [c]
                }
            }
            print("reloading table")
            self.tableview.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadSampleCoins()
        print("laoding coins")
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

    

}
