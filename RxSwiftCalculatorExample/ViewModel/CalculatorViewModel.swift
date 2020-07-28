//
//  CalculatorViewModel.swift
//  RxSwiftCalculatorExample
//
//  Created by tigi on 2020/07/27.
//  Copyright © 2020 tigi44. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

//MARK: CLASS - CalculatorViewModel
class CalculatorViewModel {
    
    var calculatorButtonVariable = BehaviorRelay<CalculatorButton?>(value: NumberButton.zero)
    var calculatorObservable: Observable<String>!
    
    private var lastOperator: OperatorButton?
    private var lastNumber: NSNumber = 0
    private var currentNumber: NSNumber = 0
    private var labelString: String = NumberButton.zero.text()
    
    init() {
        setupObservable()
    }
    
    // Setup calculatorObservable
    private func setupObservable() {
        
        calculatorObservable = calculatorButtonVariable.asObservable().map{ calculatorButton in
            
            switch calculatorButton {
            case let operatorButton as OperatorButton:
                self.inputOperator(operatorButton)
                break
            case let functionalButton as FunctionalButton:
                switch functionalButton {
                case .clear:
                    self.inputClear()
                    break
                case .empty:
                    break
                case .dot:
                    self.inputDot()
                    break
                }
            case let numberButton as NumberButton:
                self.inputNumber(numberButton.text())
                break
            default:
                break
            }
            
            return self.labelString
        }
    }
}
extension CalculatorViewModel {
    private func inputNumber(_ number: String) {
        let dotString = self.labelString.hasSuffix(".") ? "." : ""
        
        self.currentNumber = NSNumber(value: Double("\(self.currentNumber)" + dotString + number) ?? 0)
        self.labelString = "\(self.currentNumber)"
    }
    
    private func inputDot() {
        if !self.labelString.contains(".") {
            self.labelString = self.labelString + "."
        }
    }
    
    private func inputClear() {
        self.lastOperator = nil
        self.lastNumber = 0
        self.currentNumber = 0
        self.labelString = "\(self.currentNumber)"
    }
    
    
    private func executeLastOperator() -> NSNumber {
        let result: NSNumber!

        if let lastOperator = self.lastOperator {
            result = lastOperator.execute(self.lastNumber, self.currentNumber)
            self.labelString = "\(result!)"
        } else {
            result = self.currentNumber
        }

        return result
    }

    private func inputOperator(_ inputOperator: OperatorButton) {
        let result = executeLastOperator()
        
        self.lastOperator = inputOperator
        self.lastNumber = result
        self.currentNumber = 0
    }
}
