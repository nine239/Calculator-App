//
//  ViewController.swift
//  CalculatorApp
//
//  Created by Nguyen Tuan Vinh on 6/9/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var currentExpression = ""
    
    var calculatorButton : [CalculatorButton] = [.AC, .plusMinus, .percentage, .divide,
                                                 .number(x: 7), .number(x: 8), .number(x: 9), .multiply,
                                                 .number(x: 4), .number(x: 5), .number(x: 6), .subtract,
                                                 .number(x: 1), .number(x: 2), .number(x: 3), .add,
                                                 .number(x: 0), .decimal, .equal]

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var showResultLabel: UILabel!
    
    let precedences : [String : Int] = [
        "+" : 1,
        "-" : 1,
        "x" : 2,
        "÷" : 2
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        
        print(transformExpression(exprArr: tokenize(expr: "8x5÷4")))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calculatorButton.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 20) / 5
        if calculatorButton[indexPath.row].title == "0"{
            return CGSize(width: 2*width + width/3, height: width)
        }
        else{
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.size.width - 20) / 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.size.height - 30 - (collectionView.frame.size.width - 20)) / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let calcButtonCell = calculatorButton[indexPath.row]
        
        // Handle action for button
        switch calcButtonCell{
        case .number(x: let int):
            currentExpression = handleNumber(x: int, current: currentExpression)
            showResultLabel.text = currentExpression
        case .AC:
            currentExpression = handleAC(current: currentExpression)
            showResultLabel.text = currentExpression
        case .add, .subtract, .multiply, .divide:
            currentExpression = handleOperator(op: calcButtonCell.title, current: currentExpression)
            showResultLabel.text = currentExpression
        case .percentage:
            currentExpression = handlePercentage(current: currentExpression)
            showResultLabel.text = currentExpression
        case .plusMinus:
            currentExpression = handlePlusMinus(current: currentExpression)
            showResultLabel.text = currentExpression
        case .decimal:
            currentExpression = handleDecimal(current: currentExpression)
            showResultLabel.text = currentExpression
        case .equal:
            handleEqual()
            showResultLabel.text = currentExpression
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 8, bottom: 20, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as! ButtonCollectionViewCell
        
        cell.configure(with: calculatorButton[indexPath.row])
        
        
        return cell
    }


}


extension ViewController{
    
    func handleNumber(x : Int, current : String) -> String{
        return current + "\(x)"
    }
    
    func handleOperator(op : String, current : String) -> String{
        if current.isEmpty{
            if op != "-"{
                return "0" + op
            }
            else{
                return "-"
            }
        }
        
        if current.last == "."{
            let updated = current
            return updated + "0" + op
        }
        
        if let last = tokenize(expr: current).last, Double(last) == nil{
            if last == "-" && op == "-"{
                if current.count == 1{
                    return "0+"
                }
                else{
                    let start = current.index(current.startIndex, offsetBy: 0)
                    let end = current.index(current.startIndex, offsetBy: current.count-1)
                    
                    let tempString = String(current[start..<end])
                    return tempString + "+"
                }
            }
            else if (last == "+" && op == "-") || (last == "-" && op == "+"){
                if current.count == 1{
                    return "-"
                }
                else{
                    let start = current.index(current.startIndex, offsetBy: 0)
                    let end = current.index(current.startIndex, offsetBy: current.count-1)
                    
                    let tempString = String(current[start..<end])
                    return tempString + "-"
                }
            }
            else if "+-".contains(last) && "x÷".contains(op){
                var tempString = current
                tempString.removeLast()
                return tempString + op
            }
            else{
                if "x÷".contains(last){
                    if op == "+"{
                        return current
                    }
                    else if op == "-"{
                        return current + op
                    }
                    else{
                        var tempString = current
                        tempString.removeLast()
                        return tempString + op
                    }
                }
            }
        }
        return current + op
    }
    
    func handlePlusMinus(current : String) -> String{
        if current.isEmpty{
            return current
        }
        
        var tokens = tokenize(expr: current)
        if let last = tokens.last, Double(last) != nil{
            if last.hasPrefix("-"){
                tokens[tokens.count - 1] = String(last[last.index(last.startIndex, offsetBy: 1) ..< last.endIndex])
            }
            else{
                
                tokens[tokens.count - 1] = "-" + last
            }
            return tokens.joined()
        }
        return current
    }
    
    func handlePercentage(current : String) -> String{
        var tokens = tokenize(expr: current)
        if let last = tokens.last, Double(last) != nil{
            let newNumber = Double(last)! / 100
            tokens.removeLast()
            tokens.append(String(newNumber))
        }
        else{
            tokens.removeLast()
            let currentNumber = Double(tokens.removeLast())
            tokens.append(String(currentNumber! / 100))
        }
        return tokens.joined()
    }
    
    func handleAC(current : String) -> String{
        return ""
    }
    
    func handleDecimal(current : String) -> String{
        let tokens = tokenize(expr: current)
        if current.isEmpty{
            return "0."
        }
        guard let last = tokens.last else {
            return "0."
        }
        
        if Double(last) == nil{
            return current + "0."
        }
        else{
            if last.contains("."){
                return current
            }
            else{
                return current + "."
            }
        }
    }
    
    // MARK: Handle equal
    func handleEqual(){
        let transformExpr = transformExpression(exprArr: tokenize(expr: currentExpression))
        let result = shuntingYard(outputQueue: transformExpr)
        currentExpression = String(result)
    }
    
    func tokenize(expr : String) -> [String]{
        var numberBuffer = ""
        var tokens : [String] = []
        var prev = ""
        for char in expr{
            if char.isNumber || char == "." || (prev.isEmpty && char == "-") || (!prev.isEmpty && "+-x÷".contains(prev) && char == "-"){
                numberBuffer.append(String(char))
            }
            else{
                if !numberBuffer.isEmpty {
                    tokens.append(numberBuffer)
                    numberBuffer = ""
                }
                tokens.append(String(char))
            }
            // Update value for prev
            prev = String(char)
        }
        if !numberBuffer.isEmpty{
            tokens.append(numberBuffer)
        }
        
        return tokens
    }
    
    func transformExpression(exprArr : [String]) -> [String]{
        var outputQueue : [String] = []
        var operatorStack : [String] = []
        
        for e in exprArr{
            if Double(e) != nil{
                outputQueue.append(e)
            }
            else{
                if operatorStack.isEmpty{
                    operatorStack.append(e)
                }
                else{
                    if let precedence2 = precedences[e]{
                        var precedence1 = precedences[operatorStack.last!]!
                        while precedence1 >= precedence2{
                            outputQueue.append(operatorStack.removeLast())
                            if operatorStack.isEmpty{
                                break
                            }
                            precedence1 = precedences[operatorStack.last!]!
                        }
                        operatorStack.append(e)
                    }
                }
            }
        }
        
        while !operatorStack.isEmpty{
            outputQueue.append(operatorStack.removeLast())
        }
        return outputQueue
    }
    
    func shuntingYard(outputQueue : [String]) -> Double{
        var s : [Double] = []
        
        for i in outputQueue{
            if Double(i) != nil{
                s.append(Double(i)!)
            }
            else{
                let b = s.removeLast()
                let a = s.removeLast()
                if i == "+"{
                    s.append(a + b)
                }
                else if i == "-"{
                    s.append(a - b)
                }
                else if i == "x"{
                    s.append(a * b)
                }
                else{
                    s.append(a / b)
                }
            }
        }
        
        return s[0]
    }
    
}
