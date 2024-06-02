//
//  Contact.swift
//  Lesson 3
//
//  Created by Karina Kovaleva on 20.12.22.
//

import Foundation

struct Contact: Codable {
    var givenName: String
    var familyName: String
    var phoneNumber: String
    let thumbnailImageData: Data
    var favorite: Bool
}
