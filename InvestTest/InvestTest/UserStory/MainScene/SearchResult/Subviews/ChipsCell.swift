//
//  ChipsCell.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 27.07.2025.
//

import UIKit
import DesignKit

final class ChipsCell: UITableViewCell {

    // MARK: - Properties
    private let horizontalSpacing: CGFloat = 4
    private let verticalSpacing: CGFloat = 8

    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = verticalSpacing
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    var onTap: ((String) -> Void)?

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        containerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Public Methods
    func configure(with items: [String]) {
        containerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let availableWidth = contentView.bounds.width - contentView.layoutMargins.left - contentView.layoutMargins.right

        var currentRowStack: UIStackView?
        var currentRowWidth: CGFloat = 0

        for item in items {
            let chipButton = ChipsButton()
            chipButton.text = item
            chipButton.addAction(UIAction(handler: { [weak self] _ in
                self?.onTap?(item)
            }), for: .touchUpInside)
            chipButton.translatesAutoresizingMaskIntoConstraints = false
            chipButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            chipButton.widthAnchor.constraint(equalToConstant: chipButton.intrinsicContentSize.width).isActive = true

            let chipWidth = chipButton.intrinsicContentSize.width

            // Проверяем, помещается ли чипс в текущую строку
            if currentRowStack == nil || currentRowWidth + chipWidth + horizontalSpacing > availableWidth {
                // Создаем новую строку
                currentRowStack = makeHStack()
                containerStackView.addArrangedSubview(currentRowStack!)
                currentRowWidth = 0
            }

            // Добавляем чипс в текущую строку
            currentRowStack?.addArrangedSubview(chipButton)
            currentRowWidth += chipWidth + horizontalSpacing
        }
    }

    // MARK: - Private Methods
    private func setupViews() {
        contentView.addSubview(containerStackView)
        contentView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    private func makeHStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = horizontalSpacing
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }
}
