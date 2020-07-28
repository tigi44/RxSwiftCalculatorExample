//
//  CalculatorCollectionView.swift
//  RxSwiftCalculatorExample
//
//  Created by tigi on 2020/07/27.
//  Copyright © 2020 tigi44. All rights reserved.
//

import UIKit

//MARK: CLASS - CalculatorCollectionView
class HeightFitCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
class CalculatorCollectionView: HeightFitCollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        let itemSize = (UIScreen.main.bounds.width - 70) / 4
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize                = CGSize(width: itemSize, height: itemSize)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing      = 10
        
        backgroundColor = .white
        register(CalculatorButtonCell.self, forCellWithReuseIdentifier: String(describing: CalculatorButtonCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
