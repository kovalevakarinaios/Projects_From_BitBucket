//
//  AnnotationForFilial.swift
//  ATMs
//
//  Created by Karina Kovaleva on 13.01.23.
//

import Foundation
import MapKit

final class AnnotationForFilial: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let filialName: String
    let infoWorktime: String
    let address: String
    let phoneInfo: String
    let id: String

    init(attraction: Filial) {
        coordinate = AnnotationForInfobox.createCoordinate(attraction.gpsX, attraction.gpsY)
        self.filialName = attraction.filialName
        self.infoWorktime = attraction.infoWorktime
        self.address = AnnotationForFilial.createFullAddress(filial: attraction)
        self.phoneInfo = attraction.phoneInfo
        self.id = attraction.filialID
    }

    static func createCoordinate(_ gpsX: String, _ gpsY: String) -> CLLocationCoordinate2D {
        guard let latitude = CLLocationDegrees(gpsX),
              let longitude = CLLocationDegrees(gpsY) else { return CLLocationCoordinate2D() }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return coordinate
    }

    static func createFullAddress(filial: Filial) -> String {
        var nameType = filial.nameType
        (nameType.isEmpty) ? (nameType = "") : (nameType += " ")
        var name = filial.name
        (name.isEmpty) ? (name = "") : (name += ", ")
        var streetType = filial.streetType
        (streetType.isEmpty) ? (streetType = "") : (streetType += " ")
        var street = filial.street
        (street.isEmpty) ? (street = "") : (street += ", ")
        let homeNumber = filial.homeNumber
        let fullAddress = "Адрес филиала: " + nameType + name + streetType + street + homeNumber
        return fullAddress
    }
}
