//
//  Edge.swift
//  Delaunay
//
//  Created by Andrew McKnight on 11/8/17.
//  Copyright © 2017 old dominion university. All rights reserved.
//

import Foundation

public struct Edge {

    public var a, b: Vertex

    init(x: Vertex, y: Vertex) {
        self.a = x
        self.b = y
    }

    func containsGhostPoint() -> Bool {
        return Set<Vertex>([a, b]).intersection(ghosts).count > 0
    }

    func endpoints() -> Set<Vertex> {
        return Set<Vertex>([a, b])
    }
    
}

extension Edge: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

}

extension Edge: CustomStringConvertible {

    public var description: String {
        return String(format: "[%@ %@]", String(describing: a), String(describing: b))
    }

}

public func ==(lhs: Edge, rhs: Edge) -> Bool {
    return lhs.a == rhs.a && lhs.b == rhs.b || lhs.a == rhs.b && lhs.b == rhs.a
}
