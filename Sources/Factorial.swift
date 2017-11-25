//
//  Factorial.swift
//  ProjectEuler
//
//  Created by Andrew McKnight on 1/11/16.
//  Copyright © 2016 AMProductions. All rights reserved.
//

import Foundation

postfix operator *!

postfix func *!<T>(n: T) -> T where T: Integer, T: IntegerArithmetic {
    return factorial(n)
}

func factorial<T>(_ n: T) -> T where T: Integer, T: IntegerArithmetic {
    var prod = 1 as T
    var current = 2 as T
    while (current <= n) {
        prod *= current
        current += 1 as T
    }
    return prod
}
