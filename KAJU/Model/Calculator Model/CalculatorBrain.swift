//
//  CalculatorBrain.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 2.02.2023.
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    var calorie: Float?
    
    mutating func calculateBMI(_ height: Float,_ weight: Float) {
       
        let bmiValue = weight / pow(height,2)
        
        if bmiValue < 18.5 {
            bmi = BMI (value: bmiValue, advice:"You are underweight. Your body mass index is below normal limits.", color: UIColor.init(red: 0.1137, green: 0.6745, blue: 0.898, alpha: 1))
        } else if bmiValue <= 24.9 {
            bmi = BMI (value: bmiValue, advice: "You are healthy. Track your daily calorie needs.", color: UIColor.init(red: 0.3882, green: 0.9, blue: 0.1176, alpha: 1))
        } else {
            bmi = BMI (value: bmiValue, advice: "You are overweight. You need to keep an eye on your health.", color: UIColor.systemPink)
        }
    }
    
    //10 * ağırlık (kg) + 6.25 * boy (cm) – 5 * yaş (y) + s (kcal / gün) --> burada s, erkekler için +5 ve kadınlar için -161’dir.
    
    mutating func calculateCalorie(_ sex: String,_ weight: Float,_ height: Float,_ age: Float,_ bmh: Float, _ changeCalorieAmount: Int) {
        
        if sex == "Male" {
            calorie = (10*weight) + (6.25 * height) - (5*age) + 5
            calorie! *= bmh
            calorie! += Float(changeCalorieAmount)
        } else {
            calorie = (10*weight) + (6.25 * height) - (5*age) - 161
            calorie! *= bmh
            calorie! += Float(changeCalorieAmount)
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
    
    func getCalorie() -> String {
        let calorieTo1DecimalPlace = String(format: "%.0f", calorie ?? 0.0)
        return calorieTo1DecimalPlace
    }
    
    
    
    
    
}


