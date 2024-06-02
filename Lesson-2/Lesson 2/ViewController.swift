//
//  ViewController.swift
//  Lesson 2
//
//  Created by Karina Kovaleva on 13.12.22.
//

import UIKit

class ViewController: UIViewController {
    
    var info: [Info] = []
    var sideAvatar = CGFloat()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        setupTableView()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        tableView.isEditing = false
    }

    func setupTableView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(tableView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func getInfo() {
        for _ in 1...100 {
            for n in 1...10 {
                info.append(Info(imageName: n, title: nil, description: nil))
            }
        }
        for (index, _) in info.enumerated() {
            info[index].title = "Title - \(index + 1)"
            info[index].description = "Description - \(index + 1)"
        }
    }
    
    func turnEditing() {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }
    
}
