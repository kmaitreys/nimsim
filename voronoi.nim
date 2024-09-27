import math, random

# Define a point in 2D space
type
  Point = tuple[x, y: float]

# Calculate the Euclidean distance between two points
proc distance(p1, p2: Point): float =
  let dx = p1.x - p2.x
  let dy = p1.y - p2.y
  sqrt(dx * dx + dy * dy)

# Generate random points in the given bounds
proc generateRandomPoints(n: int, minX, maxX, minY, maxY: float): seq[Point] =
  result = @[]
  for _ in 0..<n:
    let x = rand(minX..maxX)
    let y = rand(minY..maxY)
    result.add((x, y))

# Lloyd's algorithm for improving the distribution of points
proc lloydsAlgorithm(points: var seq[Point], iterations: int) =
  for _ in 0..<iterations:
    var newPoints: seq[Point]
    newPoints.reserve(points.len)
    for point in points:
      var sumX = 0.0
      var sumY = 0.0
      var count = 0
      for otherPoint in points:
        if otherPoint != point:
          let dist = distance(point, otherPoint)
          sumX += otherPoint.x / dist
          sumY += otherPoint.y / dist
          inc count
      newPoints.add((sumX / count, sumY / count))
    points = newPoints

# Check if a point lies within a given rectangle
proc pointInRectangle(p: Point, minX, maxX, minY, maxY: float): bool =
  p.x >= minX and p.x <= maxX and p.y >= minY and p.y <= maxY

# Refine the grid adaptively based on a given threshold
proc refineGrid(var grid: seq[Point], minX, maxX, minY, maxY, threshold: float) =
  var newGrid: seq[Point]
  for point in grid:
    var shouldRefine = false
    for otherPoint in grid:
      if point != otherPoint:
        let dist = distance(point, otherPoint)
        if dist < threshold:
          shouldRefine = true
          break
    if shouldRefine:
      let midX = (minX + maxX) / 2.0
      let midY = (minY + maxY) / 2.0
      newGrid.add((minX, minY))
      newGrid.add((midX, minY))
      newGrid.add((maxX, minY))
      newGrid.add((minX, midY))
      newGrid.add((midX, midY))
      newGrid.add((maxX, midY))
      newGrid.add((minX, maxY))
      newGrid.add((midX, maxY))
      newGrid.add((maxX, maxY))
    else:
      newGrid.add(point)
  grid = newGrid

# Example usage
when isMainModule:
  randomize()
  let minX = 0.0
  let maxX = 10.0
  let minY = 0.0
  let maxY = 10.0
  let numPoints = 10
  var points = generateRandomPoints(numPoints, minX, maxX, minY, maxY)
  lloydsAlgorithm(points, 10)
  var grid = points
  refineGrid(grid, minX, maxX, minY, maxY, 1.0)
  echo "Initial Points:"
  for p in points:
    echo p
  echo "Refined Grid:"
  for p in grid:
    echo p
