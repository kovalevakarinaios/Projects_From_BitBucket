//
//  FilterViewController.swift
//  ATMs
//
//  Created by Karina Kovaleva on 13.01.23.
//

import UIKit

class FilterViewController: UIViewController {

    private let fontForTitle = UIFont(name: "Helvetica Neue Bold", size: 16)
    private let font = UIFont(name: "Helvetica Neue", size: 14)

    private lazy var descriptionLabel: UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.text = "Выберите необходимые Вам типы даннных для отображения"
        descriptionLabel.font = fontForTitle
        descriptionLabel.textColor = .systemGreen
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        return descriptionLabel
    }()

    private lazy var mainStackView: UIStackView = {
        var stackViewForLabels = UIStackView()
        stackViewForLabels.axis = .horizontal
        stackViewForLabels.distribution = .equalSpacing
        stackViewForLabels.spacing = 5
        return stackViewForLabels
    }()

    private lazy var stackViewForLabels: UIStackView = {
        var stackViewForLabels = UIStackView()
        stackViewForLabels.axis = .vertical
        stackViewForLabels.distribution = .equalSpacing
        stackViewForButtons.alignment = .center
        stackViewForLabels.spacing = 5
        return stackViewForLabels
    }()

    private lazy var atmsLabel: UILabel = {
        var atmsLabel = UILabel()
        atmsLabel.text = "Банкоматы"
        atmsLabel.font = font
        atmsLabel.textColor = .systemGreen
        return atmsLabel
    }()

    private lazy var infoboxesLabel: UILabel = {
        var infoboxesLabel = UILabel()
        infoboxesLabel.text = "Инфокиоски"
        infoboxesLabel.font = font
        infoboxesLabel.textColor = .systemGreen
        return infoboxesLabel
    }()

    private lazy var filialsLabel: UILabel = {
        var infoboxesLabel = UILabel()
        infoboxesLabel.text = "Отделения"
        infoboxesLabel.font = font
        infoboxesLabel.textColor = .systemGreen
        return infoboxesLabel
    }()

    private lazy var stackViewForButtons: UIStackView = {
        var stackViewForButtons = UIStackView()
        stackViewForButtons.axis = .vertical
        stackViewForButtons.distribution = .equalSpacing
        stackViewForButtons.spacing = 5
        return stackViewForButtons
    }()

    private lazy var configuration: UIButton.Configuration = {
        var config = UIButton.Configuration.filled()
        config.buttonSize = .medium
        config.baseBackgroundColor = .systemGreen
        config.imagePlacement = .all
        return config
    }()

    private lazy var atmsIncluded: UIButton = {
        var configuration = configuration
        var atmsIncluded = UIButton()
        atmsIncluded.configuration = configuration
        atmsIncluded.isSelected = true
        atmsIncluded.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "checkmark.square")
            default:
                button.configuration?.image = UIImage(systemName: "square")
            }
        }
        atmsIncluded.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return atmsIncluded
    }()

    private lazy var infoboxesIncluded: UIButton = {
        var configuration = configuration
        var infoboxesIncluded = UIButton()
        infoboxesIncluded.configuration = configuration
        infoboxesIncluded.isSelected = true
        infoboxesIncluded.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "checkmark.square")
            default:
                button.configuration?.image = UIImage(systemName: "square")
            }
        }
        infoboxesIncluded.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return infoboxesIncluded
    }()

    private lazy var filialsIncluded: UIButton = {
        var configuration = configuration
        var filialsIncluded = UIButton()
        filialsIncluded.configuration = configuration
        filialsIncluded.isSelected = true
        filialsIncluded.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "checkmark.square")
            default:
                button.configuration?.image = UIImage(systemName: "square")
            }
        }
        filialsIncluded.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return filialsIncluded
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.addViews()
        self.setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NameNotification.filter.notification,
                                        object: nil,
                                        userInfo: ["Filter": [self.atmsIncluded.isSelected,
                                                              self.infoboxesIncluded.isSelected,
                                                              self.filialsIncluded.isSelected]])
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }

    private func addViews() {
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.mainStackView)
        [self.stackViewForLabels,
         self.stackViewForButtons].forEach { self.mainStackView.addArrangedSubview($0) }
        [self.atmsLabel,
         self.infoboxesLabel,
         self.filialsLabel].forEach { self.stackViewForLabels.addArrangedSubview($0) }
        [self.atmsIncluded,
         self.infoboxesIncluded,
         self.filialsIncluded].forEach { self.stackViewForButtons.addArrangedSubview($0) }
    }

    private func setupConstraints() {
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalTo(self.stackViewForButtons.snp.top).offset(-20)
            make.left.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        self.mainStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
    }
}
