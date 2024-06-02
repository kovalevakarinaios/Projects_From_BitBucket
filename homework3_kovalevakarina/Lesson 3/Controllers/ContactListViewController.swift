//
//  ContactListViewController.swift
//  Lesson 3
//
//  Created by Karina Kovaleva on 19.12.22.
//

import Contacts
import UIKit

class ContactListViewController: UIViewController {

    private let contactStore = CNContactStore()

    private var finalContacts = [Contact]() {
        didSet {
            contactsTableView.reloadData()
        }
    }

    private lazy var contactsTableView: UITableView = {
        var contactsTableView = UITableView()
        contactsTableView.register(ContactListTableViewCell.self,
                                   forCellReuseIdentifier: ContactListTableViewCell.identifier)
        return contactsTableView
    }()

    private lazy var buttonConfiguration: UIButton.Configuration = {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.buttonSize = .large
        buttonConfiguration.title = String(localized: "downloadContacts")
        buttonConfiguration.imagePadding = 3
        buttonConfiguration.imagePlacement = .trailing
        buttonConfiguration.image = UIImage(systemName: "arrow.down.to.line.alt")
        return buttonConfiguration
    }()

    private lazy var accessСontactsButton: UIButton = {
        var configuration = buttonConfiguration
        var accessСontactsButton = UIButton(type: .custom)
        accessСontactsButton.configuration = configuration
        accessСontactsButton.addTarget(self, action: #selector(requestAccessToContacts), for: .touchUpInside)
        return accessСontactsButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Storage.fileExists("contacts.json", in: .documents) {
            setupTableView()
            addLongPressRecognizer()
        } else {
            setupButton()
        }
    }

    private func setupNavBar() {
        self.navigationItem.title = String(localized: "contacts")
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupTableView() {

        self.view.addSubview(self.contactsTableView)

        self.contactsTableView.delegate = self
        self.contactsTableView.dataSource = self

        contactsTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contactsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contactsTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contactsTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contactsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

        self.finalContacts = Storage.retrieve("contacts.json", from: .documents, as: [Contact].self)
    }

    private func setupButton() {
        self.view.addSubview(accessСontactsButton)
        accessСontactsButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            accessСontactsButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            accessСontactsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }

    @objc private func requestAccessToContacts() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            fetchContacts()
            accessСontactsButton.removeFromSuperview()
            setupTableView()
        case .denied:
            showSettingsAlert()
        case .restricted, .notDetermined:
            contactStore.requestAccess(for: .contacts) { [weak self] isAccessed, _ in
                if isAccessed {
                    self?.fetchContacts()
                    DispatchQueue.main.async {
                        self?.accessСontactsButton.removeFromSuperview()
                        self?.setupTableView()
                    }
                } else {
                    self?.showSettingsAlert()
                }
            }
        @unknown default:
            print("Didn't request permission for User Contact")
        }
    }

    private func fetchContacts() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,
                    CNContactImageDataAvailableKey, CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
        let contactRequest = CNContactFetchRequest(keysToFetch: keys)
        var contacts = [Contact]()
            do {
                try self.contactStore.enumerateContacts(with: contactRequest) { contact, _ in
                    let givenName = contact.givenName
                    let familyName = contact.familyName
                    guard let number = contact.phoneNumbers.first?.value.stringValue else { return }
                    if contact.imageDataAvailable {
                        guard let thumbnailImage = contact.thumbnailImageData else { return }
                        let contact = Contact(givenName: givenName, familyName: familyName,
                                              phoneNumber: number, thumbnailImageData: thumbnailImage, favorite: false)
                        contacts.append(contact)
                    } else {
                        guard let imageData = UIImage(named: "person")?.pngData() else { return }
                        let contact = Contact(givenName: givenName, familyName: familyName,
                                              phoneNumber: number, thumbnailImageData: imageData, favorite: false)
                        contacts.append(contact)
                    }
                    Storage.store(contacts, to: .documents, as: "contacts.json")
                }
            } catch {
                print("error")
            }
    }

    private func showSettingsAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil,
                                          message: """
                                        This app requires access to Contacts to proceed.
                                        Go to Settings to grant access.
                                        """,
                                          preferredStyle: .alert)
            if let settings = URL(string: UIApplication.openSettingsURLString),
                                            UIApplication.shared.canOpenURL(settings) {
                alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
                    UIApplication.shared.open(settings)
                })
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}

extension ContactListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        finalContacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactListTableViewCell.identifier)
                as? ContactListTableViewCell else { return ContactListTableViewCell() }
        cell.configureCell(model: finalContacts[indexPath.row])
        cell.delegate = self
        addLongPressRecognizer()
        return cell
    }

    private func addLongPressRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(showAlert))
        self.view.addGestureRecognizer(longPressRecognizer)
    }

    @objc private func showAlert(sender: UILongPressGestureRecognizer) {

        let touchPoint = sender.location(in: self.contactsTableView)
        guard let indexPath = contactsTableView.indexPathForRow(at: touchPoint) else { return }
        let contact = finalContacts[indexPath.row]

        let alert = UIAlertController(title: contact.givenName, message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: String(localized: "copy"),
                                      style: .default,
                                      handler: { _ in
            UIPasteboard.general.string = contact.phoneNumber
        }))

        alert.addAction(UIAlertAction(title: String(localized: "share"),
                                      style: .default,
                                      handler: { [unowned self] _ in
            let activityViewController = UIActivityViewController(activityItems: finalContacts,
                                                                  applicationActivities: nil)
            self.present(activityViewController, animated: true)
        }))

        alert.addAction(UIAlertAction(title: String(localized: "delete"),
                                      style: .destructive,
                                      handler: { [unowned self] _ in
            self.finalContacts.remove(at: indexPath.row)
            Storage.remove("contacts.json", from: .documents)
            if finalContacts.isEmpty {
                setupButton()
            } else {  Storage.store(finalContacts, to: .documents, as: "contacts.json")
            }
        }))

        alert.addAction(UIAlertAction(title: String(localized: "cancel"), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ContactListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = DetailContactViewController(numberOfContact: indexPath.row)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ContactListViewController: ContactListTableViewCellDelegate {
    func changeFavoritesContacts(cell: ContactListTableViewCell) {
        guard let indexPath = contactsTableView.indexPath(for: cell) else { return }
        finalContacts[indexPath.row].favorite.toggle()
        Storage.remove("contacts.json", from: .documents)
        Storage.store(finalContacts, to: .documents, as: "contacts.json")
    }
}
