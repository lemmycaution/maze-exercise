require 'rails_helper'

RSpec.describe "mazes/show", type: :view do
  before(:each) do
    @maze = assign(:maze, Maze.create!(
      :width => 3,
      :height => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
