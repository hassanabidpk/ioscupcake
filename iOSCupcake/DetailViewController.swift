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
        
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(cancel))
    
        self.navigationItem.leftBarButtonItem = backButton
        
        cakeImage.kf_setImageWithURL(NSURL(string: "\(WEBSITE_BASE_URL)\(cupcake.image)")!,
                                             placeholderImage: nil,
                                             optionsInfo: [.Transition(ImageTransition.Fade(1))])
        

        cakeTitle.text = cupcake.name
        price.text = "Price : \(cupcake.price)"
        
        rating.rating = Int(cupcake.rating)
        
    }
    
    func cancel() {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    
    }



}

