//
//  EventsUnarchiver.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 25/04/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

enum EventsUnarchiverError: Error {
  case decodeError
}

class EventsUnarchiver {
  // Use Decodable Protocol to parse Data buffer to Events collection; return a events collection
  static func parseEvents(fromData data: Data) throws -> [Event] {
    
    let decoder = PropertyListDecoder()
    
    guard let events = try? decoder.decode([Event].self, from: data) else { throw  EventsUnarchiverError.decodeError }
    
    return events
  }
}
