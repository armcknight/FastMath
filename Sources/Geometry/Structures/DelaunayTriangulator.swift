//
//  DelaunayTriangulator.swift
//  
//
//  Created by Andrew McKnight on 11/9/17.
//

import Foundation

public struct DelaunayTriangulator {
    
    public init() {}

    public func triangulate(points: Set<Vertex>) -> LocationGraphNode? {
        if points.count == 0 {
            log("No points to triangulate.")
            return nil
        }

        let sortedPoints = points.sortedLexicographically(increasing: false)
        log(String(format: "Triangulating points: %@.", String(describing: sortedPoints.dropFirst())))

        guard let highestPoint = sortedPoints.first else {
            log(String(format: "There are points (%@), but could not find the lexicographically largest point.", String(describing: points)))
            return nil
        }

        let superTriangle = Triangle(x: highestPoint, y: ghost1, z: ghost2)
        let triangulation = LocationGraphNode(triangle: superTriangle, parents: [])
        for point in sortedPoints.dropFirst() {
            insertPoint(triangulation: triangulation, point: point)
        }

        return triangulation
    }

}

private extension DelaunayTriangulator {

    func insertPoint(triangulation: LocationGraphNode, point: Vertex) {
        log(String(format: "\n\n\nInserting point (%@).", String(describing: point)))

        guard let containingNode = triangulation.findNode(containingPoint: point) else {
            log(String(format: "Point (%@) not contained in triangulation (%@).", String(describing: point), String(describing: triangulation)))
            return
        }

        // handle case where the point lies on one of the edges
        let onEdges = containingNode.triangle.edges().filter { point.isIncident(onEdge: $0) }
        if let edge = onEdges.first, let neighbor = triangulation.findTriangle(incidentOnEdge: edge, adjacentToTriangle: containingNode) {
            log(String(format: "Point (%@) lies on edge (%@).", String(describing: point), String(describing: edge)))
            handleColinearPoint(triangulation: triangulation, containingNode: containingNode, neighbor: neighbor, point: point, edge: edge)
            log(String(format: "Triangulation after inserting point (%@): %@", String(describing: point), String(describing: triangulation)))
            return
        }

        // the point lies strictly inside the triangle
        log(String(format: "Point (%@) lies strictly inside triangle (%@).", String(describing: point), String(describing: containingNode.triangle)))
        handleInteriorPoint(triangulation: triangulation, containingNode: containingNode, point: point)
        log(String(format: "Triangulation after inserting point (%@): %@", String(describing: point), String(describing: triangulation)))
    }

    func handleColinearPoint(triangulation: LocationGraphNode, containingNode: LocationGraphNode, neighbor: LocationGraphNode, point: Vertex, edge: Edge) {
        let otherEdges = containingNode.triangle.edges().filter { $0 != edge }
        otherEdges.forEach { otherTriangleEdge in
            containingNode.children.append(LocationGraphNode(triangle: Triangle(edge: otherTriangleEdge, point: point), parents: [ containingNode ]))
        }
        let otherNeighborEdges = Set(neighbor.triangle.edges().filter { $0 != edge })
        otherNeighborEdges.forEach { otherNeighborEdge in
            neighbor.children.append(LocationGraphNode(triangle: Triangle(edge: otherNeighborEdge, point: point), parents: [ containingNode ]))
        }
        otherNeighborEdges.union(otherEdges).forEach {
            legalize(edge: $0, vertex: point, node: neighbor, triangulation: triangulation)
        }
    }

    func handleInteriorPoint(triangulation: LocationGraphNode, containingNode: LocationGraphNode, point: Vertex) {
        let edgeA = containingNode.triangle.a!
        let edgeB = containingNode.triangle.b!
        let edgeC = containingNode.triangle.c!

        let triangleA = Triangle(edge: edgeA, point: point)
        let triangleB = Triangle(edge: edgeB, point: point)
        let triangleC = Triangle(edge: edgeC, point: point)

        let nodeA = LocationGraphNode(triangle: triangleA, parents: [ containingNode ])
        let nodeB = LocationGraphNode(triangle: triangleB, parents: [ containingNode ])
        let nodeC = LocationGraphNode(triangle: triangleC, parents: [ containingNode ])

        assignNewtriangleNeighbors(newNode: nodeA, neighbor1: nodeB, neighbor2: nodeC, edge: edgeA, parentNeighbor: containingNode.neighborA)
        assignNewtriangleNeighbors(newNode: nodeB, neighbor1: nodeC, neighbor2: nodeA, edge: edgeB, parentNeighbor: containingNode.neighborB)
        assignNewtriangleNeighbors(newNode: nodeC, neighbor1: nodeA, neighbor2: nodeB, edge: edgeC, parentNeighbor: containingNode.neighborC)

        assignNewTriangleAsNeighbor(parentNeighbor: containingNode.neighborA, edge: edgeA, newNode: nodeA)
        assignNewTriangleAsNeighbor(parentNeighbor: containingNode.neighborB, edge: edgeB, newNode: nodeB)
        assignNewTriangleAsNeighbor(parentNeighbor: containingNode.neighborC, edge: edgeC, newNode: nodeC)

        [nodeA, nodeB, nodeC].forEach {
            log(String(format: "New triangle's (%@) neighbors: \n\ta: %@\n\tb: %@\n\tc: %@", String(describing: $0.triangle), String(describing: $0.neighborA?.triangle), String(describing: $0.neighborB?.triangle), String(describing: $0.neighborC?.triangle)))
        }

        containingNode.children.append(contentsOf: [ nodeA, nodeB, nodeC ])

        legalize(edge: edgeA, vertex: point, node: nodeA, triangulation: triangulation)
        legalize(edge: edgeB, vertex: point, node: nodeB, triangulation: triangulation)
        legalize(edge: edgeC, vertex: point, node: nodeC, triangulation: triangulation)
    }

    func assignNewtriangleNeighbors(newNode: LocationGraphNode, neighbor1: LocationGraphNode, neighbor2: LocationGraphNode, edge: Edge, parentNeighbor: LocationGraphNode?) {
        if newNode.triangle.a == edge {
            newNode.neighborA = parentNeighbor
            newNode.neighborB = neighbor1
            newNode.neighborC = neighbor2
        } else if newNode.triangle.b == edge {
            newNode.neighborA = neighbor2
            newNode.neighborB = parentNeighbor
            newNode.neighborC = neighbor1
        } else if newNode.triangle.c == edge {
            newNode.neighborA = neighbor1
            newNode.neighborB = neighbor2
            newNode.neighborC = parentNeighbor
        }
    }

    func assignNewTriangleAsNeighbor(parentNeighbor: LocationGraphNode?, edge: Edge, newNode: LocationGraphNode) {
        guard let parentNeighbor = parentNeighbor else { return }

        if parentNeighbor.triangle.a == edge {
            parentNeighbor.neighborA = newNode
        } else if parentNeighbor.triangle.b == edge {
            parentNeighbor.neighborB = newNode
        } else if parentNeighbor.triangle.c == edge {
            parentNeighbor.neighborC = newNode
        }
    }

    func legalize(edge: Edge, vertex: Vertex, node: LocationGraphNode, triangulation: LocationGraphNode, callDepth: Int = 0) {
        log(String(format: "%@ Legalizing edge (%@) with vertex (%@).", String(repeating: "*", count: callDepth + 1), String(describing: edge), String(describing: vertex)))

        // get the point on the neighboring triangle that isn't an endpoint of the edge
        guard let neighbor = node.triangle.a == edge ? node.neighborA : node.triangle.b == edge ? node.neighborB : node.neighborC else {
            log(String(format: "Current triangle (%@) has no neighbor across edge %@, so it is legal.", String(describing: node.triangle), String(describing: edge)))
            return
        }

        let x = neighbor.triangle.a.a
        let y = neighbor.triangle.a.b
        let z = neighbor.triangle.b.b
        let otherPoint = edge.a == x || edge.b == x ? (edge.a == y || edge.b == y ? z : y) : x

        if isEdgeLegal(triangulation: triangulation, node: node, edge: edge, vertex: vertex, otherPoint: otherPoint) {
            return
        }

        let legalEdge = Edge(x: otherPoint, y: vertex)
        log(String(format: "Edge %@ is illegal because the neighboring triangle's opposing point %@ lies inside the circumcircle of the new triangle %@. New legal edge: %@.", String(describing: edge), String(describing: otherPoint), String(describing: node.triangle), String(describing: legalEdge)))

        // construct the new triangles replacing the old ones that met on the flipped edge
        let A = Triangle(edge: legalEdge, point: edge.a)
        let B = Triangle(edge: legalEdge, point: edge.b)
        let nodeA = LocationGraphNode(triangle: A, parents: [ node, neighbor ])
        let nodeB = LocationGraphNode(triangle: B, parents: [ node, neighbor ])

        assignNeighborsAfterEdgeFlip(node: node, neighbor: neighbor, nodeA: nodeA, nodeB: nodeB, legalEdge: legalEdge, edge: edge)

        // insert new nodes in the data structure
        let newNodes = [nodeA, nodeB]
        node.children.append(contentsOf: newNodes)
        neighbor.children.append(contentsOf: newNodes)

        // RECURSION - propogate edge legalization
        legalize(edge: Edge(x: edge.a, y: otherPoint), vertex: vertex, node: nodeA, triangulation: triangulation, callDepth: callDepth + 1)
        legalize(edge: Edge(x: edge.b, y: otherPoint), vertex: vertex, node: nodeB, triangulation: triangulation, callDepth: callDepth + 1)

        log(String(format: "%@ Finished legalizing edge (%@) with vertex (%@).", String(repeating: "*", count: callDepth + 1), String(describing: edge), String(describing: vertex)))
    }

    func isEdgeLegal(triangulation: LocationGraphNode, node: LocationGraphNode, edge: Edge, vertex: Vertex, otherPoint: Vertex) -> Bool {
        if triangulation.triangle.edges().contains(edge) {
            log("Skipping edge on root triangle.")
            return true
        }

        let hasGhostPoint = ghosts.intersection(Set(edge.endpoints())).count > 0
        if hasGhostPoint && !isIllegalGhostEdge(edge: edge, vertex: vertex, otherPoint: otherPoint) {
            log(String(format: "Edge (%@) is legal due to ghost point rules.", String(describing: edge)))
            return true
        }

        if !hasGhostPoint && !node.triangle.circumcircleContains(vertex: otherPoint) {
            log(String(format: "Other point %@ lies outside circumcircle of triangle %@. Edge %@ is legal.", String(describing: otherPoint), String(describing: node.triangle), String(describing: edge)))
            return true
        }

        return false
    }

    func isIllegalGhostEdge(edge: Edge, vertex: Vertex, otherPoint: Vertex) -> Bool {
        // ghost points never lie inside a circumcircle
        if ghosts.contains(otherPoint) {
            log("Test point is a ghost point.")
            return false
        }

        // if vertex is ghost2 and ghost1 is an endopint of the edge
        if vertex == ghost1 && edge.endpoints().contains(ghost2) {
            log("Original point is ghost1 and edge contains ghost2.")
            return true
        }

        let testEdge = Edge(x: otherPoint, y: vertex)
        let otherLargerThanVertex = otherPoint.lexicographicallyLargerThan(otherPoint: vertex)
        let bLeftOfTestEdge = edge.b.liesToLeft(ofEdge:testEdge)

        if edge.a == ghost1 && otherLargerThanVertex && !bLeftOfTestEdge {
            log("edge.a == ghost1 && otherLargerThanVertex && !bLeftOfTestEdge")
            return true
        }
        if edge.a == ghost1 && !otherLargerThanVertex && bLeftOfTestEdge {
            log("edge.a == ghost1 && !otherLargerThanVertex && bLeftOfTestEdge")
            return true
        }

        if edge.a == ghost2 && otherLargerThanVertex && bLeftOfTestEdge {
            log("edge.a == ghost2 && otherLargerThanVertex && bLeftOfTestEdge")
            return true
        }
        if edge.a == ghost2 && !otherLargerThanVertex && !bLeftOfTestEdge {
            log("edge.a == ghost2 && !otherLargerThanVertex && !bLeftOfTestEdge")
            return true
        }

        let aLeftOfTestEdge = edge.a.liesToLeft(ofEdge:testEdge)

        if edge.b == ghost1 && otherLargerThanVertex && !aLeftOfTestEdge {
            log("edge.b == ghost1 && otherLargerThanVertex && !aLeftOfTestEdge")
            return true
        }
        if edge.b == ghost1 && !otherLargerThanVertex && aLeftOfTestEdge {
            log("edge.b == ghost1 && !otherLargerThanVertex && aLeftOfTestEdge")
            return true
        }

        if edge.b == ghost2 && otherLargerThanVertex && aLeftOfTestEdge {
            log("edge.b == ghost2 && otherLargerThanVertex && aLeftOfTestEdge")
            return true
        }
        if edge.b == ghost2 && !otherLargerThanVertex && !aLeftOfTestEdge {
            log("edge.b == ghost2 && !otherLargerThanVertex && !aLeftOfTestEdge")
            return true
        }

        return false
    }

    /**
     - brief:
     - code:
              ^                                ^
             /|\                              /|\
            / | \                            / | \
           /  |  \                          /  |  \
          /   |   \                        /   |   \
         / W  ^  X \                      / W  ^  X \
        /   /   \   \                    /   / | \   \
       /  /eW   eX\  \                  /  /eW | eX\  \
      / /           \ \                / /     |     \ \
     //      node     \\              //       |       \\
     -------------------    ---->     /    A   |  B     \
     \\    neighbor   //              \\       |       //
      \ \           / /                \ \     |     / /
       \  \eY   eZ/  /                  \  \eY | eZ/  /
        \   \   /   /                    \   \ | /   /
         \    v    /                      \    v    /
          \ Y | Z /                        \ Y | Z /
           \  |  /                          \  |  /
            \ | /                            \ | /
             \|/                              \|/
              v                                v
     */
    func assignNeighborsAfterEdgeFlip(node: LocationGraphNode, neighbor: LocationGraphNode, nodeA: LocationGraphNode, nodeB: LocationGraphNode, legalEdge: Edge, edge: Edge) {
        // determine new neighbors after the edge flip, and the edges they meet at
        var northwestNeighbor, northeastNeighbor, southwestNeighbor, southeastNeighbor: LocationGraphNode?
        var northwestEdge, northeastEdge, southwestEdge, southeastEdge: Edge

        ((northwestNeighbor, northeastNeighbor), (northwestEdge, northeastEdge)) = findNewNeighborsAndEdges(target: node, edge: edge)
        ((southwestNeighbor, southeastNeighbor), (southwestEdge, southeastEdge)) = findNewNeighborsAndEdges(target: neighbor, edge: edge)

        // set all the new neighbor relationships
        zip([northwestNeighbor, northeastNeighbor, southwestNeighbor, southeastNeighbor], [northwestEdge, northeastEdge, southwestEdge, southeastEdge]).forEach({ (arg) in let (newNeighbor, edge) = arg
            setSurroundingNeighbors(newNodeA: nodeA, newNodeB: nodeB, newNeighbor: newNeighbor, edge: edge, oldNode: node, oldNeighbor: neighbor)
        })

        // set each new triangle as the other's neighbor
        setNeighbors(from: nodeA, to: nodeB, acrossEdge: legalEdge)
        setNeighbors(from: nodeB, to: nodeA, acrossEdge: legalEdge)

        [nodeA, nodeB].forEach {
            log(String(format: "New triangle's (%@) neighbors: \n\ta: %@\n\tb: %@\n\tc: %@", String(describing: $0.triangle), String(describing: $0.neighborA?.triangle), String(describing: $0.neighborB?.triangle), String(describing: $0.neighborC?.triangle)))
        }
    }

    func findNewNeighborsAndEdges(target: LocationGraphNode, edge: Edge) -> (neighbors: (LocationGraphNode?, LocationGraphNode?), edges: (Edge, Edge)) {
        var neighborEdge: Edge
        var neighbor: LocationGraphNode?

        if target.triangle.a != edge {
            neighbor = target.neighborA
            neighborEdge = target.triangle.a
        } else if target.triangle.b != edge {
            neighbor = target.neighborB
            neighborEdge = target.triangle.b
        } else {
            neighbor = target.neighborC
            neighborEdge = target.triangle.c
        }

        log(String(format: "Found neighbor (%@) across edge (%@).", String(describing: neighbor), String(describing: neighborEdge)))

        if !(target.triangle.a == edge || target.triangle.a == neighborEdge) {
            log(String(format: "Found other neighbor (%@) across edge (%@).", String(describing: target.neighborA), String(describing: target.triangle.a)))
            return ((neighbor, target.neighborA), (neighborEdge, target.triangle.a))
        } else if !(target.triangle.b == edge || target.triangle.b == neighborEdge) {
            log(String(format: "Found other neighbor (%@) across edge (%@).", String(describing: target.neighborB), String(describing: target.triangle.b)))
            return ((neighbor, target.neighborB), (neighborEdge, target.triangle.b))
        } else {
            log(String(format: "Found other neighbor (%@) across edge (%@).", String(describing: target.neighborC), String(describing: target.triangle.c)))
            return ((neighbor, target.neighborC), (neighborEdge, target.triangle.c))
        }
    }

    /// Sets `to` as `from`'s neighbor across `edge`
    /// - warning: not commutative
    func setNeighbors(from: LocationGraphNode, to: LocationGraphNode, acrossEdge edge: Edge) {
        if from.triangle.a == edge {
            log(String(format: "Setting triangle's (%@) A neighbor to (%@) across edge (%@).", String(describing: from.triangle), String(describing: to.triangle), String(describing: edge)))
            from.neighborA = to
        }
        else if from.triangle.b == edge {
            log(String(format: "Setting triangle's (%@) B neighbor to (%@) across edge (%@).", String(describing: from.triangle), String(describing: to.triangle), String(describing: edge)))
            from.neighborB = to
        }
        else if from.triangle.c == edge {
            log(String(format: "Setting triangle's (%@) C neighbor to (%@) across edge (%@).", String(describing: from.triangle), String(describing: to.triangle), String(describing: edge)))
            from.neighborC = to
        }
    }

    func setSurroundingNeighbors(newNodeA: LocationGraphNode, newNodeB: LocationGraphNode, newNeighbor: LocationGraphNode?, edge: Edge, oldNode: LocationGraphNode, oldNeighbor: LocationGraphNode) {
        if newNodeA.triangle.a == edge {
            log(String(format: "Setting triangle's (%@) A neighbor to (%@) across edge (%@).", String(describing: newNodeA.triangle), String(describing: newNeighbor?.triangle), String(describing: edge)))
            newNodeA.neighborA = newNeighbor
        }
        else if newNodeA.triangle.b == edge {
            log(String(format: "Setting triangle's (%@) B neighbor to (%@) across edge (%@).", String(describing: newNodeA.triangle), String(describing: newNeighbor?.triangle), String(describing: edge)))
            newNodeA.neighborB = newNeighbor
        }
        else if newNodeA.triangle.c == edge {
            log(String(format: "Setting triangle's (%@) C neighbor to (%@) across edge (%@).", String(describing: newNodeA.triangle), String(describing: newNeighbor?.triangle), String(describing: edge)))
            newNodeA.neighborC = newNeighbor
            
        }
        else if newNodeB.triangle.a == edge {
            log(String(format: "Setting triangle's (%@) A neighbor to (%@) across edge (%@).", String(describing: newNodeB.triangle), String(describing: newNeighbor?.triangle), String(describing: edge)))
            newNodeB.neighborA = newNeighbor

        }
        else if newNodeB.triangle.b == edge {
            log(String(format: "Setting triangle's (%@) B neighbor to (%@) across edge (%@).", String(describing: newNodeB.triangle), String(describing: newNeighbor?.triangle), String(describing: edge)))
            newNodeB.neighborB = newNeighbor

        }
        else if newNodeB.triangle.c == edge {
            log(String(format: "Setting triangle's (%@) C neighbor to (%@) across edge (%@).", String(describing: newNodeB.triangle), String(describing: newNeighbor?.triangle), String(describing: edge)))
            newNodeB.neighborC = newNeighbor

        }

        let neighborNode = newNodeA.triangle.edges().contains(edge) ? newNodeA : newNodeB
        if let neighborA = newNeighbor?.neighborA, neighborA.triangle == oldNode.triangle || neighborA.triangle == oldNeighbor.triangle {
            log(String(format: "Setting neighboring triangle's (%@) A neighbor to (%@) across edge (%@).", String(describing: newNeighbor?.triangle), String(describing: neighborNode.triangle), String(describing: edge)))
            newNeighbor?.neighborA = neighborNode
        } else if let neighborB = newNeighbor?.neighborB, neighborB.triangle == oldNode.triangle || neighborB.triangle == oldNeighbor.triangle {
            log(String(format: "Setting neighboring triangle's (%@) B neighbor to (%@) across edge (%@).", String(describing: newNeighbor?.triangle), String(describing: neighborNode.triangle), String(describing: edge)))
            newNeighbor?.neighborB = neighborNode
        } else {
            log(String(format: "Setting neighboring triangle's (%@) C neighbor to (%@) across edge (%@).", String(describing: newNeighbor?.triangle), String(describing: neighborNode.triangle), String(describing: edge)))
            newNeighbor?.neighborC = neighborNode
        }
    }

}
