//
//  ViewController.swift
//  iOSCupcake
//
//  Created by Hassan Abid on 8/7/16.
//  Copyright © 2016 Hassan Abid. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class DetailViewController: UIViewController {
    
    let WEBSITE_BASE_URL = "https://djangocupcakeshop.azurewebsites.net"

    @IBOutlet weak var cakeImage: UIImageView!
    
    @IBOutlet weak var cakeTitle: UILabel!

    @IBOutlet weak var rating: RatingControl!


    @IBOutlet weak var price: UILabel!
    
    var cupcake : Cupcake!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
    
        self.navigationItem.leftBarButtonItem = backButton
        
        cakeImage.kf.setImage(with: URL(string: "\(WEBSITE_BASE_URL)\(cupcake.image)")!,
                                      placeholder: nil,
                                      options: [.transition(.fade(1))],
                                      progressBlock: nil,
                                      completionHandler: nil)
        

        cakeTitle.text = cupcake.name
        price.text = "Price : \(cupcake.price)"
        
        rating.rating = Int(cupcake.rating)
        
    }
    
    func cancel() {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    
    }



}

