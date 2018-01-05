//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Monika Koschel on 26.06.2016.
//  Copyright © 2016 Monika Koschel. All rights reserved.
//

import Foundation

private func factorial(number: Double) -> Double {
    if number <= 1 {
        return 1
    }
    return number * factorial(number - 1.0)
}

class CalculatorBrain
{
    private var accumulator: Double = 0.0
    private var pending: PendingBinaryOperationInfo?
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "±": Operation.UnaryOperation( { -$0 } ),
        "×": Operation.BinaryOperation( { $0 * $1 } ),
        "÷": Operation.BinaryOperation( { $0 / $1 } ),
        "+": Operation.BinaryOperation( { $0 + $1 } ),
        "−": Operation.BinaryOperation( { $0 - $1 } ),
        "x²" : Operation.UnaryOperation({ pow($0, 2) }),
        "x³" : Operation.UnaryOperation({ pow($0, 3) }),
        "x⁻¹" : Operation.UnaryOperation({ 1 / $0 }),
        "sin" : Operation.UnaryOperation(sin),
        "tan" : Operation.UnaryOperation(tan),
        "sinh" : Operation.UnaryOperation(sinh),
        "cosh" : Operation.UnaryOperation(cosh),
        "tanh" : Operation.UnaryOperation(tanh),
        "ln" : Operation.UnaryOperation(log),
        "log" : Operation.UnaryOperation(log10),
        "eˣ" : Operation.UnaryOperation(exp),
        "10ˣ" : Operation.UnaryOperation({ pow(10, $0) }),
        "x!" : Operation.UnaryOperation(factorial),
        "xʸ" : Operation.BinaryOperation(pow),
        "=": Operation.Equals
    ]
    
    private enum Operation
    {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private struct PendingBinaryOperationInfo
    {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    func setOperand(operand: Double)
    {
        accumulator = operand
    }
    
    func performOperation(symbol: String)
    {
        if let operation = operations[symbol]
        {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var result: Double
    {
        get
        {
            return accumulator
        }
    }
}