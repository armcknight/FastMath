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
    
    func testTriangleEquality() {
        let x = Vertex(x: 1, y: 2, name: "x")
        let y = Vertex(x: 3, y: 4, name: "y")
        let z = Vertex(x: 5, y: 6, name: "z")
        let a = Triangle(edge: Edge(x: x, y: y, name: "m"), point: z, name: "a")
        let b = Triangle(edge: Edge(x: y, y: z, name: "n"), point: x, name: "b")
        XCTAssertEqual(a, b)
        
        let w = Vertex(x: 0, y: 0, name: "w")
        let c = Triangle(x: w, y: x, z: y, name: "c")
        XCTAssertNotEqual(a, c)
        XCTAssertNotEqual(b, c)
    }
    
    func testTriangularNumbers() {
        XCTAssertEqual(7.triangularNumber(), 28)
    }
    
}
