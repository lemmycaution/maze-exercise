# https://en.wikipedia.org/wiki/Maze_generation_algorithm#Depth-first_search

class DepthFirst
  DIRECTIONS = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]
 
  attr_reader :width, :height, :grid, :start, :end
   
  def initialize(maze)
    raise ArgumentError.new("first argument must be a valid `Maze` instance") unless maze.valid?    
    @width   = maze.width.to_i
    @height  = maze.height.to_i
    @start_x = rand(@width)
    @start_y = 0
    @end_x   = rand(@height)
    @end_y   = @height - 1
 
    # Which walls do exist? Default to "true". Both arrays are
    # one element bigger than they need to be. For example, the
    # @vertical_walls[x][y] is true if there is a wall between
    # (x,y) and (x+1,y). The additional entry makes printing easier.
    @vertical_walls   = Array.new(@width) { Array.new(@height, true) }
    @horizontal_walls = Array.new(@width) { Array.new(@height, true) }
    # Path for the solved maze.
    @path             = Array.new(@width) { Array.new(@height) }
 
    # "Hack" to print the exit.
    @horizontal_walls[@end_x][@end_y] = false
 
    # Generate the maze or fill from existing data
    unless maze.persisted?
      generate
    else
      @start_x = maze.start['x']
      @start_y = maze.start['y']
      @end_x   = maze.end['x']
      @end_y   = maze.end['y']
      @vertical_walls = maze.grid['vertical']
      @horizontal_walls = maze.grid['horizontal']
    end
  end
  
  # Solve via breadth-first algorithm.
  # Each queue entry is a path, that is list of coordinates with the
  # last coordinate being the one that shall be visited next.
  def solve
 
    # Clean up.
    reset_visiting_state
 
    # Enqueue start position.
    @queue = []
    enqueue_cell([], @start_x, @start_y)
 
    # Loop as long as there are cells to visit and no solution has
    # been found yet.
    path = nil
    until path || @queue.empty?
      path = solve_visit_cell
    end
 
    if path
      # Mark the cells that make up the shortest path.
      for x, y in path
        @path[x][y] = true
      end
    else
      puts "No solution found?!"
    end
  end
 
  # Print a nice ASCII maze.
  def to_s
    # Special handling: print the top line.
    buffer = @width.times.inject("+") {|str, x| str << (x == @start_x ? "   +" : "---+")} + "\n"
 
    # For each cell, print the right and bottom wall, if it exists.
    @height.times do |y|
      line = @width.times.inject("|") do |str, x|
        str << (@path[x][y] ? " * " : "   ") << (@vertical_walls[x][y] ? "|" : " ")
      end
      buffer << line + "\n"
 
      buffer << @width.times.inject("+") {|str, x| str << (@horizontal_walls[x][y] ? "---+" : "   +")} + "\n"
    end
    buffer
  end
  
  def grid
    {vertical: @vertical_walls, horizontal: @horizontal_walls}
  end
  
  def start
    {x: @start_x, y: @start_y}
  end
  
  def end
    {x: @end_x, y: @end_y}
  end
 
  private
 
  # Reset the VISITED state of all cells.
  def reset_visiting_state
    @visited = Array.new(@width) { Array.new(@height) }
  end
 
  # Is the given coordinate valid and the cell not yet visited?
  def move_valid?(x, y)
    (0...@width).cover?(x) && (0...@height).cover?(y) && !@visited[x][y]
  end
 
  # Generate the maze.
  def generate
    reset_visiting_state
    generate_visit_cell(@start_x, @start_y)
  end
 
  # Depth-first maze generation.
  def generate_visit_cell(x, y)
    # Mark cell as visited.
    @visited[x][y] = true
 
    # Randomly get coordinates of surrounding cells (may be outside
    # of the maze range, will be sorted out later).
    coordinates = DIRECTIONS.shuffle.map { |dx, dy| [x + dx, y + dy] }
 
    for new_x, new_y in coordinates
      next unless move_valid?(new_x, new_y)
 
      # Recurse if it was possible to connect the current and
      # the cell (this recursion is the "depth-first" part).
      connect_cells(x, y, new_x, new_y)
      generate_visit_cell(new_x, new_y)
    end
  end
 
  # Try to connect two cells. Returns whether it was valid to do so.
  def connect_cells(x1, y1, x2, y2)
    if x1 == x2
      # Cells must be above each other, remove a horizontal wall.
      @horizontal_walls[x1][ [y1, y2].min ] = false
    else
      # Cells must be next to each other, remove a vertical wall.
      @vertical_walls[ [x1, x2].min ][y1] = false
    end
  end
  
  # Maze solving visiting method.
  def solve_visit_cell
    # Get the next path.
    path = @queue.shift
    # The cell to visit is the last entry in the path.
    x, y = path.last
 
    # Have we reached the end yet?
    return path if x == @end_x && y == @end_y
 
    # Mark cell as visited.
    @visited[x][y] = true
 
    for dx, dy in DIRECTIONS
      if dx.nonzero?
        # Left / Right
        new_x = x + dx
        if move_valid?(new_x, y) && !@vertical_walls[ [x, new_x].min ][y]
          enqueue_cell(path, new_x, y)
        end
      else
        # Top / Bottom
        new_y = y + dy
        if move_valid?(x, new_y) && !@horizontal_walls[x][ [y, new_y].min ]
          enqueue_cell(path, x, new_y)
        end
      end
    end
    puts "QUEUE #{@queue}"
    nil         # No solution yet.
  end
 
  # Enqueue a new coordinate to visit.
  def enqueue_cell(path, x, y)
    # Add new coordinates to the current path and enqueue the new path.
    @queue << path + [[x, y]]
  end
end