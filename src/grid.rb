require_relative 'game_field'
require 'pry'

# Grid is the Data Structure for an arbitrary 2d-(M x N) pixel game.
# A grid has actually (M+2)x(N+2) pixels. There is an border around the grid.
#
# Benefits:
#   + That can be used to perform intersection tests.
#     e.g. if hit border pixel, then we detected a collision.
#
#   + Allows to define Gui-pixel resolution independent from number of game cells.
#
# Internal representation is encoded initially as the following:
#
#   B B .. B B
#   B 0 .. 0 B
#   .        .
#   .        .
#   B 0 .. 0 B
#   B B .. B B
#
# where B depicts a border cell,
class Grid

  # Build a new Grid of Dimension (width x height)
  #
  # @example: Grid.new(8,5).to_s
  #   #=>
  #     2 2 2 2 2 2 2 2 2 2
  #     2 0 0 0 0 0 0 0 0 2
  #     2 0 0 0 0 0 0 0 0 2
  #     2 0 0 0 0 0 0 0 0 2
  #     2 0 0 0 0 0 0 0 0 2
  #     2 0 0 0 0 0 0 0 0 2
  #     2 3 3 3 3 3 3 3 3 2
  #
  # @param width [Integer] width of grid
  # @param height [Integer] height of grid
  def initialize(width, height)

    # assign dimensions
    @inner_width = width
    @inner_height = height

    # Internal data-structure of a the grid.
    @data = build_empty_grid

    specify_borders
    encode_grid_neighborhood
  end

  # Get total width of grid that is the 2 Border pixels
  # plus M from the grid kernel (sides).
  #
  # @return [Integer] total width of grid - kernel + border
  def total_width
    @inner_width + 2
  end

  # Get total height of grid that is the 2 Border pixels
  # plus N from the grid kernel (floor & ceil).
  #
  # @return [Integer] total height of grid
  def total_height
    @inner_height + 2
  end

  # Get row at given index.
  # @param idx [Integer] row index
  # @hint: Note that Index enumeration starts at 0
  #        border rows - Index 0 & @grid.size are
  def row_at(idx)
    @data[idx]
  end

  # Get game field at position (x,y) in MxN grid.
  #
  # @param x [Integer] row index
  # @param y [Integer] column index
  # @return [GameField] at given (x,y) location.
  def field_at(x, y)
    # NB: lookup is inverted, since array is build internally this way:
    # see Grid#build_empty_grid
    @data[y][x]
  end

  # Assign a new game field :field at a given location (x,y) in the grid.
  #
  # @param x [Integer] row index
  # @param y [Integer] column index
  # @param field [GameField] game field used for update
  def set_field_at(x, y, field)
    @data[y][x] = field
  end

  # @return [String] Matrix form of grid encoded as string.
  def to_s
    grid_as_string = ''
    @data.each do |row|
      row.each do |field|
        grid_as_string += "#{field.to_i} "
      end
      grid_as_string += "\n"
    end
    grid_as_string
  end

  private

  # Create an empty game grid cells
  #
  # @hint: (1..4).map do (1..2).map do 1 end end
  #   #=> [[1, 1], [1, 1], [1, 1], [1, 1]]
  #
  # @return [Array[Array]] an array of arrays encoding the game grid.
  def build_empty_grid
    @data = (1..total_height).map do (1..total_width).map {GameField.new} end
  end

  # Mark Grid Borders as special pixels
  def specify_borders
    # setup y border
    total_width.times do |idy|
      set_field_at(idy, 0, GameField.new('black', :border))
      set_field_at(idy, total_height-1, GameField.new('black', :ground_border))
    end

    # setup x border
    total_height.times do |idx|
      set_field_at(0, idx, GameField.new('black', :border))
      set_field_at(total_width-1, idx, GameField.new('black', :border))
    end
  end

  # Encode 4-Neighborhood information to every game field (except borders).
  def encode_grid_neighborhood

    # only iterate over kernel: we do not care about border cells
    (1..total_height-2).each do |idy|
      (1..total_width-2).each do |idx|
        cell = field_at(idx, idy)
        neighbors = {
            :right => field_at(idx+1, idy), :left => field_at(idx-1, idy),
            :bottom => field_at(idx, idy+1), :top => field_at(idx, idy-1)
        }
        cell.assign_neighborhood(neighbors)
      end
    end
  end

end