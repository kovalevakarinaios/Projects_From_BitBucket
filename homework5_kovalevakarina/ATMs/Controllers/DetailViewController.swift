//
//  DetailViewController.swift
//  ATMs
//
//  Created by Karina Kovaleva on 6.01.23.
//

import UIKit

final class DetailViewController: UIViewController {

    private var atm: ATM?
    private var infobox: Infobox?
    private var filial: Filial?

    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var mainStackView: UIStackView = {
        var mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .leading
        mainStackView.spacing = 5
        return mainStackView
    }()

    private lazy var addressLabel: UILabel = {
        var addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        return addressLabel
    }()

    private lazy var installPlaceLabel: UILabel = {
        var installPlaceLabel = UILabel()
        installPlaceLabel.numberOfLines = 0
        installPlaceLabel.lineBreakMode = .byWordWrapping
        return installPlaceLabel
    }()

    private lazy var installPlaceFullLabel: UILabel = {
        var installPlaceFullLabel = UILabel()
        installPlaceFullLabel.numberOfLines = 0
        installPlaceFullLabel.lineBreakMode = .byWordWrapping
        return installPlaceFullLabel
    }()

    private lazy var workTimeLabel: UILabel = {
        var workTimeLabel = UILabel()
        workTimeLabel.numberOfLines = 0
        workTimeLabel.lineBreakMode = .byWordWrapping
        return workTimeLabel
    }()

    private lazy var typeLabel: UILabel = {
        var typeLabel = UILabel()
        typeLabel.numberOfLines = 0
        typeLabel.lineBreakMode = .byWordWrapping
        return typeLabel
    }()

    private lazy var errorLabel: UILabel = {
        var atmErrorLabel = UILabel()
        atmErrorLabel.numberOfLines = 0
        atmErrorLabel.lineBreakMode = .byWordWrapping
        return atmErrorLabel
    }()

    private lazy var currencyLabel: UILabel = {
        var currencyLabel = UILabel()
        currencyLabel.numberOfLines = 0
        currencyLabel.lineBreakMode = .byWordWrapping
        return currencyLabel
    }()

    private lazy var cashInExistLabel: UILabel = {
        var cashInExistLabel = UILabel()
        cashInExistLabel.numberOfLines = 0
        cashInExistLabel.lineBreakMode = .byWordWrapping
        return cashInExistLabel
    }()

    private lazy var cashInLabel: UILabel = {
        var cashInLabel = UILabel()
        cashInLabel.numberOfLines = 0
        cashInLabel.lineBreakMode = .byWordWrapping
        return cashInLabel
    }()

    private lazy var typeCashInLabel: UILabel = {
        var typeCashInLabel = UILabel()
        typeCashInLabel.numberOfLines = 0
        typeCashInLabel.lineBreakMode = .byWordWrapping
        return typeCashInLabel
    }()

    private lazy var printerLabel: UILabel = {
        var printerLabel = UILabel()
        printerLabel.numberOfLines = 0
        printerLabel.lineBreakMode = .byWordWrapping
        return printerLabel
    }()

    private lazy var regionPlatejLabel: UILabel = {
        var regionPlatejLabel = UILabel()
        regionPlatejLabel.numberOfLines = 0
        regionPlatejLabel.lineBreakMode = .byWordWrapping
        return regionPlatejLabel
    }()

    private lazy var popolneniePlatejLabel: UILabel = {
        var popolneniePlatejLabel = UILabel()
        popolneniePlatejLabel.numberOfLines = 0
        popolneniePlatejLabel.lineBreakMode = .byWordWrapping
        return popolneniePlatejLabel
    }()

    private lazy var provisionOfServicesLabel: UILabel = {
        var provisionOfServicesLabel = UILabel()
        provisionOfServicesLabel.numberOfLines = 0
        provisionOfServicesLabel.lineBreakMode = .byWordWrapping
        return provisionOfServicesLabel
    }()

    private lazy var buildRouteButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .systemGreen
        configuration.title = "Построить маршрут"
        var buildRouteButton = UIButton(type: .custom)
        buildRouteButton.configuration = configuration
        buildRouteButton.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
        return buildRouteButton
    }()

    init(atm: ATM) {
        super.init(nibName: nil, bundle: nil)
        self.atm = atm
        setupLabelsForAtm(atm: atm)
    }

    init(infobox: Infobox) {
        super.init(nibName: nil, bundle: nil)
        self.infobox = infobox
        setupLabelsForInfobox(infobox: infobox)
    }

    init(filial: Filial) {
        self.filial = filial
        super.init(nibName: nil, bundle: nil)
        setupLabelsForFilial(filial: filial)
        setupLabelsForFilialsServices(filial: filial)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addView()
        addConstraints()
    }

    private func createFullAddress(atm: ATM) -> String {
        var area = atm.area
        (area == "Минск") ? (area = "") : (area += " область, ")
        var cityType = atm.cityType
        (cityType.isEmpty) ? (cityType = "") : (cityType += " ")
        var city = atm.city
        (city.isEmpty) ? (city = "") : (city += ", ")
        var addressType = atm.addressType
        (addressType.isEmpty) ? (addressType = "") : (addressType += " ")
        var address = atm.address
        (address.isEmpty) ? (address = "") : (address += ", ")
        let house = atm.house
        let fullAddress = "Адрес установки: " + area + cityType + city + addressType + address + house
        return fullAddress
    }

    private func createFullAddress(infobox: Infobox) -> String {
        var area = infobox.area
        (area == "Минск") ? (area = "") : (area += " область, ")
        var cityType = infobox.cityType
        (cityType.isEmpty) ? (cityType = "") : (cityType += " ")
        var city = infobox.city
        (city.isEmpty) ? (city = "") : (city += ", ")
        var addressType = infobox.addressType
        (addressType.isEmpty) ? (addressType = "") : (addressType += " ")
        var address = infobox.address
        (address.isEmpty) ? (address = "") : (address += ", ")
        let house = infobox.house
        let fullAddress = "Адрес установки: " + area + cityType + city + addressType + address + house
        return fullAddress
    }

    private func createFullAddress(filial: Filial) -> String {
        var nameType = filial.nameType
        (nameType.isEmpty) ? (nameType = "") : (nameType += " ")
        var name = filial.name
        (name.isEmpty) ? (name = "") : (name += ", ")
        var streetType = filial.streetType
        (streetType.isEmpty) ? (streetType = "") : (streetType += " ")
        var street = filial.street
        (street.isEmpty) ? (street = "") : (street += ", ")
        let homeNumber = filial.homeNumber
        let fullAddress = "Адрес: " + nameType + name + streetType + street + homeNumber
        return fullAddress
    }

    private func addView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.mainStackView)
        self.view.addSubview(self.buildRouteButton)
    }

    private func setupLabelsForAtm(atm: ATM) {
        addressLabel.text = createFullAddress(atm: atm)
        var installPlace = atm.installPlace
        installPlace.isEmpty ? (installPlace = "информация отсутствует") : nil
        installPlaceLabel.text = "Место установки: " + installPlace
        var installPlaceFull = atm.installPlaceFull
        installPlaceFull.isEmpty ? (installPlaceFull = "пояснение отсутствует") : nil
        installPlaceFullLabel.text = "Пояснение места установки банкомата: " + installPlaceFull
        var workTime = atm.workTime
        workTime.isEmpty ? (workTime = "информация отсутствует") : nil
        workTimeLabel.text = "Режим работы: " + workTime
        var atmType = atm.atmType
        atmType.isEmpty ? (atmType = "информация отсутствует") : nil
        typeLabel.text = "Тип банкомата: " + atmType
        var atmError = atm.atmError
        atmError.isEmpty ? (atmError = "информация отсутствует") : nil
        errorLabel.text = "Исправность банкомата: " + atmError
        var currency = atm.currency
        currency.isEmpty ? (currency = "информация отсутствует") : nil
        currencyLabel.text = "Выдаваемая валюта: " + currency
        var cashIn = atm.cashIn
        cashIn.isEmpty ? (cashIn = "информация отсутствует") : nil
        cashInExistLabel.text = "Наличие купюроприемника: " + cashIn
        var atmPrinter = atm.atmPrinter
        atmPrinter.isEmpty ? (atmPrinter = "информация отсутствует") : nil
        printerLabel.text = "Возможность печати чека: " + atmPrinter
        [self.addressLabel,
         self.installPlaceLabel,
         self.installPlaceFullLabel,
         self.workTimeLabel,
         self.typeLabel,
         self.errorLabel,
         self.currencyLabel,
         self.cashInExistLabel,
         self.printerLabel].forEach { mainStackView.addArrangedSubview($0) }
    }

    private func setupLabelsForInfobox(infobox: Infobox) {
        addressLabel.text = createFullAddress(infobox: infobox)
        var installPlace = infobox.installPlace
        installPlace.isEmpty ? (installPlace = "информация отсутствует") : nil
        installPlaceLabel.text = "Место установки: " + installPlace
        var locationNameDesc = infobox.locationNameDesc
        locationNameDesc.isEmpty ? (locationNameDesc = "пояснение отсутствует") : nil
        installPlaceFullLabel.text = "Пояснение места установки инфокиоска: " + locationNameDesc
        var workTime = infobox.workTime
        workTime.isEmpty ? (workTime = "информация отсутствует") : nil
        workTimeLabel.text = "Режим работы: " + workTime
        var currency = infobox.currency
        currency.isEmpty ? (currency = "информация отсутствует") : nil
        currencyLabel.text = "Перечень валют с которыми работает инфокиоск: " + currency
        var infoboxType = infobox.infType
        infoboxType.isEmpty ? (infoboxType = "информация отсутствует") : nil
        typeLabel.text = "Тип инфокиоска: " + infoboxType
        var cashInExist = infobox.cashInExist
        cashInExist.isEmpty ? (cashInExist = "информация отсутствует") : nil
        cashInExistLabel.text = "Наличие купюроприемника: " + cashInExist
        var cashIn = infobox.cashIn
        cashIn.isEmpty ? (cashIn = "информация отсутствует") : nil
        cashInLabel.text = "Исправность купюроприемника: " + cashIn
        var typeCashIn = infobox.typeCashIn
        typeCashIn.isEmpty ? (typeCashIn = "информация отсутствует") : nil
        typeCashInLabel.text = "Приёмник пачек банкнот: " + typeCashIn
        var printer = infobox.infPrinter
        printer.isEmpty ? (printer = "информация отсутствует") : nil
        printerLabel.text = "Возможность печати чека: " + printer
        var regionPlatej = infobox.regionPlatej
        regionPlatej.isEmpty ? (regionPlatej = "информация отсутствует") : nil
        regionPlatejLabel.text = "Наличие платежа «Региональные платежи»: " + regionPlatej
        var popolneniePlatej = infobox.popolneniePlatej
        popolneniePlatej.isEmpty ? (popolneniePlatej = "информация отсутствует") : nil
        popolneniePlatejLabel.text = "Наличие платежа «Пополнение картсчета наличными»: " + regionPlatej
        var infStatus = infobox.infStatus
        infStatus.isEmpty ? (infStatus = "информация отсутствует") : nil
        errorLabel.text = "Исправность инфокиоска: " + infStatus
        [self.addressLabel,
         self.installPlaceLabel,
         self.installPlaceFullLabel,
         self.workTimeLabel,
         self.currencyLabel,
         self.typeLabel,
         self.cashInExistLabel,
         self.cashInLabel,
         self.typeCashInLabel,
         self.printerLabel,
         self.regionPlatejLabel,
         self.popolneniePlatejLabel,
         self.errorLabel].forEach { mainStackView.addArrangedSubview($0) }
    }

    private func setupLabelsForFilial(filial: Filial) {
        self.installPlaceLabel.text = filial.filialName
        var infoWorktime = filial.infoWorktime
        infoWorktime.isEmpty ? (infoWorktime = "информация отсутствует") :
        (infoWorktime = infoWorktime.replacingOccurrences(of: "|", with: "\n", options: .literal))
        self.workTimeLabel.text = "Режим работы: " + infoWorktime
        self.addressLabel.text = createFullAddress(filial: filial)
        [self.installPlaceLabel,
         self.workTimeLabel,
         self.addressLabel].forEach { mainStackView.addArrangedSubview($0) }
    }

    private func setupLabelsForFilialsServices(filial: Filial) {
        provisionOfServicesLabel.text = "Перечень услуг:\n" +
        "Брокерское обслуживание юридических лиц: " + serviceInformation(filial.uslBroker) +
        "Покупка мерных слитков драг.металлов: " + serviceInformation(filial.uslBuySlitki) +
        "Получение карточки, оформленной через сайт банка: " +  serviceInformation(filial.uslCardInternet) +
        "Операции с бездокументарными облигациями для юридических лиц: " + serviceInformation(filial.uslCennieBumagi) +
        "Прием на проверку доверенностей и иных документов, оформленных вне банка: " +
        serviceInformation(filial.uslCheckDoverVnebanka) +
        "Операции с чеками «Жилье»: " + serviceInformation(filial.uslChekiGilie) +
        "Операции с чеками «Имущество»: " + serviceInformation(filial.uslChekiImuschestvo) +
        "Клуб «Бархат»: " + serviceInformation(filial.uslClubBarhat) +
        "Клуб «Карт-бланш»: " + serviceInformation(filial.uslClubKartblansh) +
        "Клуб «Леди»: " + serviceInformation(filial.uslClubLedi) +
        "Клуб #настарт: " + serviceInformation(filial.uslClubNastart) +
        "Клуб «Персона»: " + serviceInformation(filial.uslClubPersona) +
        "Клуб «Шчодры»: " + serviceInformation(filial.uslClubSchodry) +
        "Клуб «СВОИ»: " + serviceInformation(filial.uslClubSvoi) +
        "Клуб «Зебра»: " + serviceInformation(filial.uslClubZclass) +
        "Валютно-обменные операции с монетами иностранных государств: " + serviceInformation(filial.uslCoinsExchange) +
        "Депозитарное обслуживание: " + serviceInformation(filial.uslDepositariy) +
        "Интернет-депозиты (оформление доверенностей, завещательных распоряжений): " +
        serviceInformation(filial.uslDepDoverennosti) +
        "Депозитные счета «Семейный капитал»: " + serviceInformation(filial.uslDepScheta) +
        "Интернет-депозиты (выплата наследникам, доверенным лицам): " + serviceInformation(filial.uslDepViplati) +
        "Операции с документарными облигациями ОАО «АСБ Беларусбанк»: " +
        serviceInformation(filial.uslDocObligacBelarusbank) +
        "Доверительное управление денежными средствами: " + serviceInformation(filial.uslDoverUpr) +
        "Доверительное управление ценными бумагами (для госслужащих): " + serviceInformation(filial.uslDoverUprGos) +
        "Продажа мерных слитков драг.металлов: " + serviceInformation(filial.uslDragMetal) +
        "Подключение услуг М-банкинг, Интернет-банкинг, отказ от исполнения договора на услугу Интернет-банкинг: " +
        serviceInformation(filial.uslIbank) +
        "Прием на инкассо денежных знаков РБ: " + serviceInformation(filial.uslInkassoPriem) +
        "Операции с денежными знаками РБ (обмен поврежденных (ветхих); размен): " +
        serviceInformation(filial.uslInkassoPriemDenegBel) +
        "Оформление международных банковских платежных карточек: " + serviceInformation(filial.uslIntCards) +
        """
        Операции по специальным избирательным счетам (пополнение,
        выдача денежных средств, закрытие, изменение данных владельца счета):
        """
        + serviceInformation(filial.uslIzbizSchetaOperacii) +
        "Открытие специальных избирательных счетов: " + serviceInformation(filial.uslIzbizSchetaOtkr) +
        "Продажа аттестованных бриллиантов: " + serviceInformation(filial.uslKamniBrill) +
        "Конверсия иностранной валюты: " + serviceInformation(filial.uslKonversiyaForeignVal) +
        "Реализация лотерейных билетов и выплата выигрышей по ним: " + serviceInformation(filial.uslLoterei) +
        "Оформление и выдача неперсонализированных карточек личному составу МО РБ: " +
        serviceInformation(filial.uslMoRb) +
        "Операции с бездокументарными облигациями ОАО «АСБ Беларусбанк» для физических лиц: " +
        serviceInformation(filial.uslOperationsBezdokumentarObligacii) +
        "Операции со сберегательными сертификатами ОАО «АСБ Беларусбанк»: " +
        serviceInformation(filial.uslOperationsSberSertif) +
        """
        Операции по счетам, открытым в РУП «Белпочта» (оформление регистрация доверенностей;
        регистрация представителей, наследников; изменение данных владельца счета):
        """ +
        serviceInformation(filial.uslOperPoSchOtkrVRup) +
        "Перечисление (перевод) по реквизитам карточки на счет, к которому оформлена карточка ОАО «АСБ Беларусбанк»: " +
        serviceInformation(filial.uslPerechisleniePoRekvizitamKartochki) +
        "Перечисление (перевод) со счета клиента без использования карточки: " +
        serviceInformation(filial.uslPerechislenieSoSchetaBezKart) +
        "Прием платежей от физ.лиц.: " + serviceInformation(filial.uslPlategi) +
        "Проверка подлинности банкнот по заявлению физического лица: " +
        serviceInformation(filial.uslPodlinnostBanknot) +
        "Погашение документарных облигаций Минфина РБ: " +
        serviceInformation(filial.uslPogashenieDocumentarObligacii) +
        "Пополнение счета клиента без использования карточки: " +
        serviceInformation(filial.uslPopolnenieSchetaBezKart) +
        "Пополнение счета наличными белорусскими рублями с использованием карточки: " +
        serviceInformation(filial.uslPopolnenieSchetaBynISPKarts) +
        "Пополнение счета наличной иностранной валютой с использованием карточки: " +
        serviceInformation(filial.uslPopolnenieSchetaUsdISPKarts) +
        "Валютно-обменные операции (покупка, продажа иностранной валюты): " + serviceInformation(filial.uslPov) +
        "Прием документов от физических лиц на брокерское обслуживание: " +
        serviceInformation(filial.uslPriemDocPokupkaObl) +
        "Прием ценностей на открытое банковское хранение: " + serviceInformation(filial.uslPriemCennosteiNaHranenie) +
        "Прием ценностей на хранение от уполномоченных органов: " +
        serviceInformation(filial.uslPriemCennostejNaHranenie) +
        "Прием документов от физических лиц для выполнения депозитарных операций: " +
        serviceInformation(filial.uslPriemDocsFLDepozitOperations) +
        "Прием документов, выдача и сопровождение ипотечных и льготных кредитов: " +
        serviceInformation(filial.uslPriemDocsVidachaSoprLgotIpotech) +
        "Прием документов и выдача кредитов на потребительские нужды (овердрафты): " +
        serviceInformation(filial.uslPriemDocNaKreditsOverdrafts) +
        "Предоставление консультаций по вопросам оказания лизинговых услуг ООО «АСБ Лизинг»: " +
        serviceInformation(filial.uslPriemDocNaLizing) +
        """
        Прием от физических лиц-взыскателей платежных требований
        на списание денежных средств со счета плательщика в бесспорном порядке:
        """ +
        serviceInformation(filial.uslPriemInkasso) +
        "Прием облигации Минфина РБ для направления на экспертизу: " + serviceInformation(filial.uslPriemOblMF) +
        "Прием платежей и взносов в бел.руб. от юр.лиц и ИП: " + serviceInformation(filial.uslPriemPlatejeiBynIP) +
        "Прием платежей и взносов в ин.вал. от юр.лиц и ИП: " + serviceInformation(filial.uslPriemPlatejeiEurIP) +
        """
        Прием страховых взносов и платежей от страховых агентов
        в иностранной валюте с монетами иностранных государств:
        """ +
        serviceInformation(filial.uslPriemVznosovInostrValOtStraxAgentov) +
        "Прием заявлений, связанных с обслуживанием держателей карточек: " +
        serviceInformation(filial.uslPriemZayvleniyObsluzhivanie) +
        "Продажа памятных, слитковых (инвестиционных) монет: " + serviceInformation(filial.uslProdagaMonet) +
        "Размен, замена иностранной валюты: " + serviceInformation(filial.uslRazmenForeignVal) +
        "Оформление банковских платежных карточек для использования на территории РБ: " +
        serviceInformation(filial.uslRbCard) +
        "Регистрация (сопровождение) валютных договоров физических лиц на веб-портале НБ РБ: " +
        serviceInformation(filial.uslRegistrationValDogovor) +
        "Выдача наличных белорусских рублей с использованием карточки: " +
        serviceInformation(filial.uslReturnBynISPKarts) +
        "Выдача наличной иностранной валюты с использованием карточки: " +
        serviceInformation(filial.uslReturnUsdISPKarts) +
        "Расчетно-кассовое обслуживание юр. лиц и ИП: " + serviceInformation(filial.uslRko) +
        "Предоставление депозитного сейфа во временное пользование клиентам: " + serviceInformation(filial.uslSeif) +
        "Сопровождение кредитов (овердрафтов), в том числе по карте «Магнит»:" +
        serviceInformation(filial.uslSoprovKreditVTomChisleMagnit) +
        "Страхование гражданской ответственности владельцев транспортных средств: " +
        serviceInformation(filial.uslStrahovanieAvto) +
        "Страхование гражд.ответственности владельцев транспортных средств погран.страхование: " +
        serviceInformation(filial.uslStrahovanieAvtoPogran) +
        "Страхование от несчастных случаев «С заботой о детях»: " + serviceInformation(filial.uslStrahovanieDetei) +
        "Добровольное страхование рисков вкладчиков по программе «Доход под защитой»: " +
        serviceInformation(filial.uslStrahovanieDohodPodZaschitoy) +
        "Добровольное страхование от травм «Экспресс»: " + serviceInformation(filial.uslStrahovanieExpress) +
        "Добровольное комплексное страхование банковских счетов по программе «Финансы под защитой»: " +
        serviceInformation(filial.uslStrahovanieFinansPodZaschitoy) +
        "Страхование гражд.ответственности владельцев транспортных средств «Зеленая карта»: " +
        serviceInformation(filial.uslStrahovanieGreenKarta) +
        "Добровольное комплексное страхование домовладений и гражданской ответственности его пользователей: " +
        serviceInformation(filial.uslStrahovanieHome) +
        "Добровольное страхование банковских платежных карточек по программе «С картой под защитой»: " +
        serviceInformation(filial.uslStrahovanieKartochki) +
        "Добровольное страхование транспортных средств граждан: " +
        serviceInformation(filial.uslStrahovanieKasko) +
        "Добровольное комплексное страхование имущества и гражданской ответственности его пользователей: " +
        serviceInformation(filial.uslStrahovanieKomplex) +
        "Медицинское страхование для нерезидентов: " + serviceInformation(filial.uslStrahovanieMedicineNerezident) +
        "Добровольное страхование водителей и пассажиров от несчастных случаев: " +
        serviceInformation(filial.uslStrahovaniePerevozki) +
        "Добровольное страхование от несчастных случаев и заболеваний «С заботой о близких»: " +
        serviceInformation(filial.uslStrahovanieSZabotoiOBlizkih) +
        "Страхование от болезней и несчастных случаев во время поездки за границу: " +
        serviceInformation(filial.uslStrahovanieTimeAbroad) +
        "Страхование медицинских расходов по программе «Защита от клеща»: " +
        serviceInformation(filial.uslStrahovanieZashhitaOtKleshha) +
        "Получение страхового полиса по заявке, оформленной через сайт банка: " +
        serviceInformation(filial.uslStrahovkaSite) +
        "Система строительных сбережений (сопровождение действующих договоров данного подразделения): " +
        serviceInformation(filial.uslStroysber) +
        """
        Система строительных сбережений (заключение новых и сопровождение
        действующих договоров данного подразделения):
        """ +
        serviceInformation(filial.uslStroysberNew) +
        "Специальные счета «Субсидия»: " + serviceInformation(filial.uslSubsidiyaScheta) +
        "Международные банковские переводы: " + serviceInformation(filial.uslSwift) +
        "Выдача справок (информации) по кредитам (овердрафтам): " +
        serviceInformation(filial.uslVidachSpravokPoKreditOverdr) +
        "Выплата возмещения по инкассо: " + serviceInformation(filial.uslViplataVozmPoIncasso) +
        "Вклады (депозиты) для физ.лиц: " + serviceInformation(filial.uslVklad) +
        "Возврат НДС иностранным гражданам с товаров, купленных в Республике Беларусь (TaxFree): " +
        serviceInformation(filial.uslVozvratNDS) +
        "Выдача наличных денежных средств без использования карточки: " +
        serviceInformation(filial.uslVydachaNalVBanke) +
        "Выдача выписки по счету, к которому оформлена карточка: " + serviceInformation(filial.uslVydachaVypiski) +
        "Выплата денежных средств в белорусских рублях, поступивших в пользу физических лиц без открытия счета: " +
        serviceInformation(filial.uslVypllataBelRub) +
        "Выдача задержанных (изъятых, утерянных) карточек: " + serviceInformation(filial.uslVzk) +
        "Подразделение принимает все виды платежей: " + serviceInformation(filial.uslPlategiAll) +
        "Подразделение принимает платежи в иностранной валюте: " + serviceInformation(filial.uslPlategiInForeignVal) +
        """
        Подразделение принимает платежи только за проезд по платным автодорогам,
        за административные правонарушения и платежи в пользу банка:
        """ + serviceInformation(filial.uslPlategiZaProezdVPolzuBanka) +
        "Платежи за мобильную связь наличными денежными средствами через кассы отделения не принимаются: " +
        serviceInformation(filial.uslPlategiMinusMobi) +
        "Подразделение принимает все виды платежей, за исключением платежей за интернет: " +
        serviceInformation(filial.uslPlategiMinusInternet) +
        "Подразделение принимает все виды платежей, за исключением платежей за мобильную связь и интернет: " +
        serviceInformation(filial.uslPlategiMinusMobiInternetFull) +
        "Подразделение принимает платежи только в пользу банка (кредиты, вознаграждение): " +
        serviceInformation(filial.uslPlategiNalMinusKromeKredit)
        self.mainStackView.addArrangedSubview(self.provisionOfServicesLabel)
    }

    private func serviceInformation(_ service: String) -> String {
        var infoAboutService: String
        if service == "0" {
            infoAboutService = "нет\n"
        } else {
            infoAboutService = "да\n"
        }
        return infoAboutService
    }

    private func addConstraints() {
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(5)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-5)
            make.bottom.equalTo(self.buildRouteButton.snp.top)
        }
        self.mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.buildRouteButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
    }

    @objc private func openMaps() {
        var gpsX: String?
        var gpsY: String?
        if let atm = atm {
            gpsX = atm.gpsX
            gpsY = atm.gpsY
        } else if let infobox = infobox {
            gpsX = infobox.gpsX
            gpsY = infobox.gpsY
        } else if let filial = filial {
            gpsX = filial.gpsX
            gpsY = filial.gpsY
        }
        guard let gpsX = gpsX else { return }
        guard let gpsY = gpsY else { return }
        let alert = UIAlertController(title: "Построить маршрут",
                                      message: "Выберите приложение для построения маршрута",
                                      preferredStyle: .actionSheet)
        if let mapsAppleURL = URL(string: "maps://?saddr=Current%20Location&daddr=\(gpsX),\(gpsY)"
        ), UIApplication.shared.canOpenURL(mapsAppleURL) {
            alert.addAction(UIAlertAction(title: "Apple Maps", style: .default) { _ in
                UIApplication.shared.open(mapsAppleURL)
            })
        }
        if let mapsGoogleURL = URL(string:
                                """
                                comgooglemaps://?saddr=&daddr=\(gpsX),\(gpsY)
                                """
        ), UIApplication.shared.canOpenURL(mapsGoogleURL) {
            alert.addAction(UIAlertAction(title: "Google Maps", style: .default) { _ in
                UIApplication.shared.open(mapsGoogleURL)
            })
        }
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
        self.present(alert, animated: true)
    }
}
