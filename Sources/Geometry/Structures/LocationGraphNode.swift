//
//  LocationGraphNode.swift
//  Delaunay
//
//  Created by Andrew McKnight on 11/8/17.
//  Copyright © 2017 old dominion university. All rights reserved.
//

import Foundation

public class LocationGraphNode: NSObject {

    var triangle: Triangle
    var parents: [LocationGraphNode]
    var children: [LocationGraphNode] = []
    var visited: Bool = false
    var neighborA, neighborB, neighborC: LocationGraphNode?

    init(triangle: Triangle, parents: [LocationGraphNode] = []) {
        self.triangle = triangle
        self.parents = parents
    }

    /**
     - returns: set of `Triangle`s in the Delaunay triangulation contained within the current node
     */
    public func getTriangles() -> Set<Triangle>? {
        if children.count == 0 {
            return nil
        }

        let allTriangles = collectLeafNodes(startingNode: self)
        resetVisitedStates(node: self)
        return Set<Triangle>(allTriangles.map({ $0.triangle }).filter({ !$0.hasGhostPoint() }))
    }

}

extension LocationGraphNode {

    override public var description: String {
        return toString(depth: 0)
    }

    private func toString(depth: Int) -> String {
        let padding = String(repeating: "\t", count: depth)
        var childrenString = children.map { $0.toString(depth: depth + 1) }.joined(separator: "\n")
        if childrenString.count > 0 {
            childrenString = "\n" + childrenString
        }
        return String(format: "%@tri: %@%@", padding, String(describing: triangle), childrenString)
    }

}

private extension LocationGraphNode {

    func collectLeafNodes(startingNode: LocationGraphNode) -> Set<LocationGraphNode> {
        if startingNode.children.count == 0 {
            return Set<LocationGraphNode>([ startingNode ])
        }

        var result = Set<LocationGraphNode>()
        startingNode.children.forEach { child in
            if !child.visited {
                child.visited = true
                result.formUnion(collectLeafNodes(startingNode: child))
            }
        }

        return result
    }
    
    func resetVisitedStates(node: LocationGraphNode) {
        node.children.forEach { child in
            child.visited = false
            resetVisitedStates(node: child)
        }
    }

}

extension LocationGraphNode {

    func findTriangle(incidentOnEdge edge: Edge, adjacentToTriangle triangle: LocationGraphNode) -> LocationGraphNode? {
        log(String(format: "Searching for leaf triangle adjacent to triangle %@ across edge %@.", String(describing: triangle.triangle), String(describing: edge)))
        var siblings = [LocationGraphNode]()
        triangle.parents.forEach { parent in
            siblings.append(contentsOf: parent.children)
        }

        if let originalTriangleIndex = siblings.index(of: triangle) {
            siblings.remove(at: originalTriangleIndex)
        }

        for sibling in siblings {
            if edge == sibling.triangle.a || edge == sibling.triangle.b || edge == sibling.triangle.c {
                log(String(format: "Edge %@ is part of sibling triangle: %@; recurse into its children", String(describing: edge), String(describing: sibling.triangle)))
                return findSubtriangle(incidentOnEdge: edge, adjacentToTriangle:sibling)
            }
        }

        /*
         If we're here, then none of the sibling nodes in the tree reference a
         triangle that is incident on the provided edge. This is because the
         input edge is a new one created by an edge flip, so we need to ascend
         to the grandparent of the input triangle to find the newly created ones
         incident on it.
         */
        let grandParents = triangle.parents.reduce(into: [LocationGraphNode](), { (grandparents, parent) in
            grandparents.append(contentsOf: parent.parents)
        })
        let parentSiblings = grandParents.reduce(into: [LocationGraphNode](), { (siblings, grandparent) in
            siblings.append(contentsOf: grandparent.children)
        }).filter { (parentSibling) -> Bool in
            return !triangle.parents.contains(where: { (node) -> Bool in
                parentSibling == node
            })
        }

        guard let match = parentSiblings.filter({ (parentSibling) -> Bool in
            return edge == parentSibling.triangle.a || edge == parentSibling.triangle.b || edge == parentSibling.triangle.c
        }).first else {
            log(String(format: "No parent siblings adjacent to triangle %@ on edge %@.", String(describing: triangle.triangle), String(describing: edge)))
            return nil
        }

        log(String(format: "Edge %@ is part of parent's sibling triangle: %@.", String(describing: edge), String(describing: match.triangle)))

        return match
    }

    // find the deepest child sharing the edge
    private func findSubtriangle(incidentOnEdge edge: Edge, adjacentToTriangle triangle: LocationGraphNode, callDepth: Int = 0) -> LocationGraphNode? {
        // leaf node, recursion termination
        if triangle.children.count == 0 {
            log(String(format: "%@ Triangle %@ is a leaf node, so it is the adjacent triangle across edge %@.", String(repeating: "*", count: callDepth + 1), String(describing: triangle), String(describing: edge)))
            return triangle
        }

        for child in triangle.children {
            if edge == triangle.triangle.a || edge == triangle.triangle.b || edge == triangle.triangle.c {
                log(String(format: "%@ Child triangle %@ shares edge %@; recursing children.", String(repeating: "*", count: callDepth + 1), String(describing: child), String(describing: edge)))
                return findSubtriangle(incidentOnEdge:edge, adjacentToTriangle:child, callDepth: callDepth + 1)
            }
        }

        log(String(format: "%@ No triangle shares edge %@.", String(repeating: "*", count: callDepth + 1), String(describing: edge)))
        return nil
    }

}

extension LocationGraphNode {

    func findNode(containingPoint point: Vertex) -> LocationGraphNode? {
        return findNode(containingPoint: point, currentTriangle: self)
    }

    private func findNode(containingPoint point: Vertex, currentTriangle: LocationGraphNode, callDepth: Int = 0) -> LocationGraphNode? {
        log(String(format: "%@ Testing if point (%@) lies inside triangle (%@).", String(repeating: "*", count: callDepth + 1), String(describing: point), String(describing: currentTriangle.triangle)))

        // leaf node, recursion termination
        if currentTriangle.children.count == 0 {
            log(String(format: "%@ Triangle has 0 children, returning itself.", String(repeating: "*", count: callDepth + 1)))
            return currentTriangle
        }

        log(String(format: "%@ Triangle has children, iterating through them.", String(repeating: "*", count: callDepth + 1)))
        
        for child in currentTriangle.children {
            log(String(format: "%@ Testing if point (%@) lies inside child triangle (%@).", String(repeating: "*", count: callDepth + 1), String(describing: point), String(describing: child.triangle)))
            if child.triangle.contains(vertex: point) {
                log(String(format: "%@ Point (%@) lies inside triangle (%@), recursing into its children.", String(repeating: "*", count: callDepth + 1), String(describing: point), String(describing: child.triangle)))
                return findNode(containingPoint:point, currentTriangle:child, callDepth: callDepth + 1)
            } else {
                log(String(format: "%@ Point (%@) lies outside triangle (%@).", String(repeating: "*", count: callDepth + 1), String(describing: point), String(describing: child.triangle)))
            }
        }

        return nil
    }

}
