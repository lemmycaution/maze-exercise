# NOTE: After reading whole serie of excellent maze tutorial for programmers from Jamis Buck
# I have decided to not to write my own but using recursive backtrace algorithm example from 
# from http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking.html
# as it's optimised and fast enough to go with
# If app requires to render different style of mazes, his library theseus for creating and solving mazes can be forked for implementation from https://github.com/jamis/theseus

# --------------------------------------------------------------------
# Recursive backtracking algorithm for maze generation. Requires that
# the entire maze be stored in memory, but is quite fast, easy to
# learn and implement, and (with a few tweaks) gives fairly good mazes.
# Can also be customized in a variety of ways.
# --------------------------------------------------------------------

class RecursiveBacktrace

  # --------------------------------------------------------------------
  # Set up constants to aid with describing the passage directions
  # --------------------------------------------------------------------
  N, S, E, W = 1, 2, 4, 8
  DX         = { E => 1, W => -1, N =>  0, S => 0 }
  DY         = { E => 0, W =>  0, N => -1, S => 1 }
  OPPOSITE   = { E => W, W =>  E, N =>  S, S => N }
  
  attr_reader :width, :height, :grid

  def initialize maze
    raise ArgumentError.new("first argument must be a valid `Maze` instance") unless maze.valid?
    @width  = maze.width.to_i
    @height = maze.height.to_i
    @grid = Array.new(@height) { Array.new(@width, 0) }
    seed   = (ARGV[2] || rand(0xFFFF_FFFF)).to_i
    srand(seed)
    carve_passages_from(0, 0, @grid)
  end
  
  def to_s
    str = " " + "_" * (width * 2 - 1) + "\n"
    height.times do |y|
      str << "|"
      width.times do |x|
        str << ((grid[y][x] & S != 0) ? " " : "_")
        if grid[y][x] & E != 0
          str << (((grid[y][x] | grid[y][x+1]) & S != 0) ? " " : "_")
        else
          str << "|"
        end
      end
      str << "\n"
    end
    str
  end

  private

  # --------------------------------------------------------------------
  # The recursive-backtracking algorithm itself
  # --------------------------------------------------------------------
  def carve_passages_from(cx, cy, grid)
    directions = [N, S, E, W].sort_by{rand}

    directions.each do |direction|
      nx, ny = cx + DX[direction], cy + DY[direction]

      if ny.between?(0, grid.length-1) && nx.between?(0, grid[ny].length-1) && grid[ny][nx] == 0
        grid[cy][cx] |= direction
        grid[ny][nx] |= OPPOSITE[direction]
        carve_passages_from(nx, ny, grid)
      end
    end
  end

end