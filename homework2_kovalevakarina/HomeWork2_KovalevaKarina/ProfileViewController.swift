//
//  ProfileViewController.swift
//  HomeWork2_KovalevaKarina
//
//  Created by Karina Kovaleva on 18.12.22.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var profile: InfoForTableView
    
    var sideAvatar: CGFloat
    
    private lazy var profileImageView: ProfileImageView = {
        var imageView = ProfileImageView()
        return imageView
    }()
    
    private lazy var stackViewForLabels: UIStackView = {
        var stackViewForLabels = UIStackView()
        stackViewForLabels.axis = .vertical
        stackViewForLabels.distribution = .fillProportionally
        stackViewForLabels.alignment = .leading
        stackViewForLabels.spacing = 5
        [self.titleLabel, self.descriptionLabel].forEach { stackViewForLabels.addArrangedSubview($0) }
        return stackViewForLabels
    }()
    
    private lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.textColor = .darkGray
        return titleLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.textColor = .lightGray
        return descriptionLabel
    }()
    
    init(profile: InfoForTableView, sideAvatar: CGFloat) {
        self.profile = profile
        self.sideAvatar = sideAvatar
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoForProfile()
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        
        self.view.addSubview(profileImageView)
        self.view.addSubview(stackViewForLabels)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        stackViewForLabels.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: sideAvatar * 2),
            profileImageView.heightAnchor.constraint(equalToConstant: sideAvatar * 2),
            stackViewForLabels.topAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            stackViewForLabels.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            stackViewForLabels.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
    }
    
    private func getInfoForProfile() {
        guard let image = profile.imageName else { return }
        profileImageView.image = UIImage(named: "\(image)")
        titleLabel.text = profile.title
        descriptionLabel.text = profile.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

