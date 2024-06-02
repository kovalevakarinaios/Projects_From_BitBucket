//
//  MapViewController.swift
//  ATMs
//
//  Created by Karina Kovaleva on 27.12.22.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {

    private var infoForModel: InfoForModel?

    private lazy var mapView: MKMapView = {
        var mapView = MKMapView()
        return mapView
    }()

    private lazy var loadingView: UIView = {
        var loadingView = UIView()
        loadingView.backgroundColor = .systemBackground
        return loadingView
    }()

    private lazy var loadingActivityIndicator: UIActivityIndicatorView = {
        let loadingActivityIndicator = UIActivityIndicatorView()
        loadingActivityIndicator.style = .large
        loadingActivityIndicator.color = .systemGreen
        return loadingActivityIndicator
    }()

    private var annotationsAtms = [AnnotationForAtm]()
    private var annotationsInfoboxes = [AnnotationForInfobox]()
    private var annotationsFilials = [AnnotationForFilial]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addObservers()
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.setupLoadingView),
                                               name: NameNotification.dataLoading.notification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.getInfo),
                                               name: NameNotification.dataReceived.notification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.centerTheMap),
                                               name: NameNotification.locationAccessed.notification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.filterData),
                                               name: NameNotification.filter.notification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.showAlertNoInternetConnection),
                                               name: NameNotification.noInternetConnection.notification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.showAlertNoGetData),
                                               name: NameNotification.errors.notification,
                                               object: nil)
    }

    @objc private func setupLoadingView() {
        self.view.addSubview(self.loadingView)
        self.loadingView.addSubview(self.loadingActivityIndicator)
        self.loadingActivityIndicator.startAnimating()
        self.loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.loadingActivityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc private func getInfo(notification: NSNotification) {
        if let infoForModel = notification.userInfo?["Info"] as? InfoForModel {
            setupMapView()
            self.infoForModel = infoForModel
            annotationsAtms = infoForModel.atms.map { AnnotationForAtm(attraction: $0) }
            annotationsInfoboxes = infoForModel.infoboxes.map { AnnotationForInfobox(attraction: $0) }
            annotationsFilials = infoForModel.filials.map { AnnotationForFilial(attraction: $0) }
            self.mapView.addAnnotations(annotationsAtms)
            self.mapView.addAnnotations(annotationsInfoboxes)
            self.mapView.addAnnotations(annotationsFilials)
        }
    }

    private func setupMapView() {
        DispatchQueue.main.async {
            self.view.subviews.forEach { $0.removeFromSuperview() }
            self.view.addSubview(self.mapView)
            self.mapView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.centerTheMap()
        }
        self.mapView.delegate = self
    }

    @objc private func filterData(notification: NSNotification) {
        if let filter = notification.userInfo?["Filter"] as? [Bool] {
            for (index, filter) in filter.enumerated() {
                switch filter {
                case true:
                    if index == 0 {
                        self.mapView.addAnnotations(self.annotationsAtms)
                    } else if index == 1 {
                        self.mapView.addAnnotations(self.annotationsInfoboxes)
                    } else {
                        self.mapView.addAnnotations(self.annotationsFilials)
                    }
                case false:
                    if index == 0 {
                        self.mapView.removeAnnotations(self.annotationsAtms)
                    } else if index == 1 {
                        self.mapView.removeAnnotations(self.annotationsInfoboxes)
                    } else {
                        self.mapView.removeAnnotations(self.annotationsFilials)
                    }
                }
            }
        }
    }

    @objc private func centerTheMap() {
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                        longitude: location.coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let coordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
                strongSelf.mapView.setRegion(coordinateRegion, animated: true)
            }
        }
    }

    @objc func showAlertNoGetData(notification: NSNotification) {
        if let errors = notification.userInfo?["Errors"] as? [Int] {
            if !errors.isEmpty {
                var text = String()
                for error in errors {
                    switch error {
                    case 0:
                        text += "Банкоматы не были загружены\n"
                    case 1:
                        text += "Инфокиоски не были загружены\n"
                    case 2:
                        text += "Отделения не были загружены\n"
                    default:
                        break
                    }
                }
                let alert = UIAlertController(title: nil,
                                              message: text,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Понятно", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }

    public func selectAnnotation(_ id: String, _ type: DataType) {
        switch type {
        case .atm:
            let annotationsAtms = annotationsAtms.filter { $0.id == id }
            guard let annotation = annotationsAtms.first else { return }
            self.mapView.selectAnnotation(annotation, animated: true)
        case .infobox:
            let annotationsInfoboxes = annotationsInfoboxes.filter { String($0.id) == id }
            guard let annotation = annotationsInfoboxes.first else { return }
            self.mapView.selectAnnotation(annotation, animated: true)
        case .filial:
            let annotationsFilials = annotationsFilials.filter { $0.id == id }
            guard let annotation = annotationsFilials.first else { return }
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }

    @objc private func showAlertNoInternetConnection() {
            let alert = UIAlertController(title: "Нет соединения с сетью",
                                          message: "Для работы приложения необходимо соединение с интернетом",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Понятно", style: .cancel))
            self.present(alert, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.dataReceived.notification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.dataLoading.notification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.locationAccessed.notification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.filter.notification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.noInternetConnection.notification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.errors.notification,
                                                  object: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        switch annotation {
        case is AnnotationForAtm:
            guard let annotation = annotation as? AnnotationForAtm else { return MKAnnotationView() }
            annotationView.glyphText = "ATM"
            annotationView.markerTintColor = .systemGreen
            annotationView.canShowCallout = true
            let calloutView = CalloutView(annotation: annotation)
            calloutView.delegate = self
            annotationView.detailCalloutAccessoryView = calloutView
        case is AnnotationForInfobox:
            guard let annotation = annotation as? AnnotationForInfobox else { return MKAnnotationView() }
            annotationView.glyphImage = UIImage(systemName: "info.circle")
            annotationView.markerTintColor = .systemGreen
            annotationView.canShowCallout = true
            let calloutView = CalloutView(annotation: annotation)
            calloutView.delegate = self
            annotationView.detailCalloutAccessoryView = calloutView
        case is AnnotationForFilial:
            guard let annotation = annotation as? AnnotationForFilial else { return MKAnnotationView() }
            annotationView.glyphImage = UIImage(systemName: "banknote")
            annotationView.markerTintColor = .systemGreen
            annotationView.canShowCallout = true
            let calloutView = CalloutView(annotation: annotation)
            calloutView.delegate = self
            annotationView.detailCalloutAccessoryView = calloutView
        default:
            break
        }
        return annotationView
    }
}

extension MapViewController: CalloutViewDelegate {
    func openDetailViewController(_ id: String, _ type: DataType) {
        switch type {
        case .atm:
            guard let atm = self.infoForModel?.atms.first(where: {$0.id == id}) else { return }
            let viewController = DetailViewController(atm: atm)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .infobox:
            guard let infobox = self.infoForModel?.infoboxes.first(where: {String($0.id) == id}) else { return }
            let viewController = DetailViewController(infobox: infobox)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .filial:
            guard let filial = self.infoForModel?.filials.first(where: {$0.filialID == id}) else { return }
            let viewController = DetailViewController(filial: filial)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
