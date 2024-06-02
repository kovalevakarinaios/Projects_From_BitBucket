//
//  Callout.swift
//  ATMs
//
//  Created by Karina Kovaleva on 6.01.23.
//

import MapKit

protocol CalloutViewDelegate: AnyObject {
    func openDetailViewController(_ id: String, _ type: DataType)
}

class CalloutView: UIView {

    private let annotation: MKAnnotation
    private let fontForTitle = UIFont(name: "Helvetica Neue Bold", size: 16)
    private let font = UIFont(name: "Helvetica Neue", size: 14)

    weak var delegate: CalloutViewDelegate?

    private lazy var mainStackView: UIStackView = {
        var mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .leading
        mainStackView.spacing = 2
        return mainStackView
    }()

    private lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = fontForTitle
        titleLabel.textColor = .systemGreen
        return titleLabel
    }()

    private lazy var firstLabel: UILabel = {
        var firstLabel = UILabel()
        firstLabel.numberOfLines = 0
        firstLabel.font = font
        firstLabel.textColor = .systemGreen
        return firstLabel
    }()

    private lazy var secondLabel: UILabel = {
        var secondLabel = UILabel()
        secondLabel.numberOfLines = 0
        secondLabel.font = font
        secondLabel.textColor = .systemGreen
        return secondLabel
    }()

    private lazy var thirdLabel: UILabel = {
        var thirdLabel = UILabel()
        thirdLabel.numberOfLines = 0
        thirdLabel.font = font
        thirdLabel.textColor = .systemGreen
        return thirdLabel
    }()

    private lazy var fourthLabel: UILabel = {
        var fourthLabel = UILabel()
        fourthLabel.numberOfLines = 0
        fourthLabel.font = font
        fourthLabel.textColor = .systemGreen
        return fourthLabel
    }()

    private lazy var moreButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .medium
        configuration.baseBackgroundColor = .systemGreen
        configuration.title = "Подробнее"
        var moreButton = UIButton(type: .custom)
        moreButton.configuration = configuration
        moreButton.addTarget(self, action: #selector(openDetailViewController), for: .touchUpInside)
        return moreButton
    }()

    init(annotation: MKAnnotation) {
        self.annotation = annotation
        super.init(frame: .zero)
        self.setupLabels(annotation: self.annotation)
        self.addViews()
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        self.addSubview(self.mainStackView)
        [self.titleLabel,
         self.firstLabel,
         self.secondLabel,
         self.thirdLabel,
         self.fourthLabel,
         self.moreButton].forEach { self.mainStackView.addArrangedSubview($0) }
    }

    private func setupConstraints() {
        self.mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupLabels(annotation: MKAnnotation) {
        switch annotation {
        case is AnnotationForAtm:
            guard let annotation = annotation as? AnnotationForAtm else { return }
            self.titleLabel.text = "Банкомат"
            self.firstLabel.text = annotation.installPlace
            var workTime = annotation.workTime
            workTime.isEmpty ? (workTime = "Информация о режиме работы недоступна") : nil
            self.secondLabel.text = workTime
            var currency = annotation.currency
            currency.isEmpty ? (currency = "Информация недоступна") : nil
            self.thirdLabel.text = "Выдаваемая валюта: " + currency
            var cashIn = annotation.cashIn
            cashIn.isEmpty ? (cashIn = "Информация недоступна") : nil
            self.fourthLabel.text = "Наличие купюроприемника: " + cashIn
        case is AnnotationForInfobox:
            guard let annotation = annotation as? AnnotationForInfobox else { return }
            self.titleLabel.text = "Инфокиоск"
            self.firstLabel.text = annotation.installPlace
            var workTime = annotation.workTime
            workTime.isEmpty ? (workTime = "Информация о режиме работы недоступна") : nil
            self.secondLabel.text = workTime
            var currency = annotation.currency
            currency.isEmpty ? (currency = "Информация недоступна") : nil
            self.thirdLabel.text = "Выдаваемая валюта: " + currency
            var cashInExist = annotation.cashInExist
            cashInExist.isEmpty ? (cashInExist = "Информация недоступна") : nil
            self.fourthLabel.text = "Наличие купюроприемника: " + cashInExist
        case is AnnotationForFilial:
            guard let annotation = annotation as? AnnotationForFilial else { return }
            self.titleLabel.text = "Отделение банка"
            self.firstLabel.text = annotation.filialName
            var workTime = annotation.infoWorktime
            workTime.isEmpty ? (workTime = "Информация о режиме работы недоступна") : nil
            self.secondLabel.text = workTime
            var address = annotation.address
            address.isEmpty ? (address = "Информация недоступна") : nil
            self.thirdLabel.text = address
            var phoneInfo = annotation.phoneInfo
            phoneInfo.isEmpty ? (phoneInfo = "Информация недоступна") : nil
            self.fourthLabel.text = "Номер телефона: " + phoneInfo
        default: break
        }
    }

    @objc private func openDetailViewController(_ sender: UIButton) {
        switch annotation {
        case is AnnotationForAtm:
            guard let annotation = annotation as? AnnotationForAtm else { return }
            self.delegate?.openDetailViewController(annotation.id, .atm)
        case is AnnotationForInfobox:
            guard let annotation = annotation as? AnnotationForInfobox else { return }
            self.delegate?.openDetailViewController(String(annotation.id), .infobox)
        case is AnnotationForFilial:
            guard let annotation = annotation as? AnnotationForFilial else { return }
            self.delegate?.openDetailViewController(annotation.id, .filial)
        default: break
        }
    }
}
