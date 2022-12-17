//
//  Double.swift
//  uber
//
//  Created by Mike Keller on 17.12.22.
//

import Foundation

extension Double {
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "de_DE") // Locale.current is way better use this but it doesnt work properly in simulator so i hardcoded germany into it
        return formatter
    }
    
    func toCurrency() -> String? {
        return currencyFormatter.string(from: NSNumber(value: self))
    }
}
