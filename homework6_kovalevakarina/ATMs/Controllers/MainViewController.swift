//
//  ViewController.swift
//  ATMs
//
//  Created by Karina Kovaleva on 26.12.22.
//

import UIKit
import SnapKit

protocol MainViewControllerDelegate: AnyObject {
    func updateAtms()
}

final class MainViewController: UIViewController {

    private var atms: [ATM] = []

    private lazy var mapVC = MapViewController()
    private lazy var listVC = ListViewController()
    private lazy var filterVC = FilterViewController()

    weak var delegate: MainViewControllerDelegate?

    private lazy var segmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl(items: ["Карта", "Список"])
        segmentedControl.backgroundColor = .systemGreen
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.changeSegmentedControlValue), for: .valueChanged)
        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.addObservers()
        self.configureNavBarAppearance()
        self.setupSegmentedControl()
        self.addDelegates()
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.turnedOff),
                                               name: NameNotification.dataLoading.notification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.turnedOn),
                                               name: NameNotification.dataReceived.notification,
                                               object: nil)
    }

    @objc private func turnedOff() {
        DispatchQueue.main.async {
            self.segmentedControl.isEnabled = false
            self.navigationItem.rightBarButtonItems?.forEach({ $0.isEnabled = false })
        }
    }

    @objc private func turnedOn() {
        DispatchQueue.main.async {
            self.segmentedControl.isEnabled = true
            self.navigationItem.rightBarButtonItems?.forEach({ $0.isEnabled = true })
        }
    }

    private func configureNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        self.title = "Беларусбанк"
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                   target: self,
                                                                   action: #selector(self.updateAtms)),
                                                   UIBarButtonItem(image:
                                                                   UIImage(systemName:
                                                                            "line.3.horizontal.decrease.circle"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(self.showFilter))]
        self.navigationController?.navigationBar.tintColor = .systemGreen
    }

    @objc private func updateAtms() {
        NotificationCenter.default.post(name: NameNotification.update.notification,
                                        object: nil,
                                        userInfo: nil)
    }

    @objc private func showFilter() {
        if let sheet = self.filterVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
          }
        self.present(self.filterVC, animated: true)
    }

    private func setupSegmentedControl() {
        self.view.addSubview(self.segmentedControl)
        self.segmentedControl.sendActions(for: .valueChanged)
        self.segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }

    @objc private func changeSegmentedControlValue() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.add(asChildViewController: self.mapVC)
            self.remove(asChildViewController: self.listVC)
        } else {
            self.remove(asChildViewController: self.mapVC)
            self.add(asChildViewController: self.listVC)
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(5)
        }
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    public func chooseMapViewController() {
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.sendActions(for: .valueChanged)
    }

    public func addDelegates() {
        self.listVC.delegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.dataLoading.notification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.dataReceived.notification,
                                                  object: nil)
    }
}

extension MainViewController: ListViewControllerDelegate {
    func selectAnnotation(_ id: String, _ type: DataType) {
        self.mapVC.selectAnnotation(id, type)
    }
}
