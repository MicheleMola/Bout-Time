//
//  PlistConverter.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 25/04/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

enum PlistConverterError: Error {
  case invalidResource
  case conversionDataFailure
}

class PlistConverter {
  static func data(fromFile name: String, ofType type: String) throws -> Data {
    guard let url = Bundle.main.url(forResource: name, withExtension: type) else { throw PlistConverterError.invalidResource }
    
    guard let data = try? Data(contentsOf: url) else { throw PlistConverterError.conversionDataFailure }
    
    return data
  }
}
