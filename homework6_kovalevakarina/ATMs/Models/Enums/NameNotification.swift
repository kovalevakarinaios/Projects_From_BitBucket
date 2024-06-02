//
//  NameNotification.swift
//  ATMs
//
//  Created by Karina Kovaleva on 15.01.23.
//

import Foundation

enum NameNotification: String {
    case dataReceived
    case dataLoading
    case errors
    case noInternetConnection
    case filter
    case update
    case locationAccessed

    var notification: Notification.Name {
        return Notification.Name(rawValue: self.rawValue )
    }
}
