//
//  Statistics.swift
//  ProjectEuler
//
//  Created by Andrew McKnight on 1/12/16.
//  Copyright © 2016 AMProductions. All rights reserved.
//

import Foundation

/// return number of combinations possible from combining r objects from a domain of d objects
func combinations(_ d: Int, _ r: Int) -> Int {

    if d < r { return 0 }
    if d == r { return 1 }
    return d*! / ( r*! * (d - r)*! )

}

func permutations(_ n: Int, _ l: Int, withReplacement: Bool) -> Int {

    if withReplacement { return n**l }
    if l > n { return 0 }
    return n*! / (n - l)*!

}

/**
 Compute the hypergeometric distribution for p out of q objects from n objects of
	one of two dichotomous types, where m is the total amount of objects.

 Example:
 in a pond with 50 (`m`) fish, 10 (`n`) are tagged. if a fisherman catches 7 (`q`) random fish
 without replacement, and X is the number of tagged fish caught, the probability that
 2 (`p`) fish are tagged is given by the expression

 ```

                  / 10 \   / 40 \
                 |      | |      |
                  \ 2  /   \  5 /    (45)(658,008)   246,753
 P( X = 2 )  =   --------------- =   ------------- = ------- ~ 0.2964
                      / 50 \           99,884,400    832,370
                     |      |
                      \  7 /

 ```

 The analogous function call for this example would be `hypergeometricDistribution(2, 7, 10, 50)`
 */
func hypergeometricDistribution(p: Int, q: Int, n: Int, m: Int) -> Double {

    return Double(combinations(n, p) * combinations((m - n), (q - p))) / Double(combinations(m, q))

}

func variance(n: Int, p: Int, q: Int) -> Double {
    return Double(n) * ( Double(p) / Double(p + q) ) * ( Double(q) / Double(p + q) ) * ( Double(q + p) - Double(n) ) / ( Double(q + p) - 1.0 )
}

func standardDeviation(n: Int, p: Int, q: Int) -> Double {
    return sqrt(variance(n: n, p: p, q: q))
}

func mean(n: Int, p: Int, q: Int) -> Double {
    return Double(n) * ( Double(p) / Double(p + q) )
}
