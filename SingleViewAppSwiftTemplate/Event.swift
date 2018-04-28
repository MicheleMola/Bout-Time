//
//  Event.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 24/04/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

// Use decodable protocol to parse Events.plist content
struct Event: Decodable {
  var link: String
  var text: String
  var year: Int
}
