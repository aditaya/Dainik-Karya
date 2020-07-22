//
//  Item.swift
//  Dainik-Karya
//
//  Created by Vineet Mahali on 21/07/20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
