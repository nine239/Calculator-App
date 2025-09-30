//
//  CalculatorButton.swift
//  CalculatorApp
//
//  Created by Nguyen Tuan Vinh on 6/9/25.
//

import UIKit

enum CalculatorButton{
    case AC
    case plusMinus
    case percentage
    case divide
    case number(x : Int)
    case multiply
    case subtract
    case add
    case decimal
    case equal
    
    init(calcButton : CalculatorButton) {
        self = calcButton
    }
}

extension CalculatorButton{
    var title : String {
        switch self{
        case .AC:
            return "AC"
        case .plusMinus:
            return "+/-"
        case .percentage:
            return "%"
        case .divide:
            return "÷"
        case .decimal:
            return "."
        case .multiply:
            return "x"
        case .subtract:
            return "-"
        case .add:
            return "+"
        case .equal:
            return "="
        case .number(x: let int):
            return int.description
        }
    }
    
    var color : UIColor {
        switch self{
        case .AC, .plusMinus, .percentage:
            return .lightGray
        case .divide, .multiply, .subtract, .add, .equal:
            return .systemOrange
        case .number(x: _), .decimal:
            return .darkGray
        }
    }
}
