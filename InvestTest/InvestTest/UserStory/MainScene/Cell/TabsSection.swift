//
//  TabsSection.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

import UIKit
import DesignKit

final class TabsSection: UIView {
    private lazy var hStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .bottom
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var onTap: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTabs(_ tabs: [String], activeIndex: Int) {
        hStack.subviews.forEach { $0.removeFromSuperview() }
        tabs.enumerated().forEach {
            let button = makeButton(isActive: activeIndex == $0.offset, index: $0.offset)
            button.setTitle($0.element, for: .normal)
            hStack.addArrangedSubview(button)
        }
        hStack.addArrangedSubview(UIView())
    }

    private func setupConstraints() {
        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    private func makeButton(isActive: Bool, index: Int) -> UIButton {
        var config: UIButton.Configuration = .plain()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attribute in
            var outgoing = attribute
            outgoing.font = Fonts.Montserrat.bold.font(size: isActive ? 28: 18)
            outgoing.foregroundColor = isActive ? .black : .systemGray

            return outgoing
        }
        config.baseForegroundColor = isActive ? .black : .systemGray
        config.contentInsets = .init(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        let view = UIButton(configuration: config)
        view.backgroundColor = .clear
        view.contentVerticalAlignment = .bottom
        view.contentHorizontalAlignment = .leading
        view.addAction(UIAction { [weak self] _ in
            self?.onTap?(index)
        }, for: .touchUpInside)
        return view
    }
}
