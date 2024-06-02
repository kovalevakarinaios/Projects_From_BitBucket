//
//  ProfileTableViewCell.swift
//  HomeWork2_KovalevaKarina
//
//  Created by Karina Kovaleva on 18.12.22.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    let sideAvatar: CGFloat = 40
    
    lazy var avatar: ProfileImageView = {
        var avatar = ProfileImageView()
        return avatar
    }()
    
    private lazy var stackViewForLabels: UIStackView = {
        var stackViewForLabels = UIStackView()
        stackViewForLabels.axis = .vertical
        stackViewForLabels.distribution = .fillProportionally
        stackViewForLabels.alignment = .leading
        stackViewForLabels.spacing = 2
        [self.titleLabel, self.descriptionLabel].forEach { stackViewForLabels.addArrangedSubview($0) }
        return stackViewForLabels
    }()
    
    lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.textColor = .darkGray
        return titleLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.textColor = .lightGray
        return descriptionLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    private func setupCell() {
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(stackViewForLabels)

        avatar.translatesAutoresizingMaskIntoConstraints = false
        stackViewForLabels.translatesAutoresizingMaskIntoConstraints = false

        let bottomConstraint = stackViewForLabels.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        // MARK: Программно задаю приоритет нижнему констрейнту для stackView, чтобы не возникало конфликта при удалении ячейки
        bottomConstraint.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            avatar.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            avatar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            avatar.heightAnchor.constraint(equalToConstant: sideAvatar),
            avatar.widthAnchor.constraint(equalToConstant: sideAvatar),
            stackViewForLabels.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            stackViewForLabels.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            bottomConstraint,
            stackViewForLabels.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

