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
    
    //MARK: private methods
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
    
    //load the real coins and add them to the coins array
    //then change viewDidLoad to call this coins instead
    private func loadCoins(){
        
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/", encoding: JSONEncoding.default).responseJSON {
            response in if let object = response.result.value as? [Dictionary<String,AnyObject>] {
                for coin in object{
                    guard let x = coin["symbol"] as? String else {
                        fatalError("no symbol")
                    }
                    guard let y = coin["price_usd"] as? String else {
                        fatalError("no price")
                    }
                    //print("\(x) price: \(y)")
                    //instead of printing, create a new coin and then add it to the array
                    guard let c = Coin(symbol: x, price: y) else {
                        fatalError("Could not convert token to coin")
                    }
                    self.coins += [c]
                }
                print("ah")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleCoins()

        //loadCoins()

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
