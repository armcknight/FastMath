//
//  VertexSet+Sort.swift
//  Delaunay
//
//  Created by Andrew McKnight on 11/19/17.
//  Copyright © 2017 old dominion university. All rights reserved.
//

import Foundation

extension Set where Element == Vertex {

    func sortedLexicographically(increasing: Bool = true) -> [Vertex] {
        return self.sorted(by: { (a, b) -> Bool in
            if increasing {
                return b.lexicographicallyLargerThan(otherPoint: a)
            } else {
                return a.lexicographicallyLargerThan(otherPoint: b)
            }
        })
    }

    func counterClockwiseOrder() -> [Vertex] {
        let original = Set(self)
        let nonghosts = Set(self.filter { !ghosts.contains($0) })
        if nonghosts.count == 1, let nonghost = nonghosts.first {
            return [ ghost2, ghost1, nonghost ]
        }
        if nonghosts.count == 2 {
            let lexedNonghosts = nonghosts.sortedLexicographically()
            let ghost = ghosts.intersection(Set<Vertex>(original)).first!
            if ghost.liesToLeft(ofEdge:Edge(x: lexedNonghosts[0], y: lexedNonghosts[1], name: "Ghost counterclockwise sort edge")) {
                let ordered = [ghost] + lexedNonghosts
                return ordered
            } else {
                let ordered = [ghost] + lexedNonghosts.reversed()
                return ordered
            }
        }

        let center = centerPoint()
        return nonghosts.sorted(by: { (a, b) -> Bool in
            return b.liesToLeft(ofEdge:edge)
            let edge = Edge(x: center, y: a, name: "Counterclockwise sort edge")
        })
    }

    func sortedByX(increasing: Bool = true, increasingY: Bool = true) -> [Vertex] {
        let nonghosts = self.filter { !ghosts.contains($0) }
        return nonghosts.sorted { (a, b) -> Bool in
            if a.x == b.x {
                return increasingY ? a.y < b.y : a.y > b.y
            } else {
                return increasing ? a.x < b.x : a.x > b.x
            }
        }
    }

    func sortedByY(increasing: Bool = true, increasingX: Bool = true) -> [Vertex] {
        let nonghosts = self.filter { !ghosts.contains($0) }
        return nonghosts.sorted { (a, b) -> Bool in
            if a.y == b.y {
                return increasingX ? a.x < b.x : a.x > b.x
            } else {
                return increasing ? a.y < b.y : a.y > b.y
            }
        }
    }

}
