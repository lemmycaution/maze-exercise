// ported from lib/depth_first.rb
// resource: http://rosettacode.org/wiki/Maze_solving#Ruby

var Solver = (function () {
  var DIRECTIONS = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]

  // Solve via breadth-first algorithm.
  // Each queue entry is a path, that is list of coordinates with the
  // last coordinate being the one that shall be visited next.
  function Solver (maze) {
    this.maze = maze
    this.maze.width = parseInt(maze.width)
    this.maze.height = parseInt(maze.height)
    this.path = gen2DArray(this.maze.width, this.maze.height)
    this.visited = gen2DArray(this.maze.width, this.maze.height)
    this.queue = []
  }

  Solver.prototype.solve = function () {
    var path

    // Clean up.
    this.resetVisitingState()

    // Enqueue start position.
    this.queue = []
    this.enqueueCell([], this.maze.start.x, this.maze.start.y)

    // Loop as long as there are cells to visit and no solution has
    // been found yet.
    // while (!path || this.queue.length > 0) {
    //   path = this.solveVisitCell()
    // }
    path = this.solveVisitCell()
 
    if (path) {
      // Mark the cells that make up the shortest path.
      for(var i in path) {
        var coor = path[i]
        this.path[coor[0]][coor[1]] = true
      }
    } else {
      alert("No solution found?!")
    }
  }

  Solver.prototype.solveVisitCell = function () {
    // Get the next path.
    var path = this.queue.shift()

    // The cell to visit is the last entry in the path.
    x = path[path.length-1][0]
    y = path[path.length-1][1]
 
    // Have we reached the end yet?
    if (x === this.maze.end.x && y === this.maze.end.y) return path
 
    // Mark cell as visited.
      
    this.visited[x][y] = true
 
    for( var i = 0; i < DIRECTIONS.length; i++) {
      var direction = DIRECTIONS[i]
      var dx = direction[0]
      var dy = direction[1]
      if (dx !== 0 ) {
        // Left / Right
        newX = x + dx
        if (this.moveValid(newX, y) && !this.maze.grid.vertical[Math.min(x, newX)][y]) {
          this.enqueueCell(path, newX, y)
        }
      } else {
        // Top / Bottom
        newY = y + dy
        if (this.moveValid(x, newY) && !this.maze.grid.horizontal[x][Math.min(y, newY)]) {
          this.enqueueCell(path, x, newY)
        }
      }
    }
    if (this.queue.length > 0) {
      return this.solveVisitCell()
    } else {
      return null // No solution yet.
    }
  }

  Solver.prototype.resetVisitingState = function () {
   this.visited = gen2DArray(this.maze.width, this.maze.height)
  }

  // Enqueue a new coordinate to visit.
  Solver.prototype.enqueueCell = function (path, x, y) {
    this.queue.push(path.concat([[x,y]]))
  }

  Solver.prototype.moveValid = function (x, y) {
    return (x >= 0 && x <= this.maze.width) && (y >= 0 && y <= this.maze.height) && !(this.visited[x] && this.visited[x][y])
  }

  Solver.prototype.toString = function () {
    // Special handling: print the top line.
    var buffer = "+"
    for(var x = 0; x < this.maze.width; x++) {
      buffer += (x == this.maze.start.x ? "   +" : "---+")
    }
    buffer += "\n"
 
    // For each cell, print the right and bottom wall, if it exists.
    for(var y = 0; y < this.maze.height; y++) {
      line = "|"
      for(var x = 0; x < this.maze.width; x++) {
        line += (this.path[x][y] ? " * " : "   ") + (this.maze.grid.vertical[x][y] ? "|" : " ")
        
      }
      buffer += line + "\n"
      
      buffer += "+"
      for(var x = 0; x < this.maze.width; x++) {
        buffer +=  (this.maze.grid.horizontal[x][y] ? "---+" : "   +")
      }
      buffer += "\n"
    }
    return buffer
  }


  function gen2DArray (width, height) {
    var arr2d = []
    for (var i = 0; i < width; i ++) {
      arr2d.push(new Array(height))
    }
    return arr2d
  }

  return Solver
})()