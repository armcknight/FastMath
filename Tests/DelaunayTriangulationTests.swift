//
//  DelaunayTriangulationTests.swift
//  Pods
//
//  Created by Andrew McKnight on 8/14/18.
//

@testable import FastMath
import XCTest

class DelaunayTriangulationTests: XCTestCase {
    
    /// Tests a situation where a point is not triangulated for a specific configuration.
    ///
    ///      A       B
    ///      *_______*
    ///      |      /
    ///      |     /
    ///      |    /
    ///      |   /
    ///      |  /  * <- point is not triangulated
    ///      | /   D
    ///      |/
    ///      *
    ///      C
    ///
    /// should be:
    ///
    ///      A       B
    ///      *_______*
    ///      |\      |
    ///      | \     /
    ///      |  \   |
    ///      |   \ /
    ///      |    \ * <- point should be thusly triangulated
    ///      |   /  D
    ///      |  /
    ///      */
    ///      C
    ///
    func testNontriangulated4thPoint() {
        let a = Vertex(point: CGPoint(x: 82, y: 193))
        let b = Vertex(point: CGPoint(x: 244, y: 202))
        let c = Vertex(point: CGPoint(x: 45, y: 352))
        let d = Vertex(point: CGPoint(x: 153, y: 302))
        let points = Set(arrayLiteral: a, b, c, d)
        let parent = LocationGraphNode(triangle: Triangle(x: a, y: b, z: c))
        let tri1 = LocationGraphNode(triangle: Triangle(x: a, y: c, z: d), parents: [parent])
        let tri2 = LocationGraphNode(triangle: Triangle(x: a, y: b, z: d), parents: [parent])
        parent.children = [tri1, tri2]
        let expected = parent.getTriangles()!
        
        let computed = DelaunayTriangulator()
            .triangulate(points: points)!
            .getTriangles()!
        
        XCTAssertEqual(expected, computed, "\nexpected\n\(expected)\nbut got\n\(computed)")
    }
    
}
