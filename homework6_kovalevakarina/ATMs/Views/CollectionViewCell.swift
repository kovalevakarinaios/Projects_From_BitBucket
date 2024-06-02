//
//  CollectionViewCell.swift
//  ATMs
//
//  Created by Karina Kovaleva on 3.01.23.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {

    static let reuseId = "atmCell"

    private let fontForTitle = UIFont(name: "Helvetica Neue Bold", size: 14)
    private let font = UIFont(name: "Helvetica Neue", size: 12)

    var cellViewModel: CellModel? {
        didSet {
            switch cellViewModel?.type {
            case .atm:
                self.title.text = "Банкомат"
                self.firstLabel.text = self.cellViewModel?.installPlace
                guard var workTime = self.cellViewModel?.workTime else { return }
                workTime.isEmpty ? workTime = "Режим работы неизвестен" : nil
                self.secondLabel.text = workTime
                guard var currency = self.cellViewModel?.currency else { return }
                currency.isEmpty ? currency = "неизвестно" : nil
                self.thirdLabel.text = "Валюта: " + currency
            case .infobox:
                self.title.text = "Инфокиоск"
                self.firstLabel.text = self.cellViewModel?.installPlace
                guard var workTime = self.cellViewModel?.workTime else { return }
                workTime.isEmpty ? workTime = "Режим работы неизвестен" : nil
                self.secondLabel.text = workTime
                guard var currency = self.cellViewModel?.currency else { return }
                currency.isEmpty ? currency = "неизвестно" : nil
                self.thirdLabel.text = "Валюта: " + currency
            case .filial:
                self.title.text = "Отделение"
                self.firstLabel.text = self.cellViewModel?.filialName
                self.secondLabel.text = self.cellViewModel?.infoWorktime
                self.thirdLabel.text = self.cellViewModel?.phoneInfo
            case .none:
                break
            }
        }
    }

    private lazy var mainStackView: UIStackView = {
        var mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.alignment = .leading
        mainStackView.spacing = 0
        return mainStackView
    }()

    private lazy var title: UILabel = {
        var title = UILabel()
        title.font = fontForTitle
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        return title
    }()

    private lazy var firstLabel: UILabel = {
        var firstLabel = UILabel()
        firstLabel.font = font
        firstLabel.numberOfLines = 0
        firstLabel.lineBreakMode = .byWordWrapping
        return firstLabel
    }()

    private lazy var secondLabel: UILabel = {
        var secondLabel = UILabel()
        secondLabel.font = font
        secondLabel.numberOfLines = 0
        secondLabel.lineBreakMode = .byWordWrapping
        return secondLabel
    }()

    private lazy var thirdLabel: UILabel = {
        var thirdLabel = UILabel()
        thirdLabel.font = font
        thirdLabel.numberOfLines = 0
        thirdLabel.lineBreakMode = .byWordWrapping
        return thirdLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGreen
        self.addViews()
        self.setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }

    private func addViews() {
        self.contentView.addSubview(self.mainStackView)
        [self.title,
         self.firstLabel,
         self.secondLabel,
         self.thirdLabel].forEach { self.mainStackView.addArrangedSubview($0) }
    }

    private func setupConstraints() {
        self.mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading).offset(5)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-5)
            make.top.equalTo(self.contentView.snp.top).offset(2)
            make.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).offset(-2)
        }
    }
}
