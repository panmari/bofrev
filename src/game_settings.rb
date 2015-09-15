require 'game_meta_data'
require 'system_information'
require_relative 'apps/tetris/tetris_meta_data'
require_relative 'apps/game_of_life/game_of_life_meta_data'
require_relative 'apps/sokoban/sokoban_meta_data'
require_relative 'apps/snake/snake_meta_data'
require_relative 'apps/pingpong/ping_pong_meta_data'
require_relative 'apps/demo_sprites/demo_sprites_meta_data'
require_relative 'apps/fractals/fractal_meta_data'

# Singleton class
class GameSettings
  include GameMetaData

  CANVAS_OFFSET_X_WINDOWS = 6
  CANVAS_OFFSET_X_DEFAULT = 1
  CANVAS_OFFSET_Y_DEFAULT = 45

  # @param arguments [Hash] of relevant data to derive game settings
  # @hing The following keys are currently handled:
  #   :selected_game #=> [Integer] current game
  #     See REEDME.md
  #
  #   :selected_mode #=> [Integer] selected debug mode
  #     0: normal running mode
  #     1: without running the music thread
  #     2: without running the ticker thread
  def initialize(arguments={})
    @selected_game = arguments[:game] || 1
    @selected_mode = arguments[:debug] || 0
    @game_meta_data = derive_game_model
  end

  # Fetch GameSettings singleton
  #
  # @hint: builds a GameSettings instance if not already exists
  # otherwise return existing instance.
  # @param arguments [Hash] user passed bofrev runtime arguments
  # default value is {}. The following arguments are currently fetched:
  #   :game [Integer] what game should be run default is 1 (Tetris)
  #     see repository README
  #   :debug [Integer] in which debug mode is bofrev running.
  #     default is 0 (run music and ticker thread)
  #       1 only run ticker thread but no music
  #       2 only accept user input but do not run any ticker nor any music thread.
  # @return [GameSettings] singleton.
  def self.build_from(arguments={})
    if @game_settings.nil?
      @game_settings = GameSettings.new(arguments)
    end
    @game_settings
  end

  # Flushes all current game settings.
  # @hint: Sets internal GameSettings instance to nil.
  #   used to load another game during runtime.
  def self.flush
    @game_settings = nil
  end

  # Obtain game_meta_data according to selected game.
  #
  # @hint: See GameSettings#derive_game_model,
  #   value is bofrev runtime argument -g
  # @return [GameMetaData] instance that belongs to selected game.
  #   default value is TetrisMetaData
  def game_meta_data
    @game_meta_data
  end

  # Obtain the number of the selected_game.
  #
  # @hint: its value is given by bofrev's runtime argument -g
  #   See the README.md for further information.
  # @return [Integer] number value of selected game.
  #   default value is 1.
  def selected_game
    @selected_game
  end

  # Obtain the number of the selected game debugging mode.
  #
  # @hint: its value is given by bofrev's runtime argument -d
  #   See the README.md for further information.
  # @return [Integer] number value of selected debug mode.
  #   default value is 0.
  def selected_mode
    @selected_mode
  end

  # Retrieve the selected game meta data file that belongs to the selected game.
  #
  # @return [GameMetaData] according to the selected game number.
  def derive_game_model
    case @selected_game
    when 1
      TetrisMetaData
    when 2
      GameOfLifeMetaData
    when 3
      SokobanMetaData
    when 4
      SnakeMetaData
    when 5
      PingPongMetaData
    when 6
      FractalMetaData
    when 7
      DemoSpritesMetaData
    end
  end

  def self.canvas
    game_meta_data.canvas
  end

  def self.game_meta_data
    build_from.game_meta_data
  end

  def self.selected_gui
    game_meta_data.gui_type_as_sym
  end

  def self.gui_to_build
    game_meta_data.gui_type
  end

  def self.run_music?
    build_from.selected_mode < 1 && !(theme_list).empty?
  end

  def self.run_game_thread?
    build_from.selected_mode < 2
  end

  # Get the Map that should be build for the target application.
  #
  # @hint: The name of this target Map class is stored in the GameMetaData
  #   that belongs to the target application.
  #   Can be obtained by GameSettings#derive_game_model
  # @return [Map] a class that inherits from Map implementing its methods.
  def self.game_map
    game_meta_data.game_map
  end

  def self.theme_list
    game_meta_data.theme_list
  end

  def self.sound_effect_list
    game_meta_data.sound_effect_list
  end

  def self.achievement_system
    game_meta_data.achievement_system
  end

  def self.achievement_system_sym
    game_meta_data.achievement_system_sym
  end

  def self.render_attributes
    game_meta_data.render_attributes
  end

  def self.allowed_controls
    game_meta_data.allowed_controls
  end

  def self.cell_size
    GameSettings.render_attributes[:cell_size]
  end

  def self.width_pixels
    GameSettings.render_attributes[:width_pixels]
  end

  def self.height_pixels
    GameSettings.render_attributes[:height_pixels]
  end

  def self.max_height
    GameSettings.render_attributes[:max_height]
  end

  def self.max_width
    GameSettings.render_attributes[:max_width]
  end

  def self.tics_per_second
    GameSettings.render_attributes[:tics_per_second]
  end

  def self.show_grid?
    grid_is_shown = GameSettings.render_attributes[:show_grid]
    grid_is_shown.nil? ? true : grid_is_shown
  end

  # Get top level folder name where the audio folder lies in.
  #
  # @hint: In case bofrev is called by its executable jar, there is an additional
  # namespace folder called 'bofrev'. Every folder of the bofrev folder is put into
  # this parent folder by the jar. When running bofrev from the code, there is no such parent
  # folder. This is why we return for this case the prefix ''.
  #
  # @return [String] 'bofrev/' if bofrev.jar is called and '' otherwise.
  def self.audio_filefolder_prefix
    SystemInformation.called_by_jar? ? 'bofrev/' : ''
  end

  # return [Array] including canvas offsets for packing into main_frame.
  def self.canvas_offsets
    on_windows = SystemInformation.running_on_windows?
    offset_x = on_windows ? CANVAS_OFFSET_X_WINDOWS
                          : CANVAS_OFFSET_X_DEFAULT
    offset_y = CANVAS_OFFSET_Y_DEFAULT
    [offset_x, offset_y]
  end

  def self.canvas_width
    canvas_offsets[0] + max_width
  end

  def self.canvas_height
    canvas_offsets[1] + max_height
  end

end
