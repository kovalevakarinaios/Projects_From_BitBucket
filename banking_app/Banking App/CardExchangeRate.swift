//
//  CardExchangeRate.swift
//  Banking App
//
//  Created by Karina Kovaleva on 13.05.23.
//

import Foundation

struct CardExchangeRate: Codable {
    let kursDateTime, usdcardIn, usdcardOut, eurcardIn: String
    let eurcardOut, rubcardIn, rubcardOut, cnycardIn: String
    let cnycardOut, usdcardEURCARDIn, usdcardEURCARDOut, usdcardRUBCARDIn: String
    let usdcardRUBCARDOut, rubcardEURCARDOut, rubcardEURCARDIn, cnycardUSDCARDIn: String
    let cnycardUSDCARDOut, cnycardEURCARDIn, cnycardEURCARDOut, cnycardRUBCARDIn: String
    let cnycardRUBCARDOut: String

    enum CodingKeys: String, CodingKey {
        case kursDateTime = "kurs_date_time"
        case usdcardIn = "USDCARD_in"
        case usdcardOut = "USDCARD_out"
        case eurcardIn = "EURCARD_in"
        case eurcardOut = "EURCARD_out"
        case rubcardIn = "RUBCARD_in"
        case rubcardOut = "RUBCARD_out"
        case cnycardIn = "CNYCARD_in"
        case cnycardOut = "CNYCARD_out"
        case usdcardEURCARDIn = "USDCARD_EURCARD_in"
        case usdcardEURCARDOut = "USDCARD_EURCARD_out"
        case usdcardRUBCARDIn = "USDCARD_RUBCARD_in"
        case usdcardRUBCARDOut = "USDCARD_RUBCARD_out"
        case rubcardEURCARDOut = "RUBCARD_EURCARD_out"
        case rubcardEURCARDIn = "RUBCARD_EURCARD_in"
        case cnycardUSDCARDIn = "CNYCARD_USDCARD_in"
        case cnycardUSDCARDOut = "CNYCARD_USDCARD_out"
        case cnycardEURCARDIn = "CNYCARD_EURCARD_in"
        case cnycardEURCARDOut = "CNYCARD_EURCARD_out"
        case cnycardRUBCARDIn = "CNYCARD_RUBCARD_in"
        case cnycardRUBCARDOut = "CNYCARD_RUBCARD_out"
    }
}
