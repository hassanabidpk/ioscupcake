//
//  Cupcake.swift
//  iOSCupcake
//
//  Created by Hassan Abid on 8/7/16.
//  Copyright © 2016 Hassan Abid. All rights reserved.
//

import Foundation
import RealmSwift

class Cupcake: Object {

    dynamic var name = ""
    dynamic var rating = 0.0
    dynamic var price = ""
    dynamic var writer = ""
    dynamic var image = ""
    dynamic var createdAt = ""

}
