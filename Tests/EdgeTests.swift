//
//  EdgeTests.swift
//  Pods
//
//  Created by Andrew McKnight on 12/6/19.
//

@testable import FastMath
import XCTest

class EdgeTests: XCTestCase {
    func testEquivalentEdges() {
        let a = Edge(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4))
        let b = Edge(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4))
        XCTAssertEqual(a, b)

        let c = Edge(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), name: "c")
        let d = Edge(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), name: "d")
        XCTAssertEqual(c, d)
    }

    func testUnequivalentEdges() {
        let a = Edge(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4))
        let b = Edge(x: Vertex(x: 1, y: 2), y: Vertex(x: 5, y: 4))
        XCTAssertNotEqual(a, b)

        let c = Edge(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), name: "z")
        let d = Edge(x: Vertex(x: 1, y: 2), y: Vertex(x: 5, y: 4), name: "z")
        XCTAssertNotEqual(c, d)
    }
}
