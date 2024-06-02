//
//  ProfileUIImageView.swift
//  Lesson 2
//
//  Created by Karina Kovaleva on 17.12.22.
//

import UIKit

class ProfileImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .systemGray
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
