//
//  News.swift
//  Banking App
//
//  Created by Karina Kovaleva on 12.05.23.
//

import Foundation

struct News: Codable {
    let nameRu, htmlRu: String
    let img: String
    let startDate: String
    let link: String

    enum CodingKeys: String, CodingKey {
        case nameRu = "name_ru"
        case htmlRu = "html_ru"
        case img
        case startDate = "start_date"
        case link
    }
}
