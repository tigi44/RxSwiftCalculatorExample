//
//  CalculatorButtonCell.swift
//  RxSwiftCalculatorExample
//
//  Created by tigi on 2020/07/27.
//  Copyright © 2020 tigi44. All rights reserved.
//

import UIKit

//MARK: CLASS - CalculatorButtonCell
class CalculatorButtonCell: UICollectionViewCell {
    
    let buttonLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius  = 10
        contentView.layer.borderColor   = UIColor.blue.withAlphaComponent(0.5).cgColor
        contentView.layer.borderWidth   = 2
        
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.textColor = .blue
        contentView.addSubview(buttonLabel)
        NSLayoutConstraint.activate([
            buttonLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
