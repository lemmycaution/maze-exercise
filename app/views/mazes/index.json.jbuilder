json.array!(@mazes) do |maze|
  json.extract! maze, :id, :width, :height, :grid
  json.url maze_url(maze, format: :json)
end
