//
//  FastMathTests.swift
//  FastMathTests
//
//  Created by Andrew McKnight on 11/14/17.
//  Copyright © 2017 old dominion university. All rights reserved.
//

@testable import FastMath
import XCTest

class FastMathTests: XCTestCase {

    func testLexicographicSort() {
        let x = Vertex(x: 0, y: 0)
        let y = Vertex(x: 10, y: 0)
        let z = Vertex(x: 5, y: 5)
        let input: Set<Vertex> = [x, z, y]
        let expected = [x, y, z]
        let computed = input.sortedLexicographically()

        XCTAssertEqual(computed, expected)
    }

    func testCounterclockwiseOrdering() {
        let points: Set<Vertex> = [
            Vertex(x: 0, y: 0),
            Vertex(x: 2, y: 2),
            Vertex(x: 5, y: 0),
            ]

        let computed = points.counterClockwiseOrder()

        let pointsWithGhosts: Set<Vertex> = [
            Vertex(x: 0, y: 0),
            Vertex(x: 2, y: 2),
            Vertex(x: 5, y: 0),
            ghost2,
            ghost1
            ]

        let computed2 = pointsWithGhosts.counterClockwiseOrder()

        print("done")
    }

    func testConvexHull() {
        let points: Set<Vertex> = [
            Vertex(x: 1, y: 2),
            Vertex(x: 4, y: 4),
            Vertex(x: 8, y: 2),
            Vertex(x: 3, y: 7),
            Vertex(x: 1, y: 2),
            Vertex(x: 5, y: 4),
            Vertex(x: 7, y: 9),
        ]

        let computed = points.convexHull()
        print(computed)
    }

    func testOrientation() {
        let x = Vertex(x: 0, y: 0)
        let y = Vertex(x: 10, y: 0)
        let z = Vertex(x: 5, y: 5)

        let permutations: [NSArray: Bool] = [
            [x, y, z]: true,
            [y, z, x]: true,
            [z, x, y]: true,
            [x, z, y]: false,
            [z, y, x]: false,
            [y, x, z]: false
        ]

        for arg in permutations {
            let (permutation, expected) = arg
            let edge = Edge(x: permutation[0] as! Vertex, y: permutation[1] as! Vertex)
            let vertex = permutation[2] as! Vertex

            let computed = vertex.liesToLeft(ofEdge:edge)
            XCTAssertEqual(computed, expected)
        }
    }

    func testTriangulation() {
        let (points, expected) = caseD()
        let triangulator = DelaunayTriangulator()
        let triangulation = triangulator.triangulate(points: points)
        guard let triangles = triangulation?.getTriangles() else {
            XCTFail("No triangles returned from triangulation.")
            return
        }

        XCTAssertEqual(expected, Set(triangles))
    }
    
    func caseA() -> [Vertex] {
        return [
            Vertex(x: 0, y: 0),
            Vertex(x: 100, y: 0),
            Vertex(x: 50, y: 50),
            Vertex(x: 50, y: 75),
        ]
    }

    func caseB() -> [Vertex] {
        return [
            Vertex(x: 71.0, y: 516.33332824707),
            Vertex(x: 314.0, y: 448.0),
            Vertex(x: 97.6666564941406, y: 214.666656494141),
            Vertex(x: 304.33332824707, y: 164.0),
            Vertex(x: 31.6666564941406, y: 73.6666564941406),
        ]
    }

    func caseC() -> [Vertex] {
        return [
            Vertex(x: 309.33332824707, y: 522.33332824707),
            Vertex(x: 121.0, y: 515.666656494141),
            Vertex(x: 127.0, y: 320.0),
            Vertex(x: 295.0, y: 281.33332824707),
            Vertex(x: 43.6666564941406, y: 245.666656494141),
        ]
    }

    func caseD() -> (input: Set<Vertex>, expected: Set<Triangle>) {
        let input = Set([
            Vertex(x: 87.7, y: 166.3),
            Vertex(x: 205.3, y: 167.0),
            Vertex(x: 73.0, y: 264.3),
            Vertex(x: 115.3, y: 310.0),
            Vertex(x: 211.7, y: 307.0),
            Vertex(x: 227.3, y: 232.3),
            Vertex(x: 320.3, y: 123.3),
        ])

        let expected = Set([
            Triangle(x: Vertex(x:211.7, y:307.0), y: Vertex(x:227.3, y:232.3), z: Vertex(x:320.3, y:123.3)),
            Triangle(x: Vertex(x:227.3, y:232.3), y: Vertex(x:205.3, y:167.0), z: Vertex(x:320.3, y:123.3)),
            Triangle(x: Vertex(x:205.3, y:167.0), y: Vertex(x:87.7, y:166.3), z: Vertex(x:320.3, y:123.3)),
            Triangle(x: Vertex(x:227.3, y:232.3), y: Vertex(x:87.7, y:166.3), z: Vertex(x:205.3, y:167.0)),
            Triangle(x: Vertex(x:227.3, y:232.3), y: Vertex(x:73.0, y:264.3), z: Vertex(x:87.7, y:166.3)),
            Triangle(x: Vertex(x:115.3, y:310.0), y: Vertex(x:73.0, y:264.3), z: Vertex(x:227.3, y:232.3)),
            Triangle(x: Vertex(x:115.3, y:310.0), y: Vertex(x:227.3, y:232.3), z: Vertex(x:211.7, y:307.0)),
        ])

        return (input, expected)
    }
    
    func testTriangularNumbers() {
        XCTAssertEqual(7.triangularNumber(), 28)
    }
    
}
