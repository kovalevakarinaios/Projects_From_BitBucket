//
//  CollectionViewCell.swift
//  ATMs
//
//  Created by Karina Kovaleva on 3.01.23.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {

    static let reuseId = "atmCell"

    private let font = UIFont(name: "Helvetica Neue", size: 12)

    private lazy var mainStackView: UIStackView = {
        var mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.alignment = .leading
        mainStackView.spacing = 0
        [self.installPlaceLabel,
         self.workTimeLabel,
         self.currencyLabel].forEach { mainStackView.addArrangedSubview($0) }
        return mainStackView
    }()

    private lazy var installPlaceLabel: UILabel = {
        var installPlaceLabel = UILabel()
        installPlaceLabel.font = font
        installPlaceLabel.numberOfLines = 0
        installPlaceLabel.lineBreakMode = .byWordWrapping
        return installPlaceLabel
    }()

    private lazy var workTimeLabel: UILabel = {
        var workTimeLabel = UILabel()
        workTimeLabel.font = font
        workTimeLabel.numberOfLines = 0
        workTimeLabel.lineBreakMode = .byWordWrapping
        return workTimeLabel
    }()

    private lazy var currencyLabel: UILabel = {
        var currencyLabel = UILabel()
        currencyLabel.font = font
        currencyLabel.numberOfLines = 0
        currencyLabel.lineBreakMode = .byWordWrapping
        return currencyLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGreen
        self.contentView.addSubview(self.mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading).offset(5)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-5)
            make.top.bottom.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }

    public func configureCell(model: ATM) {
        self.installPlaceLabel.text = model.installPlace
        var workTime = model.workTime
        workTime.isEmpty ? workTime = "Режим работы неизвестен" : nil
        self.workTimeLabel.text = workTime
        var currency = model.currency
        currency.isEmpty ? currency = "неизвестно" : nil
        self.currencyLabel.text = "Валюта: " + currency
    }
}
