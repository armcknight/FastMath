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
        let expected = parent.getTriangles()
        
        guard let computed = DelaunayTriangulator(points: points).triangulation?.getTriangles() else {
            XCTFail("No triangles returned from triangulation.")
            return
        }
        
        XCTAssert(expected.symmetricDifference(computed).count == 0, "\nexpected\n\(expected)\nbut got\n\(computed)")
    }
    
    func testTriangulator() {
        let triangle0 = Triangle(x:Vertex(x:108.5,y:153.0,name:"x"),y:Vertex(x:166.0,y:60.0,name:"y"),z:Vertex(x:259.0,y:142.0,name:"z"),name:"id")
        let triangle1 = Triangle(x:Vertex(x:53.5,y:317.5,name:"x"),y:Vertex(x:47.5,y:56.0,name:"y"),z:Vertex(x:69.5,y:237.0,name:"z"),name:"id")
        let triangle2 = Triangle(x:Vertex(x:53.5,y:317.5,name:"x"),y:Vertex(x:17.0,y:497.5,name:"y"),z:Vertex(x:47.5,y:56.0,name:"z"),name:"id")
        let triangle3 = Triangle(x:Vertex(x:239.5,y:350.5,name:"x"),y:Vertex(x:162.0,y:282.0,name:"y"),z:Vertex(x:210.5,y:240.5,name:"z"),name:"id")
        let triangle4 = Triangle(x:Vertex(x:69.5,y:237.0,name:"x"),y:Vertex(x:47.5,y:56.0,name:"y"),z:Vertex(x:108.5,y:153.0,name:"z"),name:"id")
        let triangle5 = Triangle(x:Vertex(x:162.0,y:282.0,name:"x"),y:Vertex(x:108.5,y:153.0,name:"y"),z:Vertex(x:210.5,y:240.5,name:"z"),name:"id")
        let triangle6 = Triangle(x:Vertex(x:122.5,y:528.5,name:"x"),y:Vertex(x:197.0,y:460.5,name:"y"),z:Vertex(x:265.0,y:506.5,name:"z"),name:"id")
        let triangle7 = Triangle(x:Vertex(x:239.5,y:350.5,name:"x"),y:Vertex(x:259.0,y:142.0,name:"y"),z:Vertex(x:289.0,y:51.5,name:"z"),name:"id")
        let triangle8 = Triangle(x:Vertex(x:239.5,y:350.5,name:"x"),y:Vertex(x:289.0,y:51.5,name:"y"),z:Vertex(x:265.0,y:506.5,name:"z"),name:"id")
        let triangle9 = Triangle(x:Vertex(x:166.0,y:60.0,name:"x"),y:Vertex(x:47.5,y:56.0,name:"y"),z:Vertex(x:289.0,y:51.5,name:"z"),name:"id")
        let triangle10 = Triangle(x:Vertex(x:210.5,y:240.5,name:"x"),y:Vertex(x:108.5,y:153.0,name:"y"),z:Vertex(x:259.0,y:142.0,name:"z"),name:"id")
        let triangle11 = Triangle(x:Vertex(x:162.0,y:282.0,name:"x"),y:Vertex(x:69.5,y:237.0,name:"y"),z:Vertex(x:108.5,y:153.0,name:"z"),name:"id")
        let triangle12 = Triangle(x:Vertex(x:145.0,y:440.5,name:"x"),y:Vertex(x:80.0,y:442.0,name:"y"),z:Vertex(x:53.5,y:317.5,name:"z"),name:"id")
        let triangle13 = Triangle(x:Vertex(x:162.0,y:282.0,name:"x"),y:Vertex(x:53.5,y:317.5,name:"y"),z:Vertex(x:69.5,y:237.0,name:"z"),name:"id")
        let triangle14 = Triangle(x:Vertex(x:108.5,y:153.0,name:"x"),y:Vertex(x:47.5,y:56.0,name:"y"),z:Vertex(x:166.0,y:60.0,name:"z"),name:"id")
        let triangle15 = Triangle(x:Vertex(x:145.0,y:440.5,name:"x"),y:Vertex(x:53.5,y:317.5,name:"y"),z:Vertex(x:162.0,y:282.0,name:"z"),name:"id")
        let triangle16 = Triangle(x:Vertex(x:239.5,y:350.5,name:"x"),y:Vertex(x:210.5,y:240.5,name:"y"),z:Vertex(x:259.0,y:142.0,name:"z"),name:"id")
        let triangle17 = Triangle(x:Vertex(x:122.5,y:528.5,name:"x"),y:Vertex(x:80.0,y:442.0,name:"y"),z:Vertex(x:145.0,y:440.5,name:"z"),name:"id")
        let triangle18 = Triangle(x:Vertex(x:17.0,y:497.5,name:"x"),y:Vertex(x:53.5,y:317.5,name:"y"),z:Vertex(x:80.0,y:442.0,name:"z"),name:"id")
        let triangle19 = Triangle(x:Vertex(x:122.5,y:528.5,name:"x"),y:Vertex(x:17.0,y:497.5,name:"y"),z:Vertex(x:80.0,y:442.0,name:"z"),name:"id")
        let triangle20 = Triangle(x:Vertex(x:265.0,y:506.5,name:"x"),y:Vertex(x:197.0,y:460.5,name:"y"),z:Vertex(x:239.5,y:350.5,name:"z"),name:"id")
        let triangle21 = Triangle(x:Vertex(x:259.0,y:142.0,name:"x"),y:Vertex(x:166.0,y:60.0,name:"y"),z:Vertex(x:289.0,y:51.5,name:"z"),name:"id")
        let triangle22 = Triangle(x:Vertex(x:197.0,y:460.5,name:"x"),y:Vertex(x:145.0,y:440.5,name:"y"),z:Vertex(x:239.5,y:350.5,name:"z"),name:"id")
        let triangle23 = Triangle(x:Vertex(x:145.0,y:440.5,name:"x"),y:Vertex(x:162.0,y:282.0,name:"y"),z:Vertex(x:239.5,y:350.5,name:"z"),name:"id")
        let triangle24 = Triangle(x:Vertex(x:122.5,y:528.5,name:"x"),y:Vertex(x:145.0,y:440.5,name:"y"),z:Vertex(x:197.0,y:460.5,name:"z"),name:"id")
        
        let expected = Set<Triangle>([triangle0, triangle1, triangle2, triangle3, triangle4, triangle5, triangle6, triangle7, triangle8, triangle9, triangle10, triangle11, triangle12, triangle13, triangle14, triangle15, triangle16, triangle17, triangle18, triangle19, triangle20, triangle21, triangle22, triangle23, triangle24])
        
        let points = expected.points()
        
        let triangulator = DelaunayTriangulator(points: points)
        guard let computed = triangulator.triangulation?.getTriangles() else {
            XCTFail("No triangles returned from triangulation.")
            return
        }
        print(computed.symmetricDifference(expected).briefDescription())
        XCTAssert(computed.symmetricDifference(expected).count == 0, "expected\n\(expected.briefDescription())\nbut got\n\(computed.briefDescription())")
    }
    
    func testTriangulation() {
        for (points, expected) in [/*caseA, */caseB] {
        let triangulator = DelaunayTriangulator(points: points)
        guard let triangles = triangulator.triangulation?.getTriangles() else {
            XCTFail("No triangles returned from triangulation.")
            return
            }
            
            print(triangles.generatingCode())
            
            XCTAssertEqual(expected, triangles)
        }
    }
}

extension DelaunayTriangulationTests {
    typealias TestCase = (input: Set<Vertex>, expected: Set<Triangle>)
    var caseA: TestCase {
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
    
    var caseB: TestCase {
        let input = Set([
            Vertex(x: 287.5, y: 815.0, name: "a"),
            Vertex(x: 475.0, y: 394.0, name: "b"),
            Vertex(x: 743.5, y: 776.5, name: "c"),
            Vertex(x: 493.0, y: 678.5, name: "d"),
            ])
        
        let expected = Set([
            Triangle(x:Vertex(x:287.5,y:815.0,name:"x"),y:Vertex(x:493.0,y:678.5,name:"y"),z:Vertex(x:743.5,y:776.5,name:"z"),name:"1"),
            Triangle(x:Vertex(x:287.5,y:815.0,name:"x"),y:Vertex(x:475.0,y:394.0,name:"y"),z:Vertex(x:493.0,y:678.5,name:"z"),name:"2"),
            Triangle(x:Vertex(x:743.5,y:776.5,name:"x"),y:Vertex(x:493.0,y:678.5,name:"y"),z:Vertex(x:475.0,y:394.0,name:"z"),name:"3"),
            ])
        
        return (input, expected)
    }
}
