//
//  ContactListTableViewCell.swift
//  Lesson 3
//
//  Created by Karina Kovaleva on 20.12.22.
//

import UIKit

protocol ContactListTableViewCellDelegate: AnyObject {
    func changeFavoritesContacts(cell: ContactListTableViewCell)
}

class ContactListTableViewCell: UITableViewCell {

    static let identifier = "ContactListTableViewCell"

    var delegate: ContactListTableViewCellDelegate?

    private lazy var avatar: CircleImageView = {
        var avatar = CircleImageView()
        return avatar
    }()

    private lazy var stackViewForLabels: UIStackView = {
        var stackViewForLabels = UIStackView()
        stackViewForLabels.axis = .vertical
        stackViewForLabels.distribution = .fillProportionally
        stackViewForLabels.alignment = .leading
        stackViewForLabels.spacing = 2
        [self.fullNameLabel, self.phoneNumberLabel].forEach { stackViewForLabels.addArrangedSubview($0) }
        return stackViewForLabels
    }()

    private lazy var fullNameLabel: UILabel = {
        var fullNameLabel = UILabel()
        fullNameLabel.textColor = .darkGray
        return fullNameLabel
    }()

    private lazy var phoneNumberLabel: UILabel = {
        var phoneNumberLabel = UILabel()
        phoneNumberLabel.textColor = .lightGray
        return phoneNumberLabel
    }()

    private lazy var buttonConfiguration: UIButton.Configuration = {
        var buttonConfiguration = UIButton.Configuration.tinted()
        buttonConfiguration.buttonSize = .mini
        buttonConfiguration.imagePlacement = .all
        return buttonConfiguration
    }()

    private lazy var favoriteButton: UIButton = {
        var configuration = buttonConfiguration
        var favoriteButton = UIButton(type: .custom)
        favoriteButton.configuration = configuration
        favoriteButton.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "heart.fill")
            default:
                button.configuration?.image = UIImage(systemName: "heart")
            }
        }
        favoriteButton.addTarget(self, action: #selector(changeFavoriteStatusOfContacts), for: .touchUpInside)
        return favoriteButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        self.contentView.addSubview(self.avatar)
        self.contentView.addSubview(self.stackViewForLabels)
        self.contentView.addSubview(self.favoriteButton)

        avatar.translatesAutoresizingMaskIntoConstraints = false
        stackViewForLabels.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            avatar.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            avatar.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            avatar.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -10),
            stackViewForLabels.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            stackViewForLabels.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -5),
            stackViewForLabels.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            stackViewForLabels.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            favoriteButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5)
        ])
    }

    @objc func changeFavoriteStatusOfContacts(sender: UIButton) {
        delegate?.changeFavoritesContacts(cell: self)
    }

    func configureCell(model: Contact) {
        self.fullNameLabel.text = model.familyName + " " + model.givenName
        self.phoneNumberLabel.text = model.phoneNumber
        self.avatar.image = UIImage(data: model.thumbnailImageData)
        if model.favorite {
            self.favoriteButton.isSelected = true
        } else {
            self.favoriteButton.isSelected = false
        }
    }
}
