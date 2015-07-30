require_relative 'grid'
require_relative 'game_field'
require_relative 'settings'
require_relative 'point2f'
require_relative 'sound_effect'
require_relative 'game_settings'
require_relative 'drawables/shape_manager'

class Map

  include Settings

  def initialize(game)
    @sound_effect = SoundEffect.new(GameSettings.sound_effect_list)
    @game = game
    @grid = Grid.new(GameSettings.width_pixels, GameSettings.height_pixels)
    @shape_manager = ShapeManager.new
  end

  def shapes
    @shape_manager.shapes
  end

  # Appends a a Shape instance to @shape_manager.
  # @param shape [Shape]
  def append_shape(shape)
    @shape_manager.append(shape)
  end

  # Removes a a Shape instance from @shape_manager.
  # @param shape [Shape]
  def remove_shape(shape)
    @shape_manager.remove(shape)
  end

  def set_field_color_at(x, y, color)
    @grid.set_field_color_at(x, y, color)
  end

  def set_field_value_at(x, y, value)
    @grid.set_field_value_at(x, y, value)
  end

  def clear_field_at(x, y)
    @grid.flush_field_at(x, y)
  end

  def field_at(x,y)
    @grid.field_at(x,y)
  end

  # clears the whole inner row at index :idx
  def clear(idx)
    @sound_effect.play(:explosion)
    @grid.inner_row_at(idx).each &:wipe_out
  end

  # defines how user input should be handled to update the game state.
  def process_event(message)
    raise "not implemented yet"
  end

  # defines how thicker should update this map.
  def process_ticker
    raise "not implemented yet"
  end

  def initiate_game_over
    @game.initiate_game_over
  end

  # Transforms coordinates in canvas coordinate system
  # to coordinates in grid (index) coordinates.
  #
  # @param canvas_coord [Point2f] canvas coordinates
  # @return [Point2f] (inner) grid coordinates
  def to_grid_coord(canvas_coord)
    transform_coordinates(canvas_coord)
  end


  # from canvas coordinates (clicked at position) to grid coordinates
  # (determine which grid cell has been clicked)
  # @param point [Point2f] canvas coordinates
  # @return [Point2f] (inner) grid coordinates
  def transform_coordinates(point)

    x_frac = (GameSettings.cell_size.to_f/GameSettings.width_pixels)
    y_frac = (GameSettings.cell_size.to_f/GameSettings.height_pixels)

    x_grid = (point.x / (x_frac*GameSettings.width_pixels.to_f)).to_i
    y_grid = (point.y / (y_frac*GameSettings.height_pixels.to_f)).to_i

    # truncated: TODO report this
    x_grid = GameSettings.width_pixels if x_grid > GameSettings.width_pixels
    y_grid = GameSettings.height_pixels if y_grid > GameSettings.height_pixels


    # since there is a border around the grid we have to shift the zero
    grid_p = Point2f.new(x_grid, y_grid).add(Point2f.new(1,1))

    puts "(#{grid_p})"
    grid_p
  end

end
