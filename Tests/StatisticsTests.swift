//
//  StatisticsTests.swift
//  FastMath-Unit-Tests
//
//  Created by Andrew McKnight on 1/9/19.
//

import FastMath
import XCTest

/// Test cases made with help in part from https://www.calculator.net/standard-deviation-calculator.html
class StatisticsTests: XCTestCase {
    typealias TestCase = (
        dataSet: [Int],
        sum: Int,
        mean: Double,
        variance: Double,
        stdDev: Double,
        zScores: [Double],
        normalDistribution: HistogramCount
    )
    let testCases: [TestCase] = [
        ([], 0, 0, 0, 0, [], [:]),
        ([1, 2, 3, 4, 5], 15, 3, 2, 1.4142135623731, [], ["-2.0": 0, "-1.0": 1, "0.0": 3, "1.0": 1, "2.0": 0]),
        ([-1, 1], 0, 0, 1, 1, [], ["-1.0": 0, "0.0": 1, "1.0": 1]),
        ([0, 0, 0], 0, 0, 0, 0, [], ["0.0": 3]),
        ([10, 2, 38, 23, 38, 23, 21], 155, 22.142857142857, 151.26530612245, 12.298996142875, [], ["-2.0": 0, "-1.0": 1, "0.0": 4, "1.0": 2, "2.0": 0])
    ]
    
    func testStatistics() {
        for testCase in testCases {
            XCTAssertEqual(testCase.dataSet.sum(), testCase.sum, "\(testCase.dataSet)")
            XCTAssertEqual(testCase.dataSet.mean(), testCase.mean, accuracy: 1e-11, "difference of \(fabs(testCase.dataSet.mean() - testCase.mean))")
            XCTAssertEqual(testCase.dataSet.variance(), testCase.variance, accuracy: 1e-11, "difference of \(fabs(testCase.dataSet.variance() - testCase.variance))")
            XCTAssertEqual(testCase.dataSet.standardDeviation(), testCase.stdDev, accuracy: 1e-12, "difference of \(fabs(testCase.dataSet.standardDeviation() - testCase.stdDev))")
            XCTAssertEqual(testCase.dataSet.normalDistribution(), testCase.normalDistribution, "expected \(testCase.normalDistribution), got \(testCase.dataSet.normalDistribution())")
        }
    }
}
