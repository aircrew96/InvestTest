//
//  SearchBar.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 28.07.2025.
//

import UIKit

public final class SearchBar: UISearchBar {

    private let textFieldInsets = UIEdgeInsets(top: 12, left: .zero, bottom: 12, right: 60)
    private let searchIconOffset: CGFloat = 16
    private let clearButtonOffset: CGFloat = -16

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupTextField()
        setupAppearance()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
        setupTextField()
        setupAppearance()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let textField = value(forKey: "searchField") as? UITextField else { return }
        textField.layer.borderWidth = self.isFirstResponder ? 2 : 1
    }
}

// MARK: - Private
private extension SearchBar {
    func setupAppearance() {
        searchBarStyle = .minimal
        setSearchFieldBackgroundImage(UIImage(), for: .normal)
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        barTintColor = .clear
        setPositionAdjustment(.init(horizontal: -16, vertical: .zero), for: .clear)
        setPositionAdjustment(.init(horizontal: 16, vertical: .zero), for: .search)
    }

    func setupTextField() {
        guard let textField = value(forKey: "searchField") as? UITextField else { return }
        textField.defaultTextAttributes = [
            .font: Fonts.Montserrat.semiBold.font(size: 16),
            .foregroundColor: UIColor.black
        ]

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: Fonts.Montserrat.semiBold.font(size: 16),
            .foregroundColor: UIColor.black
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: "Find company or ticker",
            attributes: placeholderAttributes
        )
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 24
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.background = UIImage()

        if let glassIconView = textField.leftView as? UIImageView {
            glassIconView.tintColor = .black
            glassIconView.frame.origin.x = searchIconOffset
        }

        // Кнопка очистки
        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(
                UIImage(systemName: "xmark")?
                    .withRenderingMode(.alwaysTemplate),
                for: .normal
            )
            clearButton.tintColor = .black
            clearButton.frame = .init(x: clearButtonOffset, y: .zero, width: 16, height: 16)
        }
        textField.textRect(forBounds: textField.bounds.inset(by: textFieldInsets))
        textField.placeholderRect(forBounds: textField.bounds.inset(by: textFieldInsets))
        textField.editingRect(forBounds: textField.bounds.inset(by: textFieldInsets))
        textField.leftViewRect(forBounds: textField.bounds.inset(by: UIEdgeInsets(
            top: 8,
            left: searchIconOffset,
            bottom: 8,
            right: 16
        )))
    }

    func setupConstraints() {
        guard let textField = value(forKey: "searchField") as? UITextField else { return }
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 48),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
