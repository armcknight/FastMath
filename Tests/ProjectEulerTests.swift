//
//  ProjectEulerTests.swift
//  ProjectEulerTests
//
//  Created by Andrew McKnight on 1/9/16.
//  Copyright © 2016 AMProductions. All rights reserved.
//

import XCTest

class ProjectEulerTests: XCTestCase {

    func testSetElementCombinations() {
        let input: Set<Int> = [1, 2, 3, 4]
        let cases: [Int: Set<Set<Int>>] = [
            0: [[]],
            1: [[1], [2], [3], [4]],
            2: [[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]],
            3: [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]],
            4: [[1, 2, 3, 4]],
            5: [],
        ]

        for (n, result) in cases {
            let computed: Set<Set<Int>> = input.combinationsRecursive(combinationSize: n)

            XCTAssertEqual(result.count, computed.count)

            var equal = true
            for element in result {
                if !computed.contains(where: { param -> Bool in
                    return param == element
                }) {
                    equal = false
                    break
                }
            }
            
            XCTAssertTrue(equal)
        }
    }
    
    func testGCD() {
        let a = 1000
        let b = 12500
        XCTAssertEqual(greatestCommonDivisor(0, a), a)
        XCTAssertEqual(greatestCommonDivisor(b, 0), b)
        XCTAssertEqual(greatestCommonDivisor(a, b), 500)
    }

    func testLCM() {
        let a = 345
        let b = 65
        XCTAssertEqual(leastCommonMultiple(a, b), 4485)
    }

    func testFactorial() {
        var currentFactorial = 1
        for i: Int in 1...10 {
            currentFactorial *= i
            XCTAssertEqual(currentFactorial, factorial(i))
        }
    }

    func testDivisors() {
        XCTAssertEqual(35.divisors(), Set([1, 5, 7, 35]))
    }

    func testProperDivisors() {
        XCTAssertEqual(35.properDivisors(), Set([1, 5, 7]))
    }

    func testSum() {
        XCTAssertEqual([1, 2, 3].sum(), 6)

        let a: [Double] = [1.1, 2.2, 3.3]
        XCTAssertEqual(a.sum(), 6.6)

        let b: [Float] = [1.1, 2.2, 3.3]
        let computedFloatSum = b.sum()
        let expectedFloatSum = Float(6.6)
        XCTAssertEqualWithAccuracy(computedFloatSum, expectedFloatSum, accuracy: Float(0.01))

        let c: [Float80] = [1.1, 2.2, 3.3]
        let computedFloat80Sum = c.sum()
        let expectedFloat80Sum = Float80(6.6)
        let difference = abs(computedFloat80Sum - expectedFloat80Sum)
        let accuracy = Float80(0.01) - difference
        let result = accuracy >= Float80(0)
        XCTAssert(result)
    }

    func romanNumeralTestCases() -> [String] {
        return [ "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX", "XXI", "XXII", "XXIII", "XXIV", "XXV", "XXVI", "XXVII", "XXVIII", "XXIX", "XXX", "XXXI", "XXXII", "XXXIII", "XXXIV", "XXXV", "XXXVI", "XXXVII", "XXXVIII", "XXXIX", "XL", "XLI", "XLII", "XLIII", "XLIV", "XLV", "XLVI", "XLVII", "XLVIII", "XLIX", "L", "LI", "LII", "LIII", "LIV", "LV", "LVI", "LVII", "LVIII", "LIX", "LX", "LXI", "LXII", "LXIII", "LXIV", "LXV", "LXVI", "LXVII", "LXVIII", "LXIX", "LXX", "LXXI", "LXXII", "LXXIII", "LXXIV", "LXXV", "LXXVI", "LXXVII", "LXXVIII", "LXXIX", "LXXX", "LXXXI", "LXXXII", "LXXXIII", "LXXXIV", "LXXXV", "LXXXVI", "LXXXVII", "LXXXVIII", "LXXXIX", "XC", "XCI", "XCII", "XCIII", "XCIV", "XCV", "XCVI", "XCVII", "XCVIII", "XCIX", "C", "CI", "CII", "CIII", "CIV", "CV", "CVI", "CVII", "CVIII", "CIX", "CX", "CXI", "CXII", "CXIII", "CXIV", "CXV", "CXVI", "CXVII", "CXVIII", "CXIX", "CXX", "CXXI", "CXXII", "CXXIII", "CXXIV", "CXXV", "CXXVI", "CXXVII", "CXXVIII", "CXXIX", "CXXX", "CXXXI", "CXXXII", "CXXXIII", "CXXXIV", "CXXXV", "CXXXVI", "CXXXVII", "CXXXVIII", "CXXXIX", "CXL", "CXLI", "CXLII", "CXLIII", "CXLIV", "CXLV", "CXLVI", "CXLVII", "CXLVIII", "CXLIX", "CL", "CLI", "CLII", "CLIII", "CLIV", "CLV", "CLVI", "CLVII", "CLVIII", "CLIX", "CLX", "CLXI", "CLXII", "CLXIII", "CLXIV", "CLXV", "CLXVI", "CLXVII", "CLXVIII", "CLXIX", "CLXX", "CLXXI", "CLXXII", "CLXXIII", "CLXXIV", "CLXXV", "CLXXVI", "CLXXVII", "CLXXVIII", "CLXXIX", "CLXXX", "CLXXXI", "CLXXXII", "CLXXXIII", "CLXXXIV", "CLXXXV", "CLXXXVI", "CLXXXVII", "CLXXXVIII", "CLXXXIX", "CXC", "CXCI", "CXCII", "CXCIII", "CXCIV", "CXCV", "CXCVI", "CXCVII", "CXCVIII", "CXCIX", "CC", "CCI", "CCII", "CCIII", "CCIV", "CCV", "CCVI", "CCVII", "CCVIII", "CCIX", "CCX", "CCXI", "CCXII", "CCXIII", "CCXIV", "CCXV", "CCXVI", "CCXVII", "CCXVIII", "CCXIX", "CCXX", "CCXXI", "CCXXII", "CCXXIII", "CCXXIV", "CCXXV", "CCXXVI", "CCXXVII", "CCXXVIII", "CCXXIX", "CCXXX", "CCXXXI", "CCXXXII", "CCXXXIII", "CCXXXIV", "CCXXXV", "CCXXXVI", "CCXXXVII", "CCXXXVIII", "CCXXXIX", "CCXL", "CCXLI", "CCXLII", "CCXLIII", "CCXLIV", "CCXLV", "CCXLVI", "CCXLVII", "CCXLVIII", "CCXLIX", "CCL", "CCLI", "CCLII", "CCLIII", "CCLIV", "CCLV", "CCLVI", "CCLVII", "CCLVIII", "CCLIX", "CCLX", "CCLXI", "CCLXII", "CCLXIII", "CCLXIV", "CCLXV", "CCLXVI", "CCLXVII", "CCLXVIII", "CCLXIX", "CCLXX", "CCLXXI", "CCLXXII", "CCLXXIII", "CCLXXIV", "CCLXXV", "CCLXXVI", "CCLXXVII", "CCLXXVIII", "CCLXXIX", "CCLXXX", "CCLXXXI", "CCLXXXII", "CCLXXXIII", "CCLXXXIV", "CCLXXXV", "CCLXXXVI", "CCLXXXVII", "CCLXXXVIII", "CCLXXXIX", "CCXC", "CCXCI", "CCXCII", "CCXCIII", "CCXCIV", "CCXCV", "CCXCVI", "CCXCVII", "CCXCVIII", "CCXCIX", "CCC", "CCCI", "CCCII", "CCCIII", "CCCIV", "CCCV", "CCCVI", "CCCVII", "CCCVIII", "CCCIX", "CCCX", "CCCXI", "CCCXII", "CCCXIII", "CCCXIV", "CCCXV", "CCCXVI", "CCCXVII", "CCCXVIII", "CCCXIX", "CCCXX", "CCCXXI", "CCCXXII", "CCCXXIII", "CCCXXIV", "CCCXXV", "CCCXXVI", "CCCXXVII", "CCCXXVIII", "CCCXXIX", "CCCXXX", "CCCXXXI", "CCCXXXII", "CCCXXXIII", "CCCXXXIV", "CCCXXXV", "CCCXXXVI", "CCCXXXVII", "CCCXXXVIII", "CCCXXXIX", "CCCXL", "CCCXLI", "CCCXLII", "CCCXLIII", "CCCXLIV", "CCCXLV", "CCCXLVI", "CCCXLVII", "CCCXLVIII", "CCCXLIX", "CCCL", "CCCLI", "CCCLII", "CCCLIII", "CCCLIV", "CCCLV", "CCCLVI", "CCCLVII", "CCCLVIII", "CCCLIX", "CCCLX", "CCCLXI", "CCCLXII", "CCCLXIII", "CCCLXIV", "CCCLXV", "CCCLXVI", "CCCLXVII", "CCCLXVIII", "CCCLXIX", "CCCLXX", "CCCLXXI", "CCCLXXII", "CCCLXXIII", "CCCLXXIV", "CCCLXXV", "CCCLXXVI", "CCCLXXVII", "CCCLXXVIII", "CCCLXXIX", "CCCLXXX", "CCCLXXXI", "CCCLXXXII", "CCCLXXXIII", "CCCLXXXIV", "CCCLXXXV", "CCCLXXXVI", "CCCLXXXVII", "CCCLXXXVIII", "CCCLXXXIX", "CCCXC", "CCCXCI", "CCCXCII", "CCCXCIII", "CCCXCIV", "CCCXCV", "CCCXCVI", "CCCXCVII", "CCCXCVIII", "CCCXCIX", "CD", "CDI", "CDII", "CDIII", "CDIV", "CDV", "CDVI", "CDVII", "CDVIII", "CDIX", "CDX", "CDXI", "CDXII", "CDXIII", "CDXIV", "CDXV", "CDXVI", "CDXVII", "CDXVIII", "CDXIX", "CDXX", "CDXXI", "CDXXII", "CDXXIII", "CDXXIV", "CDXXV", "CDXXVI", "CDXXVII", "CDXXVIII", "CDXXIX", "CDXXX", "CDXXXI", "CDXXXII", "CDXXXIII", "CDXXXIV", "CDXXXV", "CDXXXVI", "CDXXXVII", "CDXXXVIII", "CDXXXIX", "CDXL", "CDXLI", "CDXLII", "CDXLIII", "CDXLIV", "CDXLV", "CDXLVI", "CDXLVII", "CDXLVIII", "CDXLIX", "CDL", "CDLI", "CDLII", "CDLIII", "CDLIV", "CDLV", "CDLVI", "CDLVII", "CDLVIII", "CDLIX", "CDLX", "CDLXI", "CDLXII", "CDLXIII", "CDLXIV", "CDLXV", "CDLXVI", "CDLXVII", "CDLXVIII", "CDLXIX", "CDLXX", "CDLXXI", "CDLXXII", "CDLXXIII", "CDLXXIV", "CDLXXV", "CDLXXVI", "CDLXXVII", "CDLXXVIII", "CDLXXIX", "CDLXXX", "CDLXXXI", "CDLXXXII", "CDLXXXIII", "CDLXXXIV", "CDLXXXV", "CDLXXXVI", "CDLXXXVII", "CDLXXXVIII", "CDLXXXIX", "CDXC", "CDXCI", "CDXCII", "CDXCIII", "CDXCIV", "CDXCV", "CDXCVI", "CDXCVII", "CDXCVIII", "CDXCIX", "D", "DI", "DII", "DIII", "DIV", "DV", "DVI", "DVII", "DVIII", "DIX", "DX", "DXI", "DXII", "DXIII", "DXIV", "DXV", "DXVI", "DXVII", "DXVIII", "DXIX", "DXX", "DXXI", "DXXII", "DXXIII", "DXXIV", "DXXV", "DXXVI", "DXXVII", "DXXVIII", "DXXIX", "DXXX", "DXXXI", "DXXXII", "DXXXIII", "DXXXIV", "DXXXV", "DXXXVI", "DXXXVII", "DXXXVIII", "DXXXIX", "DXL", "DXLI", "DXLII", "DXLIII", "DXLIV", "DXLV", "DXLVI", "DXLVII", "DXLVIII", "DXLIX", "DL", "DLI", "DLII", "DLIII", "DLIV", "DLV", "DLVI", "DLVII", "DLVIII", "DLIX", "DLX", "DLXI", "DLXII", "DLXIII", "DLXIV", "DLXV", "DLXVI", "DLXVII", "DLXVIII", "DLXIX", "DLXX", "DLXXI", "DLXXII", "DLXXIII", "DLXXIV", "DLXXV", "DLXXVI", "DLXXVII", "DLXXVIII", "DLXXIX", "DLXXX", "DLXXXI", "DLXXXII", "DLXXXIII", "DLXXXIV", "DLXXXV", "DLXXXVI", "DLXXXVII", "DLXXXVIII", "DLXXXIX", "DXC", "DXCI", "DXCII", "DXCIII", "DXCIV", "DXCV", "DXCVI", "DXCVII", "DXCVIII", "DXCIX", "DC", "DCI", "DCII", "DCIII", "DCIV", "DCV", "DCVI", "DCVII", "DCVIII", "DCIX", "DCX", "DCXI", "DCXII", "DCXIII", "DCXIV", "DCXV", "DCXVI", "DCXVII", "DCXVIII", "DCXIX", "DCXX", "DCXXI", "DCXXII", "DCXXIII", "DCXXIV", "DCXXV", "DCXXVI", "DCXXVII", "DCXXVIII", "DCXXIX", "DCXXX", "DCXXXI", "DCXXXII", "DCXXXIII", "DCXXXIV", "DCXXXV", "DCXXXVI", "DCXXXVII", "DCXXXVIII", "DCXXXIX", "DCXL", "DCXLI", "DCXLII", "DCXLIII", "DCXLIV", "DCXLV", "DCXLVI", "DCXLVII", "DCXLVIII", "DCXLIX", "DCL", "DCLI", "DCLII", "DCLIII", "DCLIV", "DCLV", "DCLVI", "DCLVII", "DCLVIII", "DCLIX", "DCLX", "DCLXI", "DCLXII", "DCLXIII", "DCLXIV", "DCLXV", "DCLXVI", "DCLXVII", "DCLXVIII", "DCLXIX", "DCLXX", "DCLXXI", "DCLXXII", "DCLXXIII", "DCLXXIV", "DCLXXV", "DCLXXVI", "DCLXXVII", "DCLXXVIII", "DCLXXIX", "DCLXXX", "DCLXXXI", "DCLXXXII", "DCLXXXIII", "DCLXXXIV", "DCLXXXV", "DCLXXXVI", "DCLXXXVII", "DCLXXXVIII", "DCLXXXIX", "DCXC", "DCXCI", "DCXCII", "DCXCIII", "DCXCIV", "DCXCV", "DCXCVI", "DCXCVII", "DCXCVIII", "DCXCIX", "DCC", "DCCI", "DCCII", "DCCIII", "DCCIV", "DCCV", "DCCVI", "DCCVII", "DCCVIII", "DCCIX", "DCCX", "DCCXI", "DCCXII", "DCCXIII", "DCCXIV", "DCCXV", "DCCXVI", "DCCXVII", "DCCXVIII", "DCCXIX", "DCCXX", "DCCXXI", "DCCXXII", "DCCXXIII", "DCCXXIV", "DCCXXV", "DCCXXVI", "DCCXXVII", "DCCXXVIII", "DCCXXIX", "DCCXXX", "DCCXXXI", "DCCXXXII", "DCCXXXIII", "DCCXXXIV", "DCCXXXV", "DCCXXXVI", "DCCXXXVII", "DCCXXXVIII", "DCCXXXIX", "DCCXL", "DCCXLI", "DCCXLII", "DCCXLIII", "DCCXLIV", "DCCXLV", "DCCXLVI", "DCCXLVII", "DCCXLVIII", "DCCXLIX", "DCCL", "DCCLI", "DCCLII", "DCCLIII", "DCCLIV", "DCCLV", "DCCLVI", "DCCLVII", "DCCLVIII", "DCCLIX", "DCCLX", "DCCLXI", "DCCLXII", "DCCLXIII", "DCCLXIV", "DCCLXV", "DCCLXVI", "DCCLXVII", "DCCLXVIII", "DCCLXIX", "DCCLXX", "DCCLXXI", "DCCLXXII", "DCCLXXIII", "DCCLXXIV", "DCCLXXV", "DCCLXXVI", "DCCLXXVII", "DCCLXXVIII", "DCCLXXIX", "DCCLXXX", "DCCLXXXI", "DCCLXXXII", "DCCLXXXIII", "DCCLXXXIV", "DCCLXXXV", "DCCLXXXVI", "DCCLXXXVII", "DCCLXXXVIII", "DCCLXXXIX", "DCCXC", "DCCXCI", "DCCXCII", "DCCXCIII", "DCCXCIV", "DCCXCV", "DCCXCVI", "DCCXCVII", "DCCXCVIII", "DCCXCIX", "DCCC", "DCCCI", "DCCCII", "DCCCIII", "DCCCIV", "DCCCV", "DCCCVI", "DCCCVII", "DCCCVIII", "DCCCIX", "DCCCX", "DCCCXI", "DCCCXII", "DCCCXIII", "DCCCXIV", "DCCCXV", "DCCCXVI", "DCCCXVII", "DCCCXVIII", "DCCCXIX", "DCCCXX", "DCCCXXI", "DCCCXXII", "DCCCXXIII", "DCCCXXIV", "DCCCXXV", "DCCCXXVI", "DCCCXXVII", "DCCCXXVIII", "DCCCXXIX", "DCCCXXX", "DCCCXXXI", "DCCCXXXII", "DCCCXXXIII", "DCCCXXXIV", "DCCCXXXV", "DCCCXXXVI", "DCCCXXXVII", "DCCCXXXVIII", "DCCCXXXIX", "DCCCXL", "DCCCXLI", "DCCCXLII", "DCCCXLIII", "DCCCXLIV", "DCCCXLV", "DCCCXLVI", "DCCCXLVII", "DCCCXLVIII", "DCCCXLIX", "DCCCL", "DCCCLI", "DCCCLII", "DCCCLIII", "DCCCLIV", "DCCCLV", "DCCCLVI", "DCCCLVII", "DCCCLVIII", "DCCCLIX", "DCCCLX", "DCCCLXI", "DCCCLXII", "DCCCLXIII", "DCCCLXIV", "DCCCLXV", "DCCCLXVI", "DCCCLXVII", "DCCCLXVIII", "DCCCLXIX", "DCCCLXX", "DCCCLXXI", "DCCCLXXII", "DCCCLXXIII", "DCCCLXXIV", "DCCCLXXV", "DCCCLXXVI", "DCCCLXXVII", "DCCCLXXVIII", "DCCCLXXIX", "DCCCLXXX", "DCCCLXXXI", "DCCCLXXXII", "DCCCLXXXIII", "DCCCLXXXIV", "DCCCLXXXV", "DCCCLXXXVI", "DCCCLXXXVII", "DCCCLXXXVIII", "DCCCLXXXIX", "DCCCXC", "DCCCXCI", "DCCCXCII", "DCCCXCIII", "DCCCXCIV", "DCCCXCV", "DCCCXCVI", "DCCCXCVII", "DCCCXCVIII", "DCCCXCIX", "CM", "CMI", "CMII", "CMIII", "CMIV", "CMV", "CMVI", "CMVII", "CMVIII", "CMIX", "CMX", "CMXI", "CMXII", "CMXIII", "CMXIV", "CMXV", "CMXVI", "CMXVII", "CMXVIII", "CMXIX", "CMXX", "CMXXI", "CMXXII", "CMXXIII", "CMXXIV", "CMXXV", "CMXXVI", "CMXXVII", "CMXXVIII", "CMXXIX", "CMXXX", "CMXXXI", "CMXXXII", "CMXXXIII", "CMXXXIV", "CMXXXV", "CMXXXVI", "CMXXXVII", "CMXXXVIII", "CMXXXIX", "CMXL", "CMXLI", "CMXLII", "CMXLIII", "CMXLIV", "CMXLV", "CMXLVI", "CMXLVII", "CMXLVIII", "CMXLIX", "CML", "CMLI", "CMLII", "CMLIII", "CMLIV", "CMLV", "CMLVI", "CMLVII", "CMLVIII", "CMLIX", "CMLX", "CMLXI", "CMLXII", "CMLXIII", "CMLXIV", "CMLXV", "CMLXVI", "CMLXVII", "CMLXVIII", "CMLXIX", "CMLXX", "CMLXXI", "CMLXXII", "CMLXXIII", "CMLXXIV", "CMLXXV", "CMLXXVI", "CMLXXVII", "CMLXXVIII", "CMLXXIX", "CMLXXX", "CMLXXXI", "CMLXXXII", "CMLXXXIII", "CMLXXXIV", "CMLXXXV", "CMLXXXVI", "CMLXXXVII", "CMLXXXVIII", "CMLXXXIX", "CMXC", "CMXCI", "CMXCII", "CMXCIII", "CMXCIV", "CMXCV", "CMXCVI", "CMXCVII", "CMXCVIII", "CMXCIX", "M"]
    }

    func testToRomanNumerals() {

        let cases = self.romanNumeralTestCases()
        for testCase in cases {
            let numericValue: Int = cases.index(of: testCase)! + 1
            XCTAssertEqual(testCase, numericValue.romanNumeral())
        }

    }

    func testFromRomanNumerals() {

        let cases = self.romanNumeralTestCases()
        for testCase in cases {
            let numericValue: Int = cases.index(of: testCase)! + 1
            XCTAssertEqual(Int(romanNumeral: testCase), numericValue)
        }
    }

    func testAllPermutations() {
        let items = [ "a", "b", "c", "d", "e" ]
        let permutations = allPermutations(items)

        XCTAssert(permutations.count == factorial(items.count))
        var seenPermutations = [[AnyObject]]()
        for permutation in permutations {
            for item in permutation {
                XCTAssert(items.contains(item))
            }
            XCTAssert(!seenPermutations.contains(where: {($0 as! [String]) == permutation}))
            seenPermutations.append(permutation as [AnyObject])
        }
    }

    func testLexicographicPermutations() {
        let items = ["a", "b", "c", "d" ]
        permuteLexicographically(items as [AnyObject], distance: 5)
        NSLog("\(allPermutations(items))")
        NSLog("answer: \(items)")
    }
    
}
