//
//  Item.swift
//  PokedexPocket
//
//  Created by Azri on 26/07/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
