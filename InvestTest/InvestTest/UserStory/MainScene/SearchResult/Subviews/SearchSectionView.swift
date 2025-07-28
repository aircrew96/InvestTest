//
//  SearchSectionView.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 28.07.2025.
//

import UIKit
import DesignKit

final class SearchSectionView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Montserrat.bold.font(size: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let buttonAction: UIButton = {
        var config = UIButton.Configuration.plain()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attribute in
            var outgoing = attribute
            outgoing.font = Fonts.Montserrat.semiBold.font(size: 12)
            outgoing.foregroundColor = .black

            return outgoing
        }
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .clear
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, buttonName: String? = nil) {
        titleLabel.text = title
        if let buttonName {
            buttonAction.isHidden = false
            buttonAction.setTitle(buttonName, for: .normal)
        } else {
            buttonAction.isHidden = true
        }
    }

    private func setupConstraints() {
        addSubview(hStack)
        [titleLabel, UIView(), buttonAction].forEach { hStack.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
