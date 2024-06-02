//
//  AnnotationForInfobox.swift
//  ATMs
//
//  Created by Karina Kovaleva on 13.01.23.
//

import Foundation
import MapKit

final class AnnotationForInfobox: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let installPlace: String
    let workTime: String
    let currency: String
    let cashInExist: String
    let id: Int

    init(attraction: Infobox) {
        coordinate = AnnotationForInfobox.createCoordinate(attraction.gpsX, attraction.gpsY)
        self.installPlace = attraction.installPlace
        self.workTime = attraction.workTime
        self.currency = attraction.currency
        self.cashInExist = attraction.cashInExist
        self.id = attraction.id
    }

    static func createCoordinate(_ gpsX: String, _ gpsY: String) -> CLLocationCoordinate2D {
        guard let latitude = CLLocationDegrees(gpsX),
              let longitude = CLLocationDegrees(gpsY) else { return CLLocationCoordinate2D() }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return coordinate
    }
}
