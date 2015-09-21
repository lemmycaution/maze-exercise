require 'rails_helper'

RSpec.describe Maze, type: :model do
  describe "Creating a new maze" do
    let(:maze) {}
    it "requires width and height" do
      refute Maze.new(width:10).valid?
      assert Maze.new(width:10, height:10).valid?
    end
    it "generates maze grid for given width and height" do
      grid = Maze.create(width:2, height:2).grid
      assert_equal grid.size, 2
      assert_equal grid.map(&:size), [2, 2]
    end
  end
end
