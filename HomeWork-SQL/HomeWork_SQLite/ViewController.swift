//
//  ViewController.swift
//  HomeWork_SQLite
//
//  Created by Karina Kovaleva on 2.12.22.
//

import UIKit
import SQLite3

struct User {
    let id: Int32
    let name: NSString
    let surname: NSString
}

let documentDir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let users = [User(id: 1, name: "Karina", surname: "Kovaleva"), User(id: 2, name: "Petya", surname: "Petrov")]
    var newUsers : [User] = []
    let databasePath = documentDir?.appendingPathExtension("database.sqlite").relativePath
    
    var database: OpaquePointer?
    
    var tableView: UITableView = {
          var tableView = UITableView()
          tableView.translatesAutoresizingMaskIntoConstraints = false
          tableView.layer.cornerRadius = 30
          return tableView
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray

        self.view.addSubview(tableView)
               
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110 ).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -110).isActive = true
        
        database = openDatabase()
        createTable()
//        insertUser(User(id: 1, name: "Karina", surname: "Kovaleva"))
        insertUsers(users)
    }
    
    func openDatabase() -> OpaquePointer? {
        var database: OpaquePointer?
        guard databasePath != nil else {
            print("databasePath is nil.")
            return nil
        }
        if sqlite3_open(databasePath, &database) == SQLITE_OK {
            print("Successfully opened connection to database at \(String(describing: databasePath))")
            return database
        } else {
            print("Unable to open database.")
            return nil
        }
    }
    
    func createTable() {
        let createTableString = """
CREATE TABLE Users(
Id INT PRIMARY KEY NOT NULL,
Name CHAR (255), Surname CHAR (255));
"""
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("User table created.")
            } else {
                print("User table is not created.")
            }
        } else {
            print("CREATE TABLE statement is not prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertUser(_ user: User) {
        let insertStatementString = "INSERT INTO Users (Id, Name, Surname) VALUES (?, ?, ?);"

        var insertStatement: OpaquePointer?

        if sqlite3_prepare_v2(database, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, user.id)
            sqlite3_bind_text(insertStatement, 2, user.name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, user.surname.utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement is not prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertUsers(_ users: [User]) {
        let insertStatementString = "INSERT INTO Users (Id, Name, Surname) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(database, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            for user in users {
                sqlite3_bind_int(insertStatement, 1, user.id)
                sqlite3_bind_text(insertStatement, 2, user.name.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, user.surname.utf8String, -1, nil)
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
                sqlite3_reset(insertStatement)
            }
            sqlite3_finalize(insertStatement)
        } else {
            print("INSERT statement is not prepared.")
        }
    }
    
    func query() -> [User?] {
        let queryStatementString = "SELECT * FROM Users;"
        var queryStatement: OpaquePointer?
        var users: [User] = []
        if sqlite3_prepare_v2(database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
             while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let id = sqlite3_column_int(queryStatement, 0)
                guard let queryResultName = sqlite3_column_text(queryStatement, 1) else { return [nil] }
                let name = String(cString: queryResultName)
                guard let queryResultSurname = sqlite3_column_text(queryStatement, 2) else { return [nil] }
                let surname = String(cString: queryResultSurname)
                users.append(User(id: id, name: name as NSString, surname: surname as NSString))
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(database))
            print("Query is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as! TableViewCell
        cell.labelForId.text = String(newUsers[indexPath.row].id)
        cell.labelForName.text = newUsers[indexPath.row].name as String?
        cell.labelForSurname.text = newUsers[indexPath.row].surname as String?
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newUsers.count
    }
}
