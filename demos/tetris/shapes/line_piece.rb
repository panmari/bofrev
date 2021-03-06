require_relative '../shape'
require_relative '../tetris'

class Tetris::LinePiece < Tetris::Shape

  def initialize(map, color)
    super(map, color)
  end

  def position_states
    [
        [Point2f.new(-1,0), Point2f.new(0,0), Point2f.new(1,0), Point2f.new(2,0)],
        [Point2f.new(0,-1), Point2f.new(0,0), Point2f.new(0,1), Point2f.new(0,-2)],
        [Point2f.new(-1,0), Point2f.new(0,0), Point2f.new(1,0), Point2f.new(-2,0)],
        [Point2f.new(0,-1), Point2f.new(0,0), Point2f.new(0,1), Point2f.new(0,2)]
    ]
  end
end
