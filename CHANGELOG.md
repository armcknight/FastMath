# Changelog

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [2.0.0] 2018-09-12

### Changed

- Removed function to sort a `Set<Vertex>` into counterclockwise order.
- Converted IUO properties to nonoptional properties appropriately set before on init. `Edge.a`/`.b`, `Triangle.a`/`.b`/`.c` and `Vertex.x`/`.y`.
- Renamed a function to correctly capitalize a word: `assignNewtriangleNeighbors` becomes `assignNewTriangleNeighbors`.
- `LocationGraphNode.getTriangles()` is no longer optional. It will just return an empty set if no leaf nodes are found.

### Added

- `Edge`, `Triangle` and `Vertex` may now optionally have a name specified, or have one generated automatically on init. Helps read logs.
- Show recursion depth in logs from recursive functions.
- Bunches of comments and diagrams documenting innards of `DelaunayTriangulator`.
- Add a function to `Triangle` to output Swift code to reconstruct it, for e.g. unit tests.
- Add functions for `Set<Triangle>` to return `Set<Vertex>` and a `String` description of a sorted list of brief descriptions of all contained `Triangle`s.
- Typealiases for `Degree` and `Radian`.
- `enum`s:
	- `TrigonometricRatio` defining `cos`, `sin` etc and some helper functions.
	- `Quadrant` defining the four parts of the Cartesian plane and some query functions.
- `struct`s: 
	 - `PolarCoordinate2D`.
	 - `CartesianCoordinate2D`.
	 - `Angle` (with an `AngleOrientation` `enum` that needs to be reconciled with `PlanarOrientation`).
 - A function to compute distance between two `CGPoints`.
 

### Fixed

- In `DelaunayTriangulator`:
	- After an edge flip, not all of the necessary edges of the new pair of neighboring triangles received propagated legality testing. For two `Triangle`s adjacent on a common `Edge`, the remaining four `Edges` between them are now used to propagate edge legalization.
	- During edge legality testing, an `Edge` and another `Vertex` are used to construct a `Triangle` whose circumscribed circle is queried to contain another `Vertex` (call it `x` here). Previously, the endpoints of the `Edge` were treated specially for ghost points, and if none were there, execution proceeded directly to the incircle test. If `x` is a ghost point, the calculation is nonsensical. Inserted a new check to see if `x` is a ghost point before proceeding to the actual incircle test.
- Querying `LocationGraphNode` for all leaf `Triangle` instances would leave all its nodes' `visited` property set to `true`, so subsequent queries would return the empty set. Reset all nodes' `visited` property to `false` before returning the results of the query in `getTriangles()`.
- Comparisons of `Triangle` now consider equality between sets of its `Vertex` instances, instead of sets of its `Edge`s.
