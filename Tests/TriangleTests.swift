//
//  TriangleTests.swift
//  Pods
//
//  Created by Andrew McKnight on 12/6/19.
//

@testable import FastMath
import XCTest

class TriangleTests: XCTestCase {
    func testEquivalentTriangles() {
        let a = Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6))
        let b = Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6))
        XCTAssertEqual(a, b)

        let c = Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6), name: "c")
        let d = Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6), name: "d")
        XCTAssertEqual(c, d)
    }

    func testEquivalentTrianglesFromCGPoints() {
        let a = Triangle(x: Vertex(point: CGPoint(x: 1, y: 2)), y: Vertex(point: CGPoint(x: 3, y: 4)), z: Vertex(point: CGPoint(x: 5, y: 6)))
        let b = Triangle(x: Vertex(point: CGPoint(x: 1, y: 2)), y: Vertex(point: CGPoint(x: 3, y: 4)), z: Vertex(point: CGPoint(x: 5, y: 6)))
        XCTAssertEqual(a, b)

        let c = Triangle(x: Vertex(point: CGPoint(x: 1, y: 2)), y: Vertex(point: CGPoint(x: 3, y: 4)), z: Vertex(point: CGPoint(x: 5, y: 6)), name: "c")
        let d = Triangle(x: Vertex(point: CGPoint(x: 1, y: 2)), y: Vertex(point: CGPoint(x: 3, y: 4)), z: Vertex(point: CGPoint(x: 5, y: 6)), name: "d")
        XCTAssertEqual(c, d)
    }

    func testUnequivalentTriangles() {
        let a = Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6))
        let b = Triangle(x: Vertex(x: 2, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6))
        XCTAssertNotEqual(a, b)

        let c = Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6), name: "z")
        let d = Triangle(x: Vertex(x: 2, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6), name: "z")
        XCTAssertNotEqual(c, d)
    }

    func testEquivalentTriangleSets() {
        let a = Set<Triangle>([
            Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6)),
            Triangle(x: Vertex(x: 7, y: 8), y: Vertex(x: 9, y: 10), z: Vertex(x: 11, y: 12)),
            Triangle(x: Vertex(x: 13, y: 14), y: Vertex(x: 15, y: 16), z: Vertex(x: 17, y: 18)),
        ])
        let b = Set<Triangle>([
            Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6)),
            Triangle(x: Vertex(x: 7, y: 8), y: Vertex(x: 9, y: 10), z: Vertex(x: 11, y: 12)),
            Triangle(x: Vertex(x: 13, y: 14), y: Vertex(x: 15, y: 16), z: Vertex(x: 17, y: 18)),
        ])
        XCTAssertEqual(a, b)

        let ta = Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6))
        let tb = Triangle(x: Vertex(x: 7, y: 8), y: Vertex(x: 9, y: 10), z: Vertex(x: 11, y: 12))
        let tc = Triangle(x: Vertex(x: 13, y: 14), y: Vertex(x: 15, y: 16), z: Vertex(x: 17, y: 18))
        let c = Set<Triangle>([ta, tb, tc])
        let d = Set<Triangle>([ta, tb, tc])
        XCTAssertEqual(c, d)
    }

    func testEquivalentTriangleSetsWithNames() {
        let a = Set<Triangle>([
            Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6), name: "a"),
            Triangle(x: Vertex(x: 7, y: 8), y: Vertex(x: 9, y: 10), z: Vertex(x: 11, y: 12), name: "b"),
            Triangle(x: Vertex(x: 13, y: 14), y: Vertex(x: 15, y: 16), z: Vertex(x: 17, y: 18), name: "c"),
        ])
        let b = Set<Triangle>([
            Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6), name: "d"),
            Triangle(x: Vertex(x: 7, y: 8), y: Vertex(x: 9, y: 10), z: Vertex(x: 11, y: 12), name: "e"),
            Triangle(x: Vertex(x: 13, y: 14), y: Vertex(x: 15, y: 16), z: Vertex(x: 17, y: 18), name: "f"),
        ])
        XCTAssertEqual(a, b)
    }

    func testEquivalentTriangleSetsWithNamesFromCGPoints() {
        let a = Set<Triangle>([
            Triangle(x: Vertex(point: CGPoint(x: 1, y: 2)), y: Vertex(point: CGPoint(x: 3, y: 4)), z: Vertex(point: CGPoint(x: 5, y: 6)), name: "a"),
            Triangle(x: Vertex(point: CGPoint(x: 7, y: 8)), y: Vertex(point: CGPoint(x: 9, y: 10)), z: Vertex(x: 11, y: 12), name: "b"),
            Triangle(x: Vertex(point: CGPoint(x: 13, y: 14)), y: Vertex(point: CGPoint(x: 15, y: 16)), z: Vertex(point: CGPoint(x: 17, y: 18)), name: "c"),
        ])
        let b = Set<Triangle>([
            Triangle(x: Vertex(point: CGPoint(x: 1, y: 2)), y: Vertex(point: CGPoint(x: 3, y: 4)), z: Vertex(point: CGPoint(x: 5, y: 6)), name: "d"),
            Triangle(x: Vertex(point: CGPoint(x: 7, y: 8)), y: Vertex(point: CGPoint(x: 9, y: 10)), z: Vertex(point: CGPoint(x: 11, y: 12)), name: "e"),
            Triangle(x: Vertex(point: CGPoint(x: 13, y: 14)), y: Vertex(point: CGPoint(x: 15, y: 16)), z: Vertex(point: CGPoint(x: 17, y: 18)), name: "f"),
        ])
        XCTAssertEqual(a, b)
    }

    func testEquivalentTriangleSetsWithNamesForVerticesAndTrianglesFromCGPoints() {
        let a = Set<Triangle>([
            Triangle(x: Vertex(point: CGPoint(x: 1, y: 2), name: "a"), y: Vertex(point: CGPoint(x: 3, y: 4), name: "b"), z: Vertex(point: CGPoint(x: 5, y: 6), name: "c"), name: "a"),
            Triangle(x: Vertex(point: CGPoint(x: 7, y: 8), name: "d"), y: Vertex(point: CGPoint(x: 9, y: 10), name: "e"), z: Vertex(point: CGPoint(x: 11, y: 12), name: "f"), name: "b"),
            Triangle(x: Vertex(point: CGPoint(x: 13, y: 14), name: "g"), y: Vertex(point: CGPoint(x: 15, y: 16), name: "h"), z: Vertex(point: CGPoint(x: 17, y: 18), name: "i"), name: "c"),
        ])
        let b = Set<Triangle>([
            Triangle(x: Vertex(point: CGPoint(x: 1, y: 2), name: "j"), y: Vertex(point: CGPoint(x: 3, y: 4), name: "k"), z: Vertex(point: CGPoint(x: 5, y: 6), name: "l"), name: "d"),
            Triangle(x: Vertex(point: CGPoint(x: 7, y: 8), name: "m"), y: Vertex(point: CGPoint(x: 9, y: 10), name: "n"), z: Vertex(point: CGPoint(x: 11, y: 12), name: "o"), name: "e"),
            Triangle(x: Vertex(point: CGPoint(x: 13, y: 14), name: "p"), y: Vertex(point: CGPoint(x: 15, y: 16), name: "q"), z: Vertex(point: CGPoint(x: 17, y: 18), name: "r"), name: "f"),
        ])
        XCTAssertEqual(a, b)
    }

    func testUnequivalentTriangleSets() {
        let a = Set<Triangle>([
            Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 5, y: 4), z: Vertex(x: 5, y: 6)),
            Triangle(x: Vertex(x: 7, y: 8), y: Vertex(x: 9, y: 10), z: Vertex(x: 11, y: 12)),
            Triangle(x: Vertex(x: 13, y: 14), y: Vertex(x: 15, y: 16), z: Vertex(x: 17, y: 18)),
        ])
        let b = Set<Triangle>([
            Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6)),
            Triangle(x: Vertex(x: 7, y: 8), y: Vertex(x: 9, y: 10), z: Vertex(x: 11, y: 12)),
            Triangle(x: Vertex(x: 13, y: 14), y: Vertex(x: 15, y: 16), z: Vertex(x: 17, y: 18)),
        ])
        XCTAssertNotEqual(a, b)
        XCTAssertEqual(a.symmetricDifference(b).count, 2)
    }

    func testUnequivalentTriangleSetsWithNames() {
        let a = Set<Triangle>([
            Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 5, y: 4), z: Vertex(x: 5, y: 6), name: "a"),
            Triangle(x: Vertex(x: 7, y: 8), y: Vertex(x: 9, y: 10), z: Vertex(x: 11, y: 12), name: "b"),
            Triangle(x: Vertex(x: 13, y: 14), y: Vertex(x: 15, y: 16), z: Vertex(x: 17, y: 18), name: "c"),
        ])
        let b = Set<Triangle>([
            Triangle(x: Vertex(x: 1, y: 2), y: Vertex(x: 3, y: 4), z: Vertex(x: 5, y: 6), name: "d"),
            Triangle(x: Vertex(x: 7, y: 8), y: Vertex(x: 9, y: 10), z: Vertex(x: 11, y: 12), name: "e"),
            Triangle(x: Vertex(x: 13, y: 14), y: Vertex(x: 15, y: 16), z: Vertex(x: 17, y: 18), name: "f"),
        ])
        XCTAssertNotEqual(a, b)
        XCTAssertEqual(a.symmetricDifference(b).count, 2)
    }
}
