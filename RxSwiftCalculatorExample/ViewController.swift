//
//  ViewController.swift
//  RxSwiftCalculatorExample
//
//  Created by tigi on 2020/05/28.
//  Copyright © 2020 tigi44. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


//MARK: CLASS - ViewController
class ViewController: UIViewController {

    fileprivate let disposeBag = DisposeBag()
    
    let calculatorResultLabel: UILabel           = CalculatorResultLabel()
    let collectionView: UICollectionView         = CalculatorCollectionView()
    let collectionViewData: [CalculatorButton]   = [FunctionalButton.clear, OperatorButton.plus, OperatorButton.subtract, OperatorButton.multiply,
                                                    NumberButton.one, NumberButton.two, NumberButton.three, OperatorButton.divide,
                                                    NumberButton.four, NumberButton.five, NumberButton.six, OperatorButton.equals,
                                                    NumberButton.seven, NumberButton.eight, NumberButton.nine, NumberButton.zero]
    let calculatorViewModel: CalculatorViewModel = CalculatorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Subscribe to calculatorObservable on calculatorViewModel
        calculatorViewModel
            .calculatorObservable
            .subscribe(onNext: { reslutLabelString in
                self.calculatorResultLabel.text = reslutLabelString
            }).disposed(by: disposeBag)
        
        // Rx collectionview - observe items of the collection view
        let items = Observable.just(collectionViewData)
        items
            .asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: String(describing: CalculatorButtonCell.self), cellType: CalculatorButtonCell.self)) { row, data, cell in
                cell.buttonLabel.text = data.text()
        }.disposed(by: disposeBag)
        
        // Rx collectionview - change calculatorButtonVariable on calculatorViewModel when select a button cell of the collection view
        collectionView
            .rx
            .modelSelected(CalculatorButton.self)
            .bind(to: calculatorViewModel.calculatorButtonVariable)
            .disposed(by: disposeBag)
    }
}
extension ViewController {
    
    private func buildLayoutConstraints() {
        
        NSLayoutConstraint.activate([
            calculatorResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculatorResultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            calculatorResultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculatorResultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            calculatorResultLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: calculatorResultLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: calculatorResultLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: calculatorResultLabel.trailingAnchor),
        ])
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        calculatorResultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calculatorResultLabel)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        buildLayoutConstraints()
    }
}
