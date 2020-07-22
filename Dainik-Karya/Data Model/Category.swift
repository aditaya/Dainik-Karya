//
//  Category.swift
//  Dainik-Karya
//
//  Created by Vineet Mahali on 21/07/20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
    
}
