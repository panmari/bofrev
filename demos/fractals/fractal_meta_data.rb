require 'game_meta_data'
require_relative 'fractal_map'

class FractalMetaData
  extend GameMetaData

  def self.theme_list
    []
  end

  def self.sound_effect_list
    {}
  end

  def self.achievement_system
    TetrisAchievementSystem.instance
  end

  def self.achievement_system_sym
    :tetris_achievement_system
  end

  def self.game_map
    FractalMap
  end

  def self.canvas
    FreeformCanvas
  end

  def self.render_attributes
    {
      :cell_size => 1,
      :width_pixels => 600,
      :height_pixels => 600,
      :max_width => 600,
      :max_height => 600,
      :tics_per_second => 0
    }
  end

  def self.gui_type
    View
  end

  def self.allowed_controls
    {
      :keyboard => [],
      :mouse => []
    }
  end

end
