//
//  CalculatorButtonEnum.swift
//  RxSwiftCalculatorExample
//
//  Created by tigi on 2020/07/27.
//  Copyright © 2020 tigi44. All rights reserved.
//

import Foundation

//MARK: ENUM - CalculatorButton
protocol CalculatorButton {
    func text() -> String
}

enum FunctionalButton: CalculatorButton {
    case clear
    case empty
    case dot
    
    func text() -> String {
        switch self {
        case .clear:
            return "clear"
        case .empty:
            return ""
        case .dot:
            return "."
        }
    }
}

enum NumberButton: CalculatorButton {
    case zero, one, two, three, four, five, six, seven, eight, nine
    
    func text() -> String {
        switch self {
        case .zero:
            return "0"
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        }
    }
}

enum OperatorButton: CalculatorButton {
    case plus, subtract, multiply, divide, equals
    
    func text() -> String {
        switch self {
        case .plus:
            return "+"
        case .subtract:
            return "-"
        case .multiply:
            return "*"
        case .divide:
            return "/"
        case .equals:
            return "="
        }
    }
    
    func execute(_ first: NSNumber, _ second: NSNumber) -> NSNumber {
        switch self {
        case .plus:
            return NSDecimalNumber(decimal: first.decimalValue).adding(NSDecimalNumber(decimal: second.decimalValue))
        case .subtract:
            return NSDecimalNumber(decimal: first.decimalValue).subtracting(NSDecimalNumber(decimal: second.decimalValue))
        case .multiply:
            return NSDecimalNumber(decimal: first.decimalValue).multiplying(by: NSDecimalNumber(decimal: second.decimalValue))
        case .divide:
            return NSDecimalNumber(decimal: first.decimalValue).dividing(by: NSDecimalNumber(decimal: second.decimalValue))
        case .equals:
            return first
        }
    }
}
