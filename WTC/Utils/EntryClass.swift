//
//  EntryClass.swift
//  WTC
//
//  Created by Lorenzo Ferrante on 3/3/20.
//  Copyright © 2020 Lorenzo Ferrante. All rights reserved.
//

import Foundation


class EntryClass: NSObject {
    var name: String?
    var desc: String?
    var category: String?
    var can_sell: Bool?
    var notes: String?
    var sell_price: Double?
    var quantity: Int16?
    
    internal init(name: String? = nil, desc: String? = nil, category: String? = nil, can_sell: Bool? = nil, notes: String? = nil, sell_price: Double? = nil, quantity: Int16? = nil) {
        self.name = name
        self.desc = desc
        self.category = category
        self.can_sell = can_sell
        self.notes = notes
        self.sell_price = sell_price
        self.quantity = quantity
    }
}
