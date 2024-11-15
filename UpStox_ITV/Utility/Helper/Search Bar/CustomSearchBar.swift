//
//  CustomSearchBar.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import UIKit

protocol CustomSearchBarDelegate {
    func textFieldDidChange(searchText: String?)
}

class CustomSearchBar: UIView {
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .white
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(StringMessage.cancel.value, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return cancelButton
    }()
    
    var cancelButtonTapped: (() -> Void)?
    var delegate: CustomSearchBarDelegate?
    
    
    // Initializes a custom search bar view.
    // - Parameters:
    // - frame: The frame for the search bar.
    // - placeholder: The placeholder text for the search field (default is "Search").
    // - textColor: The text color for the search input field (default is white).
    // - cancelButtonColor: The text color for the cancel button (default is white).
    // - backgroundColor: The background color of the search bar (default is a semi-transparent black).
    // - delegate: The delegate that conforms to the `CustomSearchBarDelegate` protocol to handle search events.
    // - cancelButtonAction: The closure that gets called when the cancel button is tapped (default is nil).
    init(frame: CGRect, placeholder: String = StringMessage.searchText.value, textColor: UIColor = .white, cancelButtonColor: UIColor = .white, backgroundColor: UIColor = .black.withAlphaComponent(0.5), delegate: CustomSearchBarDelegate?, cancelButtonAction: (() -> Void)? = nil) {
        super.init(frame: frame)
        self.delegate = delegate
        self.cancelButtonTapped = cancelButtonAction
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 4.0
        self.addSubview(view)
        
        searchTextField.textColor = textColor
        searchTextField.changePlaceholderColor(placeholderText: placeholder)
        view.addSubview(searchTextField)
        
        cancelButton.tintColor = cancelButtonColor
        self.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            view.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -10),
            view.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            cancelButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 60),
            cancelButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    // Called when the cancel button is tapped. Executes the closure.
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        cancelButtonTapped?()
    }
    
    // Called whenever the text in the search text field changes. Notifies the delegate with the current search text.
    @objc private func textFieldDidChange(_ textField: UITextField) {
        self.delegate?.textFieldDidChange(searchText: textField.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Clears the text in the search text field and dismisses the keyboard.
    func clearTextField() {
        self.searchTextField.text = ""
        self.resignResponder()
    }
    
    func resignResponder() {
        DispatchQueue.main.async {
            self.searchTextField.resignFirstResponder()
        }
    }
    
    // This function ensures that the search text field becomes the first responder.
    func becomeResponder() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.searchTextField.becomeFirstResponder()
        })
    }
    
}

extension CustomSearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
