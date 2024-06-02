//
//  ViewController.swift
//  HomeWork1_KovalevaKarina
//
//  Created by Karina Kovaleva on 11.12.22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var languageList = ["English", "Русский", "Беларуская"]
    
    private lazy var stackViewForModeButtons: UIStackView = {
        var stackViewForModeButtons = UIStackView()
        stackViewForModeButtons.axis = .horizontal
        stackViewForModeButtons.distribution = .fillEqually
        stackViewForModeButtons.alignment = .fill
        stackViewForModeButtons.spacing = 5
        [self.autoModeButton, self.lightModeButton, self.darkModeButton].forEach { stackViewForModeButtons.addArrangedSubview($0) }
        return stackViewForModeButtons
    }()
    
    private var configuration: UIButton.Configuration = {
        var config = UIButton.Configuration.tinted()
        config.buttonSize = .mini
        config.baseBackgroundColor = .systemMint
        config.imagePadding = 3
        config.imagePlacement = .trailing
        return config
    }()
    
    private var selectedButton = 0
    
    private var buttons: [UIButton?] = []
    
    private lazy var autoModeButton: UIButton = {
        var configuration = configuration
        configuration.title = "Auto mode"

        var autoModeButton = UIButton(type: .custom)
        autoModeButton.configuration = configuration
        
        autoModeButton.tag = 0
        
        buttons.append(autoModeButton)
        autoModeButton.addTarget(self, action: #selector(touch), for: .touchUpInside)
        return autoModeButton
    }()
    
    private lazy var lightModeButton: UIButton = {
        var configuration = configuration
        configuration.title = "Light mode"

        var lightModeButton = UIButton(type: .custom)
        lightModeButton.configuration = configuration
        
        lightModeButton.tag = 1
        buttons.append(lightModeButton)
        
        lightModeButton.configurationUpdateHandler = { [weak self] button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "sun.max.fill")
            default:
                button.configuration?.image = UIImage(systemName: "sun.max")
            }
        }
        lightModeButton.addTarget(self, action: #selector(touch), for: .touchUpInside)
        return lightModeButton
    }()
    
    private lazy var darkModeButton: UIButton = {
        var configuration = configuration
        configuration.title = "Dark mode"

        var darkModeButton = UIButton(type: .custom)
        darkModeButton.configuration = configuration
        
        darkModeButton.tag = 2
        buttons.append(darkModeButton)
        
        darkModeButton.configurationUpdateHandler = { [weak self] button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "moon.fill")
            default:
                button.configuration?.image = UIImage(systemName: "moon")
            }
        }
        darkModeButton.addTarget(self, action: #selector(touch), for: .touchUpInside)
        return darkModeButton
    }()
    
    private lazy var stackViewForLogoAndLabel: UIStackView = {
        var stackViewForLogoAndLabel = UIStackView()
        stackViewForLogoAndLabel.axis = .horizontal
        stackViewForLogoAndLabel.distribution = .fillProportionally
        stackViewForLogoAndLabel.alignment = .fill
        stackViewForLogoAndLabel.spacing = 5
        [self.logoImageView, self.greetingsLabel].forEach { stackViewForLogoAndLabel.addArrangedSubview($0) }
        return stackViewForLogoAndLabel
    }()
    
    private var logoImageView: UIImageView = {
        var logoImageView = UIImageView(image: UIImage(named: "spa"))
        return logoImageView
    }()
    
    private var greetingsLabel: UILabel = {
        var greetingsLabel = UILabel()
        greetingsLabel.text = "Hello"
        greetingsLabel.textColor = .systemBlue
        greetingsLabel.textAlignment = .center
        greetingsLabel.font = UIFont.systemFont(ofSize: 40)
        return greetingsLabel
    }()
    
    private lazy var languagePickerView: UIPickerView = {
        var languagePickerView = UIPickerView()
        return languagePickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupUI()
        languagePickerView.dataSource = self
        languagePickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttons[selectedButton]?.isSelected = true
    }
    
    @objc func touch(sender: UIButton) -> Void {
        let tag = sender.tag
        buttons[selectedButton]?.isSelected = false
        buttons[tag]?.isSelected = true
        selectedButton = tag
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        switch tag {
        case 0:
            window?.overrideUserInterfaceStyle = .unspecified
        case 1:
            window?.overrideUserInterfaceStyle = .light
        case 2:
            window?.overrideUserInterfaceStyle = .dark
        default:
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    private func setupUI() -> Void {
        self.view.addSubview(stackViewForModeButtons)
        self.view.addSubview(stackViewForLogoAndLabel)
        self.view.addSubview(languagePickerView)
        
        stackViewForModeButtons.translatesAutoresizingMaskIntoConstraints = false
        stackViewForLogoAndLabel.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        languagePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackViewForModeButtons.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            stackViewForModeButtons.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            stackViewForModeButtons.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            stackViewForLogoAndLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackViewForLogoAndLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackViewForLogoAndLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            stackViewForLogoAndLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            stackViewForLogoAndLabel.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalTo: stackViewForLogoAndLabel.heightAnchor),
            languagePickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            languagePickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            languagePickerView.topAnchor.constraint(equalTo: stackViewForLogoAndLabel.bottomAnchor, constant: 5)
        ])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        languageList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        languageList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if languageList[row] == "English" {
            changeLanguage(lang: "en")
        } else if languageList[row] == "Русский" {
            changeLanguage(lang: "ru")
        } else if languageList[row] == "Беларуская" {
            changeLanguage(lang: "be")
        }
    }
    
    private func changeLanguage(lang: String) {
        greetingsLabel.text = "greeting".localizeString(string: lang)
        darkModeButton.configuration?.title = "darkMode".localizeString(string: lang)
        lightModeButton.configuration?.title = "lightMode".localizeString(string: lang)
        autoModeButton.configuration?.title = "autoMode".localizeString(string: lang)
    }
}
