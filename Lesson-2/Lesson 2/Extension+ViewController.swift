//
//  Extension+ViewController.swift
//  Lesson 2
//
//  Created by Karina Kovaleva on 13.12.22.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! ProfileTableViewCell
        let infoForOneCell = info[indexPath.row]
        guard let image = infoForOneCell.imageName else { return UITableViewCell() }
        guard let title = infoForOneCell.title else { return UITableViewCell() }
        guard let description = infoForOneCell.description else { return UITableViewCell() }
        cell.avatar.image = UIImage(named: ("\(image)"))
        cell.titleLabel.text = "\(title)"
        cell.descriptionLabel.text = "\(description)"
        sideAvatar = cell.sideAvatar
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] action, view, completionHandler in
            self.info.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("before \(tableView.isEditing)")
            self.turnEditing()
            self.turnEditing()
            let alert = UIAlertController(title: "Alert", message: "Long press anywhere on the screen to finish editing", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
        }
        
        tableView.reloadData()
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.info[sourceIndexPath.row]
        info.remove(at: sourceIndexPath.row)
        info.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = ProfileViewController(profile: info[indexPath.row], sideAvatar: self.sideAvatar)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
