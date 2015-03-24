require_relative 'game_field'
require_relative 'settings'

class Map

  include Settings

  def initialize
    @grid = []
    y_pixels.times do
      row = []
      x_pixels.times do
        row << GameField.new
      end
      @grid << row
    end

    # setup x border
    x_pixels.times do |idx|
      @grid[0][idx] = GameField.new('black', :border)
      @grid[y_pixels-1][idx] = GameField.new('black', :ground_border)
    end

    # setup y border
    y_pixels.times do |idy|
      @grid[idy][0] = GameField.new('black', :border)
      @grid[idy][x_pixels-1] = GameField.new('black', :border)
    end

    spawn_new_shape
  end

  def spawn_new_shape
    @shape = Shape.new(self, random_color)
  end

  # Retrieve a map field at a provided position.
  #
  # @param idx [Integer] column index in grid using matrix convention
  # @param idy [Integer] row index in grid using matrix convention
  # @return [GameField] field at given grid position encoding a certain state.
  def field_at(idx, idy)
    @grid[idy][idx]
  end

  def set_field_at(idx, idy, color)
    field = field_at(idx, idy)
    field.color = color
  end

  def move_shape_one_down
    @shape.move_shape(Point2f.new(0, 1))
  end

  # iterate row-wise though grid and look for '4'-rows (w/e border).
  # Each such row should be deleted and a players score should be incremented accordingly.
  def check_for_combo
    @grid.each do |row|
      row_deletable = true
      (1..12).each do |idx|
        row_deletable &&= row[idx].placed?
      end

      if row_deletable
        clear(row)
        # TODO: this is currently super buggy: apply_gravity
      end

    end

    # TODO apply gravity

  end

  def clear(row)
    (1..12).each do |idx|
      row[idx].wipe_out
    end
  end

  # applied gravity to floating blocks
  # foreach cell (starting from bottom row going
  # upwards find their floor and let them sink)
  def apply_gravity
    current_depth = @grid.length - 3 # initial depth level
    max_depth = @grid.length - 2 # initial depth level

    puts "inital depth #{current_depth}"

    # and not on floor row (these cells cannot sink any deeper)
    @grid[1..-1].reverse.each do |row|
      (1..12).each do |idx|
        cell = row[idx]




        # only trz to sink filled cells
        if cell.filled?
          #cell = row[idx]
          # this cell can fall

          puts "#{cell} at current_depth"

          initial_lookup_depth = current_depth
          is_falling = false


          while !field_at(idx, initial_lookup_depth+1).filled?
            break if (max_depth < initial_lookup_depth)
            is_falling = true
            initial_lookup_depth += 1
          end

          if is_falling
            field_at(idx, initial_lookup_depth-1).copy_state_from(cell)
            cell.wipe_out
          end

        end
        current_depth -= 1

      end
    end
  end




  def process_event(message)
    if message == 'd'
      @shape.move_shape(Point2f.new(1,0))
    elsif message == 'a'
      @shape.move_shape(Point2f.new(-1,0))
    elsif message == 's'
      @shape.move_shape(Point2f.new(0, 1))
    elsif message == 'w'
      @shape.rotate
    end
  end

  def to_s
    grid_as_string = ''
    @grid.each do |row|
      row.each do |field|
        grid_as_string += "#{field.to_i} "
      end
      grid_as_string += "\n"
    end
    grid_as_string
  end


end