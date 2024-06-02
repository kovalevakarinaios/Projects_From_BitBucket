//
//  SectionHeader.swift
//  ATMs
//
//  Created by Karina Kovaleva on 5.01.23.
//

import UIKit

final class SectionHeader: UICollectionReusableView {

    static let reuseId = "sectionHeader"

    private lazy var headerLabel: UILabel = {
        var headerLabel = UILabel()
        headerLabel.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        headerLabel.backgroundColor = .systemBackground
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        return headerLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.headerLabel)
        self.headerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public func setHeaderText(_ city: String) {
        self.headerLabel.text = city
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
