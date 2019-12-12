//
//  VertexTests.swift
//  Pods
//
//  Created by Andrew McKnight on 12/6/19.
//

@testable import FastMath
import XCTest

class VertexTests: XCTestCase {
    func testEquivalentVertices() {
        let a = Vertex(x: 1, y: 2)
        let b = Vertex(x: 1, y: 2)
        XCTAssertEqual(a, b)

        let c = Vertex(x: 1, y: 2, name: "c")
        let d = Vertex(x: 1, y: 2, name: "d")
        XCTAssertEqual(c, d)
    }
    
    func testEquivalentVerticesFromCGPoints() {
        let a = Vertex(point: CGPoint(x: 1, y: 2))
        let b = Vertex(point: CGPoint(x: 1, y: 2))
        XCTAssertEqual(a, b)

        let c = Vertex(point: CGPoint(x: 1, y: 2), name: "c")
        let d = Vertex(point: CGPoint(x: 1, y: 2), name: "d")
        XCTAssertEqual(c, d)
    }

    func testUnequivalentVertices() {
        let a = Vertex(x: 2, y: 2)
        let b = Vertex(x: 1, y: 2)
        XCTAssertNotEqual(a, b)

        let c = Vertex(x: 2, y: 2, name: "z")
        let d = Vertex(x: 1, y: 2, name: "z")
        XCTAssertNotEqual(c, d)
    }

    func testEquivalentVertexSets() {
        let a = Set<Vertex>(
            [
                Vertex(x: 1, y: 2),
                Vertex(x: 3, y: 4),
                Vertex(x: 5, y: 6),
            ]
        )
        let b = Set<Vertex>(
            [
                Vertex(x: 1, y: 2),
                Vertex(x: 3, y: 4),
                Vertex(x: 5, y: 6),
            ]
        )
        XCTAssertEqual(a, b)
    }

    func testUnequivalentVertexSets() {
        let a = Set<Vertex>(
            [
                Vertex(x: 1, y: 2),
                Vertex(x: 5, y: 4),
                Vertex(x: 5, y: 6),
            ]
        )
        let b = Set<Vertex>(
            [
                Vertex(x: 1, y: 2),
                Vertex(x: 3, y: 4),
                Vertex(x: 5, y: 6),
            ]
        )
        XCTAssertNotEqual(a, b)
    }
}
