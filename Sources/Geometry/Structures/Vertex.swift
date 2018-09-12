//
//  Vertex.swift
//  Delaunay
//
//  Created by Andrew McKnight on 11/8/17.
//  Copyright © 2017 old dominion university. All rights reserved.
//

import CoreGraphics
import Foundation

let ghost1 = Vertex(x: -1, y: -1, name: "Ghost 1")
let ghost2 = Vertex(x: -2, y: -2, name: "Ghost 2")
let ghosts: Set<Vertex> = Set<Vertex>([ghost1, ghost2])

public class Vertex {

    public var x, y: Double
    public let name: String

    public init(point: CGPoint, name: String) {
        self.x = Double(point.x)
        self.y = Double(point.y)
        self.name = name
    }

    init(x: Double, y: Double, name: String) {
        self.x = x
        self.y = y
        self.name = name
    }

}

extension Vertex: Hashable {

    public var hashValue: Int {
        return String(format: "Vertex: [%f %f]", x, y).hashValue
    }

}

public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

extension Vertex: CustomStringConvertible {

    public var description: String {
        return String(format: "Vertex “%@”: [%.1f %.1f]", name, x, y)
    }

}
