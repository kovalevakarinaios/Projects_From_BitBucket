//
//  FavoriteContactsViewController.swift
//  Lesson 3
//
//  Created by Karina Kovaleva on 19.12.22.
//

import UIKit

class FavoriteContactsViewController: UIViewController {

    private var favoriteContacts = [Contact]() {
        didSet {
            favoriteContactsTableView.reloadData()
        }
    }

    private lazy var favoriteContactsTableView: UITableView = {
        var favoriteContactsTableView = UITableView()
        favoriteContactsTableView.register(ContactListTableViewCell.self,
                                           forCellReuseIdentifier: ContactListTableViewCell.identifier)
        return favoriteContactsTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavoriteContacts()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        favoriteContacts.removeAll()
    }

    private func setupTableView() {

        self.view.addSubview(favoriteContactsTableView)
        favoriteContactsTableView.allowsSelection = false

        self.favoriteContactsTableView.dataSource = self

        favoriteContactsTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            favoriteContactsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            favoriteContactsTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            favoriteContactsTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            favoriteContactsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    private func getFavoriteContacts() {
        if Storage.fileExists("contacts.json", in: .documents) {
            let finalContacts = Storage.retrieve("contacts.json", from: .documents, as: [Contact].self)
            finalContacts.forEach { [unowned self] contact in
                contact.favorite == true ? favoriteContacts.append(contact) : nil
            }
        }
    }
}

extension FavoriteContactsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteContacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactListTableViewCell.identifier)
                as? ContactListTableViewCell else { return ContactListTableViewCell() }
        cell.configureCell(model: favoriteContacts[indexPath.row])
        return cell
    }
}
