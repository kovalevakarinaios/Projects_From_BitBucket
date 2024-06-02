//
//  CellModel.swift
//  ATMs
//
//  Created by Karina Kovaleva on 15.01.23.
//

import Foundation

struct CellModel: Hashable {
    var type: DataType
    var city: String?
    var id: String?
    var idInfoBox: Int?
    var filialID: String?
    var installPlace: String?
    var workTime: String?
    var currency: String?
    var filialName: String?
    var nameType, name: String?
    var streetType, street, homeNumber: String?
    var phoneInfo: String?
    var gpsX, gpsY: String?
    var distance: Double?
    var infoWorktime: String?

    init(type: DataType, city: String, id: String, installPlace: String,
         workTime: String, currency: String, gpsX: String, gpsY: String) {
        self.type = type
        self.city = city
        self.id = id
        self.installPlace = installPlace
        self.workTime = workTime
        self.currency = currency
        self.gpsX = gpsX
        self.gpsY = gpsY
    }

    init(type: DataType, city: String, idInfobox: Int, installPlace: String,
         workTime: String, currency: String, gpsX: String, gpsY: String) {
        self.type = type
        self.city = city
        self.idInfoBox = idInfobox
        self.installPlace = installPlace
        self.workTime = workTime
        self.currency = currency
        self.gpsX = gpsX
        self.gpsY = gpsY
    }

    init(type: DataType, filialID: String, filialName: String, nameType: String, name: String,
         streetType: String, street: String, homeNumber: String, phoneInfo: String,
         gpsX: String, gpsY: String, infoWorktime: String) {
        self.type = type
        self.filialID = filialID
        self.filialName = filialName
        self.nameType = nameType
        self.name = name
        self.streetType = streetType
        self.street = street
        self.homeNumber = homeNumber
        self.phoneInfo = phoneInfo
        self.gpsX = gpsX
        self.gpsY = gpsY
        self.infoWorktime = infoWorktime
    }
}
