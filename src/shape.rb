require_relative 'point2f'
require_relative 'collision_checker'
require 'thread'

# Shape encodes a collection of dependent cells that have to be placed in the game grid,
# using provided user inputs and game state updates.
#
# We can think of Shape#position_states as a # 4x4 Local coordinate system.
#   E.g. a 3x3 system would look like this:
#
#     ============================
#     | (-1,1)  | (0,1)  | (1,1) |
#     ============================
#     | (-1,0)  | (0,0)  | (1,0) |
#     ============================
#     | (-1,-1) | (0,-1) | (1,-1)|
#     ============================
#
# each cell in this matrix is a Point2f instance
# If a specific coordinate is encoded in :position_states, then use this cell.
class Shape
  attr_accessor :local_points, :origin # origin of local coordinate system, this changes during updates.
  attr_reader :color # binary shape of figure, remains constant AND color
  attr_accessor :grid_map

  # @param map [Map] game map
  # @param color [String] color identifier known by Tk
  def initialize(map, color)
    @origin = Point2f.new(5, 0)

    @position_states = position_states

    @rotation_modus = 0
    @local_points = @position_states[@rotation_modus]

    @grid_map = map
    @color = color
    @mutex = Mutex.new
    @play_sound_effect = false

    map_positions.each do |p|
      @grid_map.set_field_at(p.x, p.y, color)
    end

  end

  # A collection of orientations of a given shape.
  # Each sub.array represents an shape orientation state
  # Each shape has 4 states, i.e. 4 sub-arrays.
  # @return [Array] of Arrays that contain Point2f elements
  def position_states
    raise "not implemented yet."
  end

  def next_rotation_position
    @position_states[(@rotation_modus+1)%4]
  end

  def next_moved_origin(shift)
    Point2f.new(1,1).add(@origin).add(shift)
  end

  # @param [Boolean] was shape not blocked?
  def rotate
    @play_sound_effect = false
    unless CollisionChecker.new(self, :rotate).blocked?
      @mutex.synchronize do

        @play_sound_effect = true

        map_positions.each do |p|
          @grid_map.set_field_at(p.x, p.y, 'white')
        end

        @rotation_modus = (@rotation_modus + 1) % 4
        @local_points = @position_states[@rotation_modus]

        map_positions.each do |p|
          @grid_map.set_field_at(p.x, p.y, @color)
        end
      end
    end
    @play_sound_effect
  end

  # @param move_by [Point2f] relative movement in plane.
  def move_shape(move_by=Point2f.new(0,0), movement_type = :move)
    collision_state = CollisionChecker.new(self, movement_type, move_by)

    if !collision_state.blocked?
      @mutex.synchronize do

        map_positions.each do |p|
          @grid_map.set_field_at(p.x, p.y, 'white')
        end

        update_position_by(move_by)

        map_positions.each do |p|
          @grid_map.set_field_at(p.x, p.y, @color)
        end
      end
    elsif collision_state.state == :grounded
      @grid_map.spawn_new_shape
    end
  end

  def to_s
    (@local_points.map &:to_s).join(" ")
  end

  def points_in_grid_coords
    @local_points.map do |point|
      Point2f.new(point.x + @origin.x + 1, point.y + @origin.y + 1)
    end
  end

  def mark_fields_placed
    points_in_grid_coords.each do |p|
      target_cell = @grid_map.field_at(p.x, p.y)
      target_cell.type = :placed
    end

    return @grid_map.initiate_game_over if was_game_over_movement?

    @grid_map.check_for_combo

  end

  def apply_combo_check
    @grid_map.check_for_combo
  end

  private

  # Check for Game over movement if we want to place a block onto a
  # cell is placed an top inner row.
  #
  # @return [Boolean] :true if we got killed by current placement
  #         otherwise :false
  def was_game_over_movement?
    points_in_grid_coords.each do |p|
      target_cell = @grid_map.field_at(p.x, p.y)
      if p.y == 1 && target_cell.type == :placed
        return true
      end
    end
    false
  end

  # position of this shape in map coordinate system
  def map_positions
    shifted_position(@origin)
  end

  # updates local postions of this shape
  def update_position_by(shift)
    @origin = @origin.add(shift)
  end

  def shifted_position(base, shift_by=Point2f.new(0,0))
    @local_points.map do |cell|
      Point2f.new(base.x + cell.x + shift_by.x + 1, base.y + cell.y + shift_by.x + 1)
    end
  end

end