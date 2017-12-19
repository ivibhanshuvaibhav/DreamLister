//
//  StringExtension.swift
//  DreamLister
//
//  Created by Vibhanshu Vaibhav on 03/12/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
