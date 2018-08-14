//
//  Vertex.swift
//  Delaunay
//
//  Created by Andrew McKnight on 11/8/17.
//  Copyright © 2017 old dominion university. All rights reserved.
//

import CoreGraphics
import Foundation

let ghost1 = Vertex(x: -1, y: -1)
let ghost2 = Vertex(x: -2, y: -2)
let ghosts: Set<Vertex> = Set<Vertex>([ghost1, ghost2])

public class Vertex {

    public var x, y: Double!

    public init(point: CGPoint) {
        self.x = Double(point.x)
        self.y = Double(point.y)
    }

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

}

extension Vertex: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

}

public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

extension Vertex: CustomStringConvertible {

    public var description: String {
        return String(format: "[%.1f %.1f]", x, y)
    }

}

extension Vertex {

    /**
     `ghost2` > all points > `ghost1`
     */
    func lexicographicallyLargerThan(otherPoint: Vertex) -> Bool {
        if self == ghost2 { return true }
        if otherPoint == ghost1 { return true }

        return self.y != otherPoint.y ? self.y > otherPoint.y : self.x > otherPoint.x
    }

    func isIncident(onEdge edge: Edge) -> Bool {
        // impossible for vertices to fall on an edge containing a ghost point
        if edge.containsGhostPoint() {
            return false
        }

        return planarOrientation(a: edge.a, b: edge.b, c: self) == .colinear
    }

    /**
     - returns: `true` if point lies strictly to the left, `false` if point falls on edge or to the right
     */
    func liesToLeft(ofEdge edge: Edge) -> Bool {
        if self == ghost1 {
            return edge.a.lexicographicallyLargerThan(otherPoint: edge.b)
        }

        if self == ghost2 {
            return edge.b.lexicographicallyLargerThan(otherPoint: edge.a)
        }

        if edge.a == ghost1 && edge.b == ghost2 {
            log(String(format: "Edge (%@) is oriented so that all points lie to the right.", String(describing: edge)))
            return false
        }

        if (edge.a == ghost2 && edge.b == ghost1) {
            log(String(format: "Edge (%@) is oriented so that all points lie to the left.", String(describing: edge)))
            return true
        }

        if (edge.b == ghost1) {
            let liesLeft = self.lexicographicallyLargerThan(otherPoint: edge.a)
            log(String(format: "Edge's (%@) destination point is ghost1. Because the test point (%@) is lexicographically %@ than its source point, the test point %@ to the left of the edge.", String(describing: edge), String(describing: self), liesLeft ? "larger" : "smaller", liesLeft ? "lies" : "does not lie"))
            return liesLeft
        } else if (edge.a == ghost1) {
            let liesLeft = edge.b.lexicographicallyLargerThan(otherPoint: self)
            log(String(format: "Edge's (%@) source point is ghost1. Because its destination point is lexicographically %@ than the test point (%@), the test point %@ to the left of the edge.", String(describing: edge), liesLeft ? "larger" : "smaller", String(describing: self), liesLeft ? "lies" : "does not lie"))
            return liesLeft
        }

        if (edge.a == ghost2) {
            let liesLeft = self.lexicographicallyLargerThan(otherPoint: edge.b)
            log(String(format: "Edge's (%@) source point is ghost2. Because the test point (%@) is lexicographically %@ than its destination point, the test point %@ to the left of the edge.", String(describing: edge), String(describing: self), liesLeft ? "larger" : "smaller", liesLeft ? "lies" : "does not lie"))
            return liesLeft
        } else if(edge.b == ghost2) {
            let liesLeft = edge.a.lexicographicallyLargerThan(otherPoint: self)
            log(String(format: "Edge's (%@) destination point is ghost2. Because the source point is lexicographically %@ than the test point (%@), the test point %@ to the left of the edge.", String(describing: edge), liesLeft ? "larger" : "smaller", String(describing: self), liesLeft ? "lies" : "does not lie"))
            return liesLeft
        }

        let liesLeft = planarOrientation(a: edge.a, b: edge.b, c: self) == .counterclockwise

        log(String(format: "Point (%@) %@ to the left of the edge (%@).", String(describing: self), liesLeft ? "lies" : "does not lie", String(describing: edge)))
        return liesLeft
    }

}
