//
//  Constants.swift
//  DreamLister
//
//  Created by Vibhanshu Vaibhav on 03/12/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import Foundation

func getCurrencySymbol() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "en_IN")
    return formatter.currencySymbol
}
