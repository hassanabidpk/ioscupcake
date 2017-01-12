//
//  CupcakeTableViewController.swift
//  iOSCupcake
//
//  Created by Hassan Abid on 8/7/16.
//  Copyright © 2016 Hassan Abid. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import Kingfisher


class CupcakeTableViewController: UITableViewController {
    
    let realm = try! Realm()
    let results = try! Realm().objects(Cupcake.self).sorted(byProperty: "rating")
    var notificationToken: NotificationToken?
    
    let API_BASE_URL = "https://djangocupcakeshop.azurewebsites.net/api/v1/cupcakes"
    let WEBSITE_BASE_URL = "https://djangocupcakeshop.azurewebsites.net"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI();
        
        // Set results notification block
        self.notificationToken = results.addNotificationBlock { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                print("Results are now populated and can be accessed without blocking the UI")
                self.tableView.reloadData()
                print("results.count: \(self.results.count)")
                break
            case .update(_, let deletions, let insertions, let modifications):
                print(" Query results have changed, so apply them to the TableView")
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath (row: $0, section: 0) } , with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath (row: $0, section: 0)}, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath (row : $0, section: 0)}, with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }


    }
    
    //MARK:  UI
    func setupUI() {
        
        self.clearsSelectionOnViewWillAppear = false
    
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self, action: #selector(add))
        let downloadButton = UIBarButtonItem(image: UIImage(named: "download"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(update))
        self.navigationItem.rightBarButtonItems = [addButton,downloadButton]
        if(results.count == 0) {
            getCupcakesviaApi()
        }
    }
    
    //MARK: API
    func getCupcakesviaApi() {
    
        let params: Parameters = ["format": "json"]
        Alamofire.request(API_BASE_URL, parameters: params)
            .responseJSON { response in
                
                switch response.result {
                
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json.count)")
                        self.backgroundAdd(json)
                        
                    }
                case .failure(let error):
                    print(error)
                }
                
        }
    }
    
    //MARK: TODO:
    
    func add() {
        /*
         realm.beginWrite()
         realm.create(DemoObject.self, value: [TableViewController.randomString(), TableViewController.randomDate()])
        try! realm.commitWrite()
    
         */

    }
    
    func update() {
        print("update")
        getCupcakesviaApi()
    }
    
    func backgroundAdd(_ data : JSON!) {
        
        deleteCupcakes()
        
        let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
        // Import many items in a background thread
        queue.async {
            // Get new realm and table since we are in a new thread
            let realm = try! Realm()
            realm.beginWrite()
            for (_,subJson):(String, JSON) in data {
                // Add row via dictionary. Order is ignored.
                realm.create(Cupcake.self, value: ["name": subJson["name"].stringValue, "price": subJson["price"].stringValue, "rating": subJson["rating"].floatValue, "writer": subJson["writer"].stringValue,"image": subJson["image"].stringValue,"createdAt": subJson["createdAt"].stringValue])
            }

            try! realm.commitWrite()
        }
    }

    func deleteCupcakes() {
    
        try! realm.write {
            realm.deleteAll()
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CupcakeTableViewCell"

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CupcakeTableViewCell
        
        let object = results[indexPath.row]
        cell.cupcakeName?.text = object.name
        cell.rating.rating = Int(object.rating)
        cell.cupcakeImage.kf.setImage(with: URL(string: "\(WEBSITE_BASE_URL)\(object.image)")!,
                              placeholder: nil,
                              options: [.transition(.fade(1))],
                              progressBlock: nil,
                              completionHandler: nil)
        
        /*
        
        let photoURL = NSURL(string:"\(WEBSITE_BASE_URL)\(object.image)")
        
        if let imageData = NSData(contentsOfURL: photoURL!) {
            let image = UIImage(data: imageData)!
            cell.cupcakeImage.sizeThatFits(CGSize(width: 100, height: 100))
            cell.cupcakeImage.image  = image
         
        }
         */
    
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCupcake" {
            let naviController = segue.destination as! UINavigationController
            let cakeDetailViewController = naviController.viewControllers.first as! DetailViewController
            
            // Get the cell that generated this segue.
            if let selectedCakeCell = sender as? CupcakeTableViewCell {
                let indexPath = tableView.indexPath(for: selectedCakeCell)!
                cakeDetailViewController.cupcake = results[indexPath.row]
            }
        }
        else if segue.identifier == "AddCupcake" {
            print("Adding new meal.")
        }

    
    }
 

}
