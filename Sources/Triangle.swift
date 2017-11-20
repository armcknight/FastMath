//
//  Triangle.swift
//  Delaunay
//
//  Created by Andrew McKnight on 11/8/17.
//  Copyright © 2017 old dominion university. All rights reserved.
//

import Foundation

public struct Triangle {

    //a, b, c are directed edges in counterclockwise order
    public var a, b, c: Edge!

    init(x: Vertex, y: Vertex, z: Vertex) {
        let points: Set<Vertex> = [x, y, z]
        let intersection = ghosts.intersection(Set<Vertex>(points)).count

        log(String(format: "Creating Triangle with points: %@", String(describing: points)))
        
        if intersection == 0 {
            let edge = Edge(x: y, y: z)
            if x.liesToLeft(ofEdge:edge) {
                self.a = edge
                self.b = Edge(x: z, y: x)
                self.c = Edge(x: x, y: y)
            } else {
                self.a = Edge(x: y, y: x)
                self.b = Edge(x: x, y: z)
                self.c = Edge(x: z, y: y)
            }
        }
        else if intersection == 1 {
            if x == ghost1 {
                let sorted = Set([y, z]).sortedLexicographically()
                log(String(format: "x is ghost1, other points lex sorted: %@", String(describing: sorted)))
                self.a = Edge(x: x, y: sorted.last!)
                self.b = Edge(x: sorted.last!, y: sorted.first!)
                self.c = Edge(x: sorted.first!, y: x)
            }
            else if x == ghost2 {
                let sorted = Set([y, z]).sortedLexicographically()
                log(String(format: "x is ghost2, other points lex sorted: %@", String(describing: sorted)))
                self.a = Edge(x: x, y: sorted.first!)
                self.b = Edge(x: sorted.first!, y: sorted.last!)
                self.c = Edge(x: sorted.last!, y: x)
            }
            else if y == ghost1 {
                let sorted = Set([x, z]).sortedLexicographically()
                log(String(format: "y is ghost1, other points lex sorted: %@", String(describing: sorted)))
                self.a = Edge(x: y, y: sorted.last!)
                self.b = Edge(x: sorted.last!, y: sorted.first!)
                self.c = Edge(x: sorted.first!, y: y)
            }
            else if y == ghost2 {
                let sorted = Set([x, z]).sortedLexicographically()
                log(String(format: "y is ghost2, other points lex sorted: %@", String(describing: sorted)))
                self.a = Edge(x: y, y: sorted.first!)
                self.b = Edge(x: sorted.first!, y: sorted.last!)
                self.c = Edge(x: sorted.last!, y: y)
            }
            else if z == ghost1 {
                let sorted = Set([x, y]).sortedLexicographically()
                log(String(format: "z is ghost1, other points lex sorted: %@", String(describing: sorted)))
                self.a = Edge(x: z, y: sorted.last!)
                self.b = Edge(x: sorted.last!, y: sorted.first!)
                self.c = Edge(x: sorted.first!, y: z)
            }
            else if z == ghost2 {
                let sorted = Set([x, y]).sortedLexicographically()
                log(String(format: "z is ghost2, other points lex sorted: %@", String(describing: sorted)))
                self.a = Edge(x: z, y: sorted.first!)
                self.b = Edge(x: sorted.first!, y: sorted.last!)
                self.c = Edge(x: sorted.last!, y: z)
            }
        }
        else if intersection == 2 {
            if x == ghost1 && y == ghost2 {
                log("x == ghost1 && y == ghost2")
                self.a = Edge(x: y, y: x)
                self.b = Edge(x: x, y: z)
                self.c = Edge(x: z, y: y)
            }
            else if x == ghost2 && y == ghost1 {
                log("x == ghost2 && y == ghost1")
                self.a = Edge(x: x, y: y)
                self.b = Edge(x: y, y: z)
                self.c = Edge(x: z, y: x)
            }
            else if x == ghost1 && z == ghost2 {
                log("x == ghost1 && z == ghost2")
                self.a = Edge(x: z, y: x)
                self.b = Edge(x: x, y: y)
                self.c = Edge(x: y, y: z)
            }
            else if x == ghost2 && z == ghost1 {
                log("x == ghost2 && z == ghost1")
                self.a = Edge(x: x, y: z)
                self.b = Edge(x: z, y: y)
                self.c = Edge(x: y, y: x)
            }
            else if y == ghost1 && z == ghost2 {
                log("y == ghost1 && z == ghost2")
                self.a = Edge(x: z, y: y)
                self.b = Edge(x: y, y: x)
                self.c = Edge(x: x, y: z)
            }
            else if y == ghost2 && z == ghost1 {
                log("y == ghost2 && z == ghost1")
                self.a = Edge(x: y, y: z)
                self.b = Edge(x: z, y: x)
                self.c = Edge(x: x, y: y)
            }
        }

        log(String(format: "Created %@.", String(describing: self)))
    }

    init(edge: Edge, point: Vertex) {
        self.init(x: point, y: edge.a, z: edge.b)
    }

}

extension Triangle {

    func centroid() -> Vertex {
        let x = (a.a.x + a.b.x + b.b.x) / 3.0
        let y = (a.a.y + a.b.y + b.b.y) / 3.0
        return Vertex(x: x, y: y)
    }

    func hasGhostPoint() -> Bool {
        return points().intersection(ghosts).count > 0
    }

    func edges() -> Set<Edge> {
        return Set<Edge>([a, b, c])
    }

    func points() -> Set<Vertex> {
        return Set<Vertex>([a.a, a.b, b.b])
    }

    /**
     - returns: `true` if point lies strictly within, `false` if point lies on an edge or outside
     */
    func contains(vertex: Vertex) -> Bool {
        let leftOfA = vertex.liesToLeft(ofEdge:a)
        let leftOfB = vertex.liesToLeft(ofEdge:b)
        let leftOfC = vertex.liesToLeft(ofEdge:c)
        return leftOfA && leftOfB && leftOfC
    }

    /**
     - returns: `true` if point lies strictly inside circumcircle, `false` if it falls on the circle or outside
     */
    func circumcircleContains(vertex: Vertex) -> Bool {
        return incircleOrientation(vertex: vertex, triangle: self) == .inside
    }

}

extension Triangle: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

}

extension Triangle: CustomStringConvertible {

    public var description: String {
        let sortedPoints: [Vertex] = points().sortedLexicographically()
        return String(format: "[%@]", (sortedPoints as NSArray).componentsJoined(by: " "))
    }

}

public func ==(lhs: Triangle, rhs: Triangle) -> Bool {
    return Set<Edge>([lhs.a, lhs.b, lhs.c]) == Set<Edge>([rhs.a, rhs.b, rhs.c])
}
