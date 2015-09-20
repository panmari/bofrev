require 'game_meta_data'
require_relative 'sokoban_map'
require 'tetris/tetris_achievement_system'

class SokobanMetaData
  extend GameMetaData

  def self.theme_list
    []
  end

  def self.sound_effect_list
    {}
  end

  def self.achievement_system
    TetrisAchievementSystem.singleton
  end

  def self.achievement_system_sym
    :tetris_achievement_system
  end

  def self.game_map
    SokobanMap
  end

  def self.canvas
    FreeformCanvas
  end

  def self.render_attributes
    {
        :cell_size => 25,
        :width_pixels => 20,
        :height_pixels => 13,
        :max_width => 500,
        :max_height => 345,
        :tics_per_second => 0
    }
  end

  def self.gui_type
    View
  end

  def self.allowed_controls
    {
      :keyboard => [D_KEY, A_KEY, S_KEY, W_KEY],
      :mouse => []
    }
  end

end
