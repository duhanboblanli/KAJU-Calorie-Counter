//
//  CalculatorBrain.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 2.02.2023.
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    
    mutating func calculateBMI(_ height: Float,_ weight: Float) {
        let bmiValue = weight / pow(height,2)
        
        if bmiValue < 18.5 {
            bmi = BMI (value: bmiValue, advice:"You are underweight. Eat more pies!", color: UIColor.init(red: 0.1137, green: 0.6745, blue: 0.898, alpha: 1))
        } else if bmiValue < 24.9 {
            bmi = BMI (value: bmiValue, advice: "You are healthy. Fit as a fiddle!", color: UIColor.init(red: 0.3882, green: 0.9, blue: 0.1176, alpha: 1))
        } else {
            bmi = BMI (value: bmiValue, advice: "You are overweight. Eat less pies!", color: UIColor.systemPink)
            
        }
    }
    
    func getBMIValue() -> String {
        let bmiTo1DecimalPlace = String(format: "%.1f", bmi?.value ?? 0.0)
        return bmiTo1DecimalPlace
    }
    
    func getAdvice() -> String {
        return bmi?.advice ?? "Error:Advice Not Found"
    }
    
    func getColor() -> UIColor {
        return bmi?.color ?? UIColor.white
    }
    
    
    
    
    
}


