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
        let x = Vertex(x: 0, y: 0, name: "x")
        let y = Vertex(x: 10, y: 0, name: "y")
        let z = Vertex(x: 5, y: 5, name: "z")
        let input: Set<Vertex> = [x, z, y]
        let expected = [x, y, z]
        let computed = input.sortedLexicographically()

        XCTAssertEqual(computed, expected)
    }
    
    func testCounterclockwiseSortElementCountAssertion() {
        let x = Vertex(x: 0, y: 0, name: "x")
        let y = Vertex(x: 10, y: 0, name: "y")
        let _ = Set<Vertex>([x, y]).counterClockwiseOrder()
        XCTFail("Should have failed")
    }

    func testCounterclockwiseOrdering() {
        let a = Vertex(x: 3, y: 1, name: "a")
        let b = Vertex(x: 4, y: 1, name: "b")
        let c = Vertex(x: 5, y: 2, name: "c")
        let d = Vertex(x: 5, y: 3, name: "d")
        let e = Vertex(x: 4, y: 4, name: "e")
        let f = Vertex(x: 3, y: 4, name: "f")
        let g = Vertex(x: 2, y: 3, name: "g")
        let h = Vertex(x: 2, y: 2, name: "h")
        let points: Set<Vertex> = [a, b, c, d, e, f, g, h]

        let expected = [a, b, c, d, e, f, g, h]
        let computed = points.counterClockwiseOrder()
        XCTAssert(expected.elementsEqual(computed))
    }
    
    func testCounterclockwiseOrderingWithGhostPoints() {
        let a = Vertex(x: 3, y: 1, name: "a")
        let b = Vertex(x: 4, y: 1, name: "b")
        let c = Vertex(x: 5, y: 2, name: "c")
        let d = Vertex(x: 5, y: 3, name: "d")
        let e = Vertex(x: 4, y: 4, name: "e")
        let f = Vertex(x: 3, y: 4, name: "f")
        let g = Vertex(x: 2, y: 3, name: "g")
        let h = Vertex(x: 2, y: 2, name: "h")
        let pointsWithGhosts: Set<Vertex> = [a, b, c, d, e, f, g, h, ghost2, ghost1]

        let expected = [a, b, c, d, e, f, g, h, ghost2, ghost1]
        let computed = pointsWithGhosts.counterClockwiseOrder()

        print("done")
    }

    func testConvexHull() {
        let points: Set<Vertex> = [
            Vertex(x: 1, y: 2, name: "a"),
            Vertex(x: 4, y: 4, name: "b"),
            Vertex(x: 8, y: 2, name: "c"),
            Vertex(x: 3, y: 7, name: "d"),
            Vertex(x: 1, y: 2, name: "e"),
            Vertex(x: 5, y: 4, name: "f"),
            Vertex(x: 7, y: 9, name: "g"),
        ]

        let computed = points.convexHull()
        print(computed)
    }

    func testOrientation() {
        let x = Vertex(x: 0, y: 0, name: "a")
        let y = Vertex(x: 10, y: 0, name: "b")
        let z = Vertex(x: 5, y: 5, name: "c")

        let permutations: [NSArray: Bool] = [
            [x, y, z]: true,
            [y, z, x]: true,
            [z, x, y]: true,
            [x, z, y]: false,
            [z, y, x]: false,
            [y, x, z]: false
        ]

        var i = 0
        for arg in permutations {
            let (permutation, expected) = arg
            let edge = Edge(x: permutation[0] as! Vertex, y: permutation[1] as! Vertex, name: "Edge \(i)")
            i += 0
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
            Vertex(x: 0, y: 0, name: "a"),
            Vertex(x: 100, y: 0, name: "b"),
            Vertex(x: 50, y: 50, name: "c"),
            Vertex(x: 50, y: 75, name: "d"),
        ]
    }

    func caseB() -> [Vertex] {
        return [
            Vertex(x: 71.0, y: 516.33332824707, name: "a"),
            Vertex(x: 314.0, y: 448.0, name: "b"),
            Vertex(x: 97.6666564941406, y: 214.666656494141, name: "c"),
            Vertex(x: 304.33332824707, y: 164.0, name: "d"),
            Vertex(x: 31.6666564941406, y: 73.6666564941406, name: "e"),
        ]
    }

    func caseC() -> [Vertex] {
        return [
            Vertex(x: 309.33332824707, y: 522.33332824707, name: "a"),
            Vertex(x: 121.0, y: 515.666656494141, name: "b"),
            Vertex(x: 127.0, y: 320.0, name: "c"),
            Vertex(x: 295.0, y: 281.33332824707, name: "d"),
            Vertex(x: 43.6666564941406, y: 245.666656494141, name: "e"),
        ]
    }

    func caseD() -> (input: Set<Vertex>, expected: Set<Triangle>) {
        let input = Set([
            Vertex(x: 87.7, y: 166.3, name: "a"),
            Vertex(x: 205.3, y: 167.0, name: "b"),
            Vertex(x: 73.0, y: 264.3, name: "c"),
            Vertex(x: 115.3, y: 310.0, name: "d"),
            Vertex(x: 211.7, y: 307.0, name: "e"),
            Vertex(x: 227.3, y: 232.3, name: "f"),
            Vertex(x: 320.3, y: 123.3, name: "g"),
        ])

        let expected = Set([
            Triangle(x: Vertex(x:211.7, y:307.0, name: "A:a"), y: Vertex(x:227.3, y:232.3, name: "A:b"), z: Vertex(x:320.3, y:123.3, name: "A:c"), name: "A"),
            Triangle(x: Vertex(x:227.3, y:232.3, name: "B:a"), y: Vertex(x:205.3, y:167.0, name: "B:"), z: Vertex(x:320.3, y:123.3, name: "B:c"), name: "B"),
            Triangle(x: Vertex(x:205.3, y:167.0, name: "C:a"), y: Vertex(x:87.7, y:166.3, name: "C:b"), z: Vertex(x:320.3, y:123.3, name: "C:c"), name: "C"),
            Triangle(x: Vertex(x:227.3, y:232.3, name: "D:a"), y: Vertex(x:87.7, y:166.3, name: "D:b"), z: Vertex(x:205.3, y:167.0, name: "D:c"), name: "D"),
            Triangle(x: Vertex(x:227.3, y:232.3, name: "E:a"), y: Vertex(x:73.0, y:264.3, name: "E:b"), z: Vertex(x:87.7, y:166.3, name: "E:c"), name: "E"),
            Triangle(x: Vertex(x:115.3, y:310.0, name: "F:a"), y: Vertex(x:73.0, y:264.3, name: "F:b"), z: Vertex(x:227.3, y:232.3, name: "F:c"), name: "F"),
            Triangle(x: Vertex(x:115.3, y:310.0, name: "G:a"), y: Vertex(x:227.3, y:232.3, name: "G:b"), z: Vertex(x:211.7, y:307.0, name: "G:c"), name: "G"),
        ])

        return (input, expected)
    }
    
    func testTriangularNumbers() {
        XCTAssertEqual(7.triangularNumber(), 28)
    }
    
}
