//
//  Exponent.swift
//  ProjectEuler
//
//  Created by Andrew McKnight on 1/11/16.
//  Copyright © 2016 AMProductions. All rights reserved.
//

import Foundation

infix operator **

// Integer case

func **<T>(base: T, power: T) -> T where T: Integer, T: IntegerArithmetic {
    return exponentiate(base, power)
}

func exponentiate<T>(_ base: T, _ power: T) -> T where T: Integer, T: IntegerArithmetic {
    var result = base
    var mutablePower = power
    while mutablePower > 1 {
        result *= base
        mutablePower -= 1 as T
    }
    return result
}

// Floating-point cases

/// applies to `Float` and `Float32`
func **(base: Float, power: Float) -> Float {
    return powf(base, power)
}

/// applies to `Double` and `Float64`
func **(base: Double, power: Double) -> Double {
    return pow(base, power)
}

func **(base: Float80, power: Float80) -> Float80 {
    // TODO: implement
    return -1.0
}
