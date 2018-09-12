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
        FastMath.logBlock = { message in
            print(message)
        }
        let a = Vertex(point: CGPoint(x: 82, y: 193), name: "4")
        let b = Vertex(point: CGPoint(x: 244, y: 202), name: "3")
        let c = Vertex(point: CGPoint(x: 45, y: 352), name: "1")
        let d = Vertex(point: CGPoint(x: 153, y: 302), name: "2")
        let points = Set(arrayLiteral: a, b, c, d)
        let parent = LocationGraphNode(triangle: Triangle(x: a, y: b, z: c, name: "root"))
        let tri1 = LocationGraphNode(triangle: Triangle(x: a, y: c, z: d, name: "Expected child triangle 1"), parents: [parent])
        let tri2 = LocationGraphNode(triangle: Triangle(x: a, y: b, z: d, name: "Expected child triangle 2"), parents: [parent])
        parent.children = [tri1, tri2]
        let expected = parent.getTriangles()!
        
        let computed = DelaunayTriangulator()
            .triangulate(points: points)!
            .getTriangles()!
        
        
        XCTAssert(expected.elementsEqual(computed), "\nexpected\n\(expected)\nbut got\n\(computed)")
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
}

extension DelaunayTriangulationTests {
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
}
