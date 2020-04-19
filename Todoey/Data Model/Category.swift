//
//  Category.swift
//  Todoey
//
//  Created by Saul Rivera on 18/04/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
