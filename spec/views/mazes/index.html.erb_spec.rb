require 'rails_helper'

RSpec.describe "mazes/index", type: :view do
  before(:each) do
    assign(:mazes, [
      Maze.create!(
        :width => 3,
        :height => 3
      ),
      Maze.create!(
        :width => 3,
        :height => 3
      )
    ])
  end

  it "renders a list of mazes" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
