//
//  ContactViewController.swift
//  Trips
//
//  Created by AGUJARI Erik on 10/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//
import Combine
import UIKit

final class ContactViewController: UIViewController {
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var submitButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!

    private let viewModel: ContactViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    private var activeView: UIView? = nil

    private let nameTextfied: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Titles.name
        return textField
    }()
    private let surnameTextfield: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Titles.surname
        return textField
    }()
    private let emailTextfield: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Titles.email
        return textField
    }()
    private let phoneTextfield: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Titles.phone
        return textField
    }()
    private let dateTextfield: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Titles.date
        return textField
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Titles.description
        return label
    }()
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 2.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isScrollEnabled = false
        return textView
    }()

    //MARK: Lifecycle
    init(viewModel: ContactViewModelProtocol = ContactViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: "ContactViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.screen
        setupUI()
        setupBinding()
    }

    //MARK: Private
    @objc private func doneTapped() {
        view.endEditing(true)
    }

    @objc private func datePicked() {
        guard let datePicker = dateTextfield.inputView as? UIDatePicker else {
            return
        }
        dateTextfield.text = datePicker.date.toString()
        dateTextfield.resignFirstResponder()
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        viewModel.submitForm(name: nameTextfied.text,
                             surname: surnameTextfield.text,
                             email: emailTextfield.text,
                             phone: phoneTextfield.text,
                             date: dateTextfield.text,
                             description: descriptionTextView.text)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        nameTextfied.delegate = self
        surnameTextfield.delegate = self
        emailTextfield.delegate = self
        phoneTextfield.delegate = self
        dateTextfield.delegate = self
        descriptionTextView.delegate = self
        stackView.addArrangedSubview(nameTextfied)
        stackView.addArrangedSubview(surnameTextfield)
        stackView.addArrangedSubview(emailTextfield)
        stackView.addArrangedSubview(phoneTextfield)
        stackView.addArrangedSubview(dateTextfield)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(descriptionTextView)
        descriptionTextView.addDoneButton(title: "Ok", target: self, selector: #selector(doneTapped))
        dateTextfield.setInputViewDatePicker(target: self, selector: #selector(datePicked))
    }

    private func setupBinding() {
        viewModel.$errorMessage.sink { [weak self] message in
            guard let message = message else { return }

            self?.showError(message: message)
        }.store(in: &cancellable)
    }
}

extension ContactViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeView = textField
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        activeView = nil
        return true
    }
}

extension ContactViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeView = textView
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        activeView = nil
        return true
    }
}

private extension ContactViewController {
    enum Titles {
        static let screen = "Contact"
        static let name = "Name"
        static let surname = "Surname"
        static let email = "Email"
        static let phone = "Phone(optional)"
        static let date = "Date"
        static let description = "Your observations"
        static let submit = "Submit"
    }

    enum Constants {
        static let spacing: CGFloat = 20
    }
}
