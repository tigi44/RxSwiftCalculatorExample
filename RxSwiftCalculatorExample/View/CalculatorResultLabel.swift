//
//  CalculatorResultLabel.swift
//  RxSwiftCalculatorExample
//
//  Created by tigi on 2020/07/27.
//  Copyright © 2020 tigi44. All rights reserved.
//

import UIKit

//MARK: CLASS - CalculatorResultLabel
class CalculatorResultLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: rect.inset(by: inset))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor     = .white
        textColor           = .black
        textAlignment       = .right
        layer.masksToBounds = true
        layer.cornerRadius  = 10
        layer.borderColor   = UIColor.darkGray.cgColor
        layer.borderWidth   = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
