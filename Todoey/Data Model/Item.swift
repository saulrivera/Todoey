//
//  Item.swift
//  Todoey
//
//  Created by Saul Rivera on 12/04/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

import Foundation

class Item {
    var title: String
    var done: Bool = false
    
    init(title: String) {
        self.title = title
    }
}
