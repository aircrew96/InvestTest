//
//  StockCell.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

import UIKit
import DesignKit

final class StockCell: UITableViewCell {
    // MARK: - Subviews
    private let iconImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.Montserrat.bold.font(size: 18)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.Montserrat.semiBold.font(size: 11)
        view.textColor = .secondaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let priceLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.Montserrat.bold.font(size: 18)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let changeLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.Montserrat.bold.font(size: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let leadingVStackContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = .zero
        view.alignment = .leading
        view.distribution = .equalCentering
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let trailingVStackContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = .zero
        view.alignment = .trailing
        view.distribution = .equalCentering
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let hStackContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleHStackContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let favouriteStarView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backgroundContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var onFavouriteTapped: (() -> Void)?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
        setupConstraints()
        favouriteStarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapFavourite)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func make(with model: ViewModel) {
        iconImage.setImage(url: model.iconUrl)
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        priceLabel.text = model.price
        changeLabel.text = model.change
        changeLabel.textColor = model.isProfit ? Colors.green.color : Colors.red.color
        backgroundContainer.backgroundColor = model.isIndication ? Colors.bg.color : Colors.baseBackground.color
        let starColor = model.isFavorite ? Colors.yellow : Colors.gray
        favouriteStarView.tintColor = starColor.color
        favouriteStarView.image = DesignKit.Icons.starNotSelected.image.withRenderingMode(.alwaysTemplate)
    }

    // MARK: - Setup subviews
    private func setupSubviews() {
        contentView.addSubview(backgroundContainer)
        backgroundContainer.addSubview(hStackContainer)
        [titleLabel, favouriteStarView, UIView()].forEach { titleHStackContainer.addArrangedSubview($0) }
        [iconImage, leadingVStackContainer, trailingVStackContainer].forEach(hStackContainer.addArrangedSubview)
        [UIView(), titleHStackContainer, subtitleLabel, UIView()].forEach(leadingVStackContainer.addArrangedSubview)
        [UIView(), priceLabel, changeLabel, UIView()].forEach(trailingVStackContainer.addArrangedSubview)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImage.widthAnchor.constraint(equalToConstant: 52),
            iconImage.heightAnchor.constraint(equalToConstant: 52),

            backgroundContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backgroundContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            hStackContainer.topAnchor.constraint(equalTo: backgroundContainer.topAnchor, constant: 8),
            hStackContainer.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: -8),
            hStackContainer.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor, constant: 8),
            hStackContainer.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor, constant: -8)
        ])
    }

    @objc private func onTapFavourite() {
        onFavouriteTapped?()
    }
}

// MARK: - ViewModel
extension StockCell {
    struct ViewModel: Hashable, Identifiable {
        let id: UUID = UUID()
        let iconUrl: URL
        let title: String
        let subtitle: String
        let price: String
        let change: String
        let isFavorite: Bool
        let isProfit: Bool
        let isIndication: Bool
    }
}
