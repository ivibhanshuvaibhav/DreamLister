//
//  UIButtonExtension.swift
//  DreamLister
//
//  Created by Vibhanshu Vaibhav on 03/12/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setEnabled() {
        self.isEnabled = true
        self.alpha = 1
    }
    
    func setDisabled() {
        self.isEnabled = false
        self.alpha = 0.7
    }
    
}
