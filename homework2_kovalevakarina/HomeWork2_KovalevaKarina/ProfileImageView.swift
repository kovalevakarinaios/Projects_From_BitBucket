//
//  ProfileImageView.swift
//  HomeWork2_KovalevaKarina
//
//  Created by Karina Kovaleva on 18.12.22.
//

import UIKit

final class ProfileImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .systemGray4
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
