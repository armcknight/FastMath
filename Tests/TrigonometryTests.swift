//
//  TrigonometryTests.swift
//  FastMath
//
//  Created by Andrew McKnight on 9/11/18.
//

import Foundation
@testable import FastMath
import XCTest

class TrigonometryTests: XCTestCase {
    func testClockwiseConversion() {
        let counterclockwiseToClockwiseMap: [Degree: Degree] = [
            0: 0,
            1: 359,
            45: 315,
            90: 270,
            179: 181,
            180: 180,
            181: 179,
            270: 90,
            315: 45,
            359: 1,
            400: 320
        ]
        counterclockwiseToClockwiseMap.forEach { counterclockwise, clockwise in
            let angle = Angle(degrees: counterclockwise, orientation: .counterclockwise)
            let clockwiseCalculated = angle.clockwise.degrees
            XCTAssertEqual(clockwise, clockwiseCalculated, accuracy: 1e-13, "expected \(clockwise), got \(clockwiseCalculated)")
        }
    }
}
