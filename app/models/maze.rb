require 'depth_first'

class Maze < ActiveRecord::Base
  store_accessor :data, :start, :end, :width, :height, :grid
  validates_numericality_of :width, :height, less_than_or_equal_to: 30
  before_create :generate_grid

  def to_s
    @as_string ||= algorithm.to_s
  end

  private

  def generate_grid
    self.grid = algorithm.grid
    self.start = algorithm.start
    self.end = algorithm.end
  end

  def algorithm
    @algorithm ||= DepthFirst.new(self)
  end
end
