//
//  Item.swift
//  Todoey
//
//  Created by Saul Rivera on 18/04/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var color: String = UIColor.randomFlat().hexValue()
    var category = LinkingObjects(fromType: Category.self, property: "items")
}
