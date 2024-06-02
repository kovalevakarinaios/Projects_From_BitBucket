//
//  extension+String.swift
//  HomeWork1_KovalevaKarina
//
//  Created by Karina Kovaleva on 11.12.22.
//

import Foundation

extension String {
    func localizeString(string: String) -> String {
        guard let path = Bundle.main.path(forResource: string, ofType: "lproj") else { return String() }
        guard let bundle = Bundle(path: path) else { return String() }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
