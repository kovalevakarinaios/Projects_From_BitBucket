//
//  AtmCoreData+CoreDataProperties.swift
//  ATMs
//
//  Created by Karina Kovaleva on 22.01.23.
//
//

import Foundation
import CoreData

extension AtmCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AtmCoreData> {
        return NSFetchRequest<AtmCoreData>(entityName: "AtmCoreData")
    }

    @NSManaged public var id: String?
    @NSManaged public var area: String?
    @NSManaged public var cityType: String?
    @NSManaged public var city: String?
    @NSManaged public var addressType: String?
    @NSManaged public var address: String?
    @NSManaged public var house: String?
    @NSManaged public var installPlace: String?
    @NSManaged public var workTime: String?
    @NSManaged public var gpsX: String?
    @NSManaged public var gpsY: String?
    @NSManaged public var installPlaceFull: String?
    @NSManaged public var workTimeFull: String?
    @NSManaged public var atmType: String?
    @NSManaged public var atmError: String?
    @NSManaged public var currency: String?
    @NSManaged public var cashIn: String?
    @NSManaged public var atmPrinter: String?

    internal class func createOrUpdate(item: ATM, with stack: CoreDataStack) {
        var currentAtm: AtmCoreData? // Entity name
        let atmFetch: NSFetchRequest<AtmCoreData> = AtmCoreData.fetchRequest()
        do {
            let results = try stack.managedContext.fetch(atmFetch)
            if results.isEmpty {
                currentAtm = AtmCoreData(context: stack.managedContext)
            } else {
                currentAtm = results.first
            }
            currentAtm?.update(item: item)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }

    internal func update(item: ATM) {
        self.id = item.id
        self.area = item.area
        self.cityType = item.cityType
        self.city = item.city
        self.addressType = item.addressType
        self.address = item.address
        self.house = item.house
        self.installPlace = item.installPlace
        self.workTime = item.workTime
        self.gpsY = item.gpsY
        self.gpsX = item.gpsX
        self.installPlaceFull = item.installPlaceFull
        self.workTimeFull = item.workTimeFull
        self.atmType = item.atmType
        self.atmError = item.atmError
        self.currency = item.currency
        self.cashIn = item.cashIn
        self.atmPrinter = item.atmPrinter
    }

    func create(item: AtmCoreData) -> ATM? {
        guard let id = item.id else { return nil }
        guard let area = item.area else { return nil }
        guard let cityType = item.cityType else { return nil }
        guard let city = item.city else { return nil }
        guard let addressType = item.addressType else { return nil }
        guard let address = item.address else { return nil }
        guard let house = item.house else { return nil }
        guard let installPlace = item.installPlace else { return nil }
        guard let workTime = item.workTime else { return nil }
        guard let gpsY = item.gpsY else { return nil }
        guard let gpsX = item.gpsX else { return nil }
        guard let installPlaceFull = item.installPlaceFull else { return nil }
        guard let workTimeFull = item.workTimeFull else { return nil }
        guard let atmType = item.atmType else { return nil }
        guard let atmError = item.atmError else { return nil }
        guard let currency = item.currency else { return nil }
        guard let cashIn = item.cashIn else { return nil }
        guard let atmPrinter = item.atmPrinter else { return nil }
        let atm = ATM(id: id,
                     area: area,
                     cityType: cityType,
                     city: city,
                     addressType: addressType,
                     address: address,
                     house: house,
                     installPlace: installPlace,
                     workTime: workTime,
                     gpsX: gpsX,
                     gpsY: gpsY,
                     installPlaceFull: installPlaceFull,
                     workTimeFull: workTimeFull,
                     atmType: atmType,
                     atmError: atmError,
                     currency: currency,
                     cashIn: cashIn,
                     atmPrinter: atmPrinter)
        return atm
    }

    internal class func readAtms() -> [ATM] {
        let fetchRequest = AtmCoreData.fetchRequest()
        do {
            var atms = [ATM]()
            let atmCoreData = try AppDelegate.sharedAppDelegate.coreDataStack.managedContext.fetch(fetchRequest)
            for atm in atmCoreData {
                let atmNew = create(atm)
                atms.append(create(atm))
            }
            return atms
        } catch {
            AppDelegate.sharedAppDelegate.coreDataStack.managedContext.rollback()
            print("viewContext didn't read")
            return []
        }
    }
}

extension AtmCoreData: Identifiable {
}
