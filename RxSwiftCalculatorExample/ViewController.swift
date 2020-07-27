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



//MARK: ENUM - CalculatorButton
enum CalculatorButton: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case plus = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    case equals = "="
    case clear = "clear"
    case empty = ""
    
    func isOperator() -> Bool {
        return self == .plus || self == .subtract || self == .multiply || self == .divide || self == .divide
    }
}



//MARK: CLASS - ViewController
class ViewController: UIViewController {

    fileprivate let disposeBag = DisposeBag()
    
    let calculatorResultLabel: UILabel           = CalculatorResultLabel()
    let collectionView: UICollectionView         = CalculatorCollectionView()
    let collectionViewData: [CalculatorButton]   = [.clear, .plus, .subtract, .empty,
                                                    .one, .two, .three, .multiply,
                                                    .four, .five, .six, .divide,
                                                    .seven, .eight, .nine, .equals,
                                                    .zero]
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
                cell.buttonLabel.text = data.rawValue
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



//MARK: CLASS - CalculatorViewModel
class CalculatorViewModel {
    
    var calculatorButtonVariable = BehaviorRelay<CalculatorButton?>(value: .zero)
    var calculatorObservable: Observable<String>!
    
    private var _lastOperator: CalculatorButton?
    private var lastOperator: CalculatorButton? {
        set(newValue) {
            if let newValue = newValue, newValue.isOperator() {
                _lastOperator = newValue
            } else {
                _lastOperator = nil
            }
        }
        get {
            return _lastOperator
        }
    }
    private var subTotal: Double = 0 {
        didSet {
            self.labelString = "0"
        }
    }
    private var labelString: String = "0"
    
    init() {
        setupObservable()
    }
    
    // Setup calculatorObservable
    private func setupObservable() {
        
        calculatorObservable = calculatorButtonVariable.asObservable().map{ calculatorButton in
            
            switch calculatorButton {
            case .clear:
                self.clear()
                break
            case .plus:
                self.plus()
                break
            case .subtract:
                self.subtract()
                break
            case .multiply:
                self.multiply()
                break
            case .divide:
                self.divide()
                break
            case .equals:
                self.equal()
                break
            case .empty:
                break
            default:
                let number = calculatorButton?.rawValue ?? ""
                self.number(number)
            }
            
            return self.labelString
        }
    }
}
extension CalculatorViewModel {
    private func number(_ number: String) {
        self.labelString += number
        
        if let inputInt = UInt(self.labelString) {
            self.labelString = String(inputInt)
        } else {
            self.labelString = "0"
        }
    }
    private func clear() {
        self.lastOperator = nil
        self.subTotal = 0
    }
    private func plus() {
        if let _ = self.lastOperator {
            equal()
        }
        
        self.lastOperator = .plus
        self.subTotal = Double(self.labelString) ?? 0
    }
    private func subtract() {
        if let _ = self.lastOperator {
            equal()
        }
        
        self.lastOperator = .subtract
        self.subTotal = Double(self.labelString) ?? 0
    }
    private func multiply() {
        if let _ = self.lastOperator {
            equal()
        }
        
        self.lastOperator = .multiply
        self.subTotal = Double(self.labelString) ?? 0
    }
    private func divide() {
        if let _ = self.lastOperator {
            equal()
        }
        
        self.lastOperator = .divide
        self.subTotal = Double(self.labelString) ?? 0
    }
    private func equal() {
        let currentTotal: Double = Double(self.labelString) ?? 0
        
        switch self.lastOperator {
        case .plus:
            self.subTotal += currentTotal
            break
        case .subtract:
            self.subTotal -= currentTotal
            break
        case .multiply:
            self.subTotal *= currentTotal
            break
        case .divide:
            self.subTotal /= currentTotal
            break
        default:
            self.subTotal = currentTotal
        }
        
        self.lastOperator = nil
        self.labelString = String(self.subTotal)
    }
}
