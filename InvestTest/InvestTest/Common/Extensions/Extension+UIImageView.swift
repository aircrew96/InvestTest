//
//  Extension+UIImageView.swift
//  InvestTest
//
//  Created by Олег Ганяхин on 22.07.2025.
//

import UIKit

extension UIImageView {
    func setImage(url: URL) {
        ImageLoaderHelper().loadImage(url: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
