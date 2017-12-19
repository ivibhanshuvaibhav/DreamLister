//
//  InsetTextView.swift
//  DreamLister
//
//  Created by Vibhanshu Vaibhav on 03/12/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit

class InsetTextView: UITextView {

    private var padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3.0
        self.textContainerInset = padding
    }

}

