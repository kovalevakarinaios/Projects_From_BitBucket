//
//  TableCell.swift
//  HomeWork_SQLite
//
//  Created by Karina Kovaleva on 2.12.22.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let id = "TableViewCell"
    
    var labelForId: UILabel = {
        var labelForId = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        labelForId.font = UIFont(name: "Times New Roman", size: 40)
        labelForId.textAlignment = .center
        labelForId.textColor = .black
        labelForId.numberOfLines = 0
        labelForId.lineBreakMode = .byWordWrapping
        labelForId.translatesAutoresizingMaskIntoConstraints = false
        return labelForId
    }()
    
    var labelForName: UILabel = {
        var labelForName = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        labelForName.font = UIFont(name: "Times New Roman", size: 40)
        labelForName.textColor = .black
        labelForName.numberOfLines = 0
        labelForName.lineBreakMode = .byWordWrapping
        labelForName.translatesAutoresizingMaskIntoConstraints = false
        return labelForName
    }()
    
    var labelForSurname: UILabel = {
        var labelForSurname = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        labelForSurname.font = UIFont(name: "Times New Roman", size: 40)
        labelForSurname.textColor = .black
        labelForSurname.numberOfLines = 0
        labelForSurname.lineBreakMode = .byWordWrapping
        labelForSurname.translatesAutoresizingMaskIntoConstraints = false
        return labelForSurname
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "TableViewCell")
        
        self.contentView.addSubview(labelForId)
        self.contentView.addSubview(labelForName)
        self.contentView.addSubview(labelForSurname)
        
        labelForId.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        labelForId.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        labelForId.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        labelForId.rightAnchor.constraint(equalTo: self.labelForName.leftAnchor, constant: -10).isActive = true
        labelForId.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)

        labelForName.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        labelForName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        labelForName.rightAnchor.constraint(equalTo: self.labelForSurname.leftAnchor, constant: -10).isActive = true
        
        labelForSurname.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        labelForSurname.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        labelForSurname.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
