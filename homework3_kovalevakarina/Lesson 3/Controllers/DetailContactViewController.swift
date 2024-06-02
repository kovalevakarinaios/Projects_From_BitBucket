//
//  DetailContactViewController.swift
//  Lesson 3
//
//  Created by Karina Kovaleva on 21.12.22.
//

import UIKit

class DetailContactViewController: UIViewController {

    private var finalContacts = Storage.retrieve("contacts.json", from: .documents, as: [Contact].self)

    private var numberOfContact: Int

    private lazy var profileImageView: CircleImageView = {
        var imageView = CircleImageView()
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.text = String(localized: "name")
        return nameLabel
    }()

    private lazy var surnameLabel: UILabel = {
        var surnameLabel = UILabel()
        surnameLabel.text = String(localized: "surname")
        return surnameLabel
    }()

    private lazy var phoneNumberLabel: UILabel = {
        var phoneNumberLabel = UILabel()
        phoneNumberLabel.text = String(localized: "phoneNumber")
        return phoneNumberLabel
    }()

    private lazy var nameTextField: UITextField = {
        var nameTextField = UITextField()
        nameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        nameTextField.placeholder = String(localized: "name")
        nameTextField.isUserInteractionEnabled = false
        nameTextField.tag = 0
        return nameTextField
    }()

    private lazy var surnameTextField: UITextField = {
        var surnameTextField = UITextField()
        surnameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        surnameTextField.placeholder = String(localized: "surname")
        surnameTextField.isUserInteractionEnabled = false
        surnameTextField.tag = 1
        return surnameTextField
    }()

    private lazy var phoneNumberTextField: UITextField = {
        var phoneNumberTextField = UITextField()
        phoneNumberTextField.borderStyle = UITextField.BorderStyle.roundedRect
        phoneNumberTextField.isUserInteractionEnabled = false
        phoneNumberTextField.placeholder = String(localized: "phoneNumber")
        phoneNumberTextField.tag = 2
        return phoneNumberTextField
    }()

    private lazy var stackViewForNameAndSurnameLabels: UIStackView = {
        var stackViewForNameAndSurnameLabels = UIStackView()
        stackViewForNameAndSurnameLabels.axis = .horizontal
        stackViewForNameAndSurnameLabels.distribution = .fillEqually
        stackViewForNameAndSurnameLabels.alignment = .fill
        stackViewForNameAndSurnameLabels.spacing = 5
        [self.nameLabel,
         self.surnameLabel].forEach { stackViewForNameAndSurnameLabels.addArrangedSubview($0) }
        return stackViewForNameAndSurnameLabels
    }()

    private lazy var stackViewForNameAndSurnameTextFields: UIStackView = {
        var stackViewForNameAndSurnameTextFields = UIStackView()
        stackViewForNameAndSurnameTextFields.axis = .horizontal
        stackViewForNameAndSurnameTextFields.distribution = .fillEqually
        stackViewForNameAndSurnameTextFields.alignment = .fill
        stackViewForNameAndSurnameTextFields.spacing = 5
        [self.nameTextField,
         self.surnameTextField].forEach { stackViewForNameAndSurnameTextFields.addArrangedSubview($0) }
        return stackViewForNameAndSurnameTextFields
    }()

    private lazy var mainStackView: UIStackView = {
        var mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .fill
        mainStackView.spacing = 5
        [self.stackViewForNameAndSurnameLabels,
         self.stackViewForNameAndSurnameTextFields,
         self.phoneNumberLabel,
         self.phoneNumberTextField].forEach { mainStackView.addArrangedSubview($0) }
        return mainStackView
    }()

    init(numberOfContact: Int) {
        self.numberOfContact = numberOfContact
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getInfoForProfile()
        setupUI()
        notificationForKeyboard()

        nameTextField.delegate = self
        surnameTextField.delegate = self
        phoneNumberTextField.delegate = self
    }

    private func setupUI() {
        self.view.backgroundColor = .systemBackground

        self.view.addSubview(self.profileImageView)
        self.view.addSubview(self.mainStackView)

        self.navigationItem.rightBarButtonItem = self.editButtonItem

        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            profileImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            mainStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
    }

    private func getInfoForProfile() {
        let contact = finalContacts[numberOfContact]
        let image = contact.thumbnailImageData
        profileImageView.image = UIImage(data: image)
        nameTextField.text = contact.givenName
        surnameTextField.text = contact.familyName
        phoneNumberTextField.text = contact.phoneNumber
    }

    override func setEditing (_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            nameTextField.isUserInteractionEnabled = true
            surnameTextField.isUserInteractionEnabled = true
            phoneNumberTextField.isUserInteractionEnabled = true
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.editButtonItem.title = String(localized: "save")
        } else {
            nameTextField.isUserInteractionEnabled = false
            surnameTextField.isUserInteractionEnabled = false
            phoneNumberTextField.isUserInteractionEnabled = false
            saveData()
            self.navigationItem.setHidesBackButton(false, animated: true)
        }
    }

    private func saveData() {
        Storage.remove("contacts.json", from: .documents)
        Storage.store(finalContacts, to: .documents, as: "contacts.json")
    }

    private func notificationForKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                               as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
    }
}

extension DetailContactViewController: UITextFieldDelegate {

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            guard let name = textField.text else { return true }
            finalContacts[numberOfContact].givenName = name
        } else if textField.tag == 1 {
            guard let surname = textField.text else { return true }
            finalContacts[numberOfContact].familyName = surname
        } else if textField.tag == 2 {
            guard let phoneNumber = textField.text else { return true }
            finalContacts[numberOfContact].phoneNumber = phoneNumber
        }
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 2 {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            return false
        }
        return true
    }

    private func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+### (##) ###-##-##"
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for digit in mask where index < cleanPhoneNumber.endIndex {
            if digit == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(digit)
            }
        }
        return result
    }
}
