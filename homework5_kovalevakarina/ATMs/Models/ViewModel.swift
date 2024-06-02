//
//  AtmViewModel.swift
//  ATMs
//
//  Created by Karina Kovaleva on 9.01.23.
//

import Foundation
import MapKit

class ViewModel: NSObject {

    private let group = DispatchGroup()

    public var reloadCollectionView: (() -> Void)?

    private var atms = [ATM]()
    private var infoboxes = [Infobox]()
    private var filials = [Filial]()

    private var atmsСellModel = [CellModel]()
    private var infoboxesCellModel = [CellModel]()
    private var filialsCellModel = [CellModel]()

    private var infoForCellModel: InfoForModel?
    private var fullSectionViewModels = [SectionViewModel]()

    public var sectionViewModels = [SectionViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }

    private var service: NetworkAPIProtocol

    public init(service: NetworkAPIProtocol = NetworkAPI()) {
        self.service = service
        super.init()
        self.addObservers()
    }

    public func getInfoFromApi() {
        if NetworkMonitor.shared.isConnected {
            NotificationCenter.default.post(name: NameNotification.dataLoading.notification,
                                            object: nil,
                                            userInfo: nil)
            var errors = [Int]()
            self.group.enter()
            service.getAtmsList { success, model, _ in
                if success, let atms = model {
                    self.atms = atms
                } else {
                    errors.append(0)
                }
                self.group.leave()
            }
            self.group.enter()
            service.getInfoboxList { success, model, _ in
                if success, let infoboxes = model {
                    self.infoboxes = infoboxes
                } else {
                    errors.append(1)
                }
                self.group.leave()
            }
            self.group.enter()
            service.getFilialsList { success, model, _ in
                if success, let filials = model {
                    self.filials = filials
                } else {
                    errors.append(2)
                }
                self.group.leave()
            }
            group.notify(queue: DispatchQueue.main) {
                self.infoForCellModel = InfoForModel(atms: self.atms,
                                                     infoboxes: self.infoboxes,
                                                     filials: self.filials)
                NotificationCenter.default.post(name: NameNotification.dataReceived.notification,
                                                object: nil,
                                                userInfo: [ "Info": self.infoForCellModel as Any])
                NotificationCenter.default.post(name: NameNotification.errors.notification,
                                                object: nil,
                                                userInfo: [ "Errors": errors as Any])
                self.fetchData(infoForModel: self.infoForCellModel!)
            }
        } else {
            NotificationCenter.default.post(name: NameNotification.noInternetConnection.notification,
                                            object: nil,
                                            userInfo: nil)
        }
    }

    private func fetchData(infoForModel: InfoForModel) {
        let atms = Dictionary(grouping: infoForModel.atms, by: {$0.city})
        let infoboxes = Dictionary(grouping: infoForModel.infoboxes, by: {$0.city})
        let filials = Dictionary(grouping: infoForModel.filials, by: {$0.name})
        let atmsKeys = Array(atms.keys)
        let infoboxesKeys = Array(infoboxes.keys)
        let filialKeys = Array(infoboxes.keys)
        let allKeys = Set(atmsKeys + infoboxesKeys + filialKeys)
        var sectionViewModels = [SectionViewModel]()
        for key in allKeys {
            var section = SectionViewModel(city: key, infoForModel: [CellModel]())
            if let atms = atms[key] {
                let atmsCellModel = atms.map { CellModel(type: .atm,
                                                         city: $0.city,
                                                         id: $0.id,
                                                         installPlace: $0.installPlace,
                                                         workTime: $0.workTime,
                                                         currency: $0.currency,
                                                         gpsX: $0.gpsX,
                                                         gpsY: $0.gpsY) }
                section.infoForModel.append(contentsOf: atmsCellModel)
                self.atmsСellModel.append(contentsOf: atmsСellModel)
            }
            if let infoboxes = infoboxes[key] {
                let infoboxesCellModel = infoboxes.map { CellModel(type: .infobox,
                                                                   city: $0.city,
                                                                   idInfobox: $0.id,
                                                                   installPlace: $0.installPlace,
                                                                   workTime: $0.workTime,
                                                                   currency: $0.currency,
                                                                   gpsX: $0.gpsX,
                                                                   gpsY: $0.gpsY) }
                section.infoForModel.append(contentsOf: infoboxesCellModel)
                self.infoboxesCellModel.append(contentsOf: infoboxesCellModel)
            }
            if let filials = filials[key] {
                let filialsCellModel = filials.map { CellModel(type: .filial,
                                                               filialID: $0.filialID,
                                                               filialName: $0.filialName,
                                                               nameType: $0.nameType,
                                                               name: $0.name,
                                                               streetType: $0.streetType,
                                                               street: $0.street,
                                                               homeNumber: $0.homeNumber,
                                                               phoneInfo: $0.phoneInfo,
                                                               gpsX: $0.gpsX,
                                                               gpsY: $0.gpsY,
                                                               infoWorktime: $0.infoWorktime)}
                section.infoForModel.append(contentsOf: filialsCellModel)
                self.filialsCellModel.append(contentsOf: filialsCellModel)
            }
            for (index, item) in section.infoForModel.enumerated() {
                guard let gpsX = item.gpsX,
                      let gpsY = item.gpsY else { return }
                guard let latitude = CLLocationDegrees(gpsX),
                      let longitude = CLLocationDegrees(gpsY) else { return }
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                section.infoForModel[index].distance = LocationManager.shared.distanceTo(coordinate: coordinate)
            }
            section.infoForModel.sort(by: { $0.distance! < $1.distance! })
            sectionViewModels.append(section)
        }
        self.sectionViewModels = sectionViewModels
        self.fullSectionViewModels = sectionViewModels
    }

    public func getCellViewModel(at indexPath: IndexPath) -> CellModel {
        return sectionViewModels[indexPath.section].infoForModel[indexPath.row]
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.filterData),
                                               name: NameNotification.filter.notification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateAtms),
                                               name: NameNotification.update.notification,
                                               object: nil)
    }

    @objc public func filterData(notification: NSNotification) {
        if let filter = notification.userInfo?["Filter"] as? [Bool] {
            if filter.allSatisfy({ $0 == true }) {
                let sectionViewModels = fullSectionViewModels
                self.sectionViewModels = sectionViewModels
            } else if filter[0] && filter [1] {
                var sectionViewModels = [SectionViewModel]()
                var emptyIndices = [Int]()
                for (index, model) in fullSectionViewModels.enumerated() {
                    let section = model.infoForModel
                        .filter { $0.type == .atm || $0.type == .infobox }
                    section.isEmpty ? emptyIndices.append(index) : nil
                    sectionViewModels.append(SectionViewModel(city: model.city, infoForModel: section))
                }
                self.removeEmptySections(&sectionViewModels, indices: emptyIndices)
                self.sectionViewModels = sectionViewModels
            } else if filter[0] && filter [2] {
                var sectionViewModels = [SectionViewModel]()
                var emptyIndices = [Int]()
                for (index, model) in fullSectionViewModels.enumerated() {
                    let section = model.infoForModel
                        .filter { $0.type == .atm || $0.type == .filial }
                    section.isEmpty ? emptyIndices.append(index) : nil
                    sectionViewModels.append(SectionViewModel(city: model.city, infoForModel: section))
                }
                self.removeEmptySections(&sectionViewModels, indices: emptyIndices)
                self.sectionViewModels = sectionViewModels
            } else if filter[1] && filter [2] {
                var sectionViewModels = [SectionViewModel]()
                var emptyIndices = [Int]()
                for (index, model) in fullSectionViewModels.enumerated() {
                    let section = model.infoForModel
                        .filter { $0.type == .infobox || $0.type == .filial }
                    section.isEmpty ? emptyIndices.append(index) : nil
                    sectionViewModels.append(SectionViewModel(city: model.city, infoForModel: section))
                }
                self.removeEmptySections(&sectionViewModels, indices: emptyIndices)
                self.sectionViewModels = sectionViewModels
            } else if filter[0] {
                var sectionViewModels = [SectionViewModel]()
                var emptyIndices = [Int]()
                for (index, model) in fullSectionViewModels.enumerated() {
                    let section = model.infoForModel
                        .filter { $0.type == .atm }
                    section.isEmpty ? emptyIndices.append(index) : nil
                    sectionViewModels.append(SectionViewModel(city: model.city, infoForModel: section))
                }
                self.removeEmptySections(&sectionViewModels, indices: emptyIndices)
                self.sectionViewModels = sectionViewModels
            } else if filter[1] {
                var sectionViewModels = [SectionViewModel]()
                var emptyIndices = [Int]()
                for (index, model) in fullSectionViewModels.enumerated() {
                    let section = model.infoForModel
                        .filter { $0.type == .infobox }
                    section.isEmpty ? emptyIndices.append(index) : nil
                    sectionViewModels.append(SectionViewModel(city: model.city, infoForModel: section))
                }
                self.removeEmptySections(&sectionViewModels, indices: emptyIndices)
                self.sectionViewModels = sectionViewModels
            } else if filter[2] {
                var sectionViewModels = [SectionViewModel]()
                var emptyIndices = [Int]()
                for (index, model) in fullSectionViewModels.enumerated() {
                    let section = model.infoForModel
                        .filter { $0.type == .filial }
                    section.isEmpty ? emptyIndices.append(index) : nil
                    sectionViewModels.append(SectionViewModel(city: model.city, infoForModel: section))
                }
                self.removeEmptySections(&sectionViewModels, indices: emptyIndices)
                self.sectionViewModels = sectionViewModels
            } else {
                self.sectionViewModels.removeAll()
            }
        }
    }

    private func removeEmptySections(_ sectionViewModels: inout [SectionViewModel], indices: [Int]) {
        sectionViewModels = sectionViewModels
            .enumerated()
            .filter { !indices.contains($0.offset) }
            .map { $0.element }
    }

    @objc private func updateAtms() {
        if NetworkMonitor.shared.isConnected {
            NotificationCenter.default.post(name: NameNotification.dataLoading.notification,
                                            object: nil,
                                            userInfo: nil)
            service.getAtmsList { success, model, error in
                if success, let atms = model {
                    self.atms = atms
                    self.infoForCellModel = InfoForModel(atms: self.atms,
                                                         infoboxes: self.infoboxes,
                                                         filials: self.filials)
                    NotificationCenter.default.post(name: NameNotification.dataReceived.notification,
                                                    object: nil,
                                                    userInfo: [ "Info": self.infoForCellModel as Any])
                    guard let infoForCellModel = self.infoForCellModel else { return }
                    self.fetchData(infoForModel: infoForCellModel)
                } else {
                    print(error!)
                }
            }
            self.group.enter()
            service.getInfoboxList { success, model, error in
                if success, let infoboxes = model {
                    self.infoboxes = infoboxes
                } else {
                    print(error!)
                }
                self.group.leave()
            }
            self.group.enter()
            service.getFilialsList { success, model, error in
                if success, let filials = model {
                    self.filials = filials
                } else {
                    print(error!)
                }
                self.group.leave()
            }
            group.notify(queue: DispatchQueue.main) {
                self.infoForCellModel = InfoForModel(atms: self.atms,
                                                     infoboxes: self.infoboxes,
                                                     filials: self.filials)
                NotificationCenter.default.post(name: NameNotification.dataReceived.notification,
                                                object: nil,
                                                userInfo: [ "Info": self.infoForCellModel as Any])
                guard let infoForCellModel = self.infoForCellModel else { return }
                self.fetchData(infoForModel: infoForCellModel)
            }
        } else {
            NotificationCenter.default.post(name: NameNotification.noInternetConnection.notification,
                                            object: nil,
                                            userInfo: nil)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.filter.notification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.update.notification,
                                                  object: nil)
    }
}
