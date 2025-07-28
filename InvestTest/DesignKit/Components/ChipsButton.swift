//
//  ChipsButton.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 27.07.2025.
//

import UIKit

public final class ChipsButton: UIButton {

    public var text: String = "" {
        didSet {
            setTitle(text, for: .normal)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        make()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func make() {
        var config: UIButton.Configuration = .plain()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attribute in
            var outgoing = attribute
            outgoing.font = Fonts.Montserrat.regular.font(size: 12)
            outgoing.foregroundColor = .black

            return outgoing
        }
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .clear
        config.background.cornerRadius = 20
        config.background.backgroundColor = Colors.bg.color
        config.contentInsets = .init(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
        let view = UIButton(configuration: config)
        view.backgroundColor = .lightGray
        view.contentVerticalAlignment = .center
        view.contentHorizontalAlignment = .center
        self.configuration = config
    }
}
