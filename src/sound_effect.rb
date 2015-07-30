require_relative 'game_settings'

class SoundEffect

  # Sounds
  SOUND_EFFECTS = {
      :jump => "audio/jump.mp3",
      :explosion => "audio/explosion.aiff",
      :kick => "audio/kick.wav"
  }

  def initialize(sound_effects = SOUND_EFFECTS)
    @sound_effects = sound_effects
  end

  # terminate music thread:
  # end its loop, free its resources, wipe out process
  def shut_down
    @thread.exit
    wipe_out
  end

  # Run game music player relying on *mplayer*.
  # @hint: In case mplayer is not installed, this thread runs silently.
  # @param effect_sound [Symbol] a hash key in SOUND_EFFECTS.
  def play(effect_sound)
    if GameSettings.run_music?
      @thread = Thread.new do
        run = "mplayer #{@sound_effects[effect_sound]} -vo x11 -framedrop -cache 16384 -cache-min 20/100"
        system(run)
      end
    end
    nil
  end

  protected

  # kill all running mplayer processes brute force and clear console.
  def wipe_out
    system("ps aux | grep -i mplayer | awk {'print $2'} | xargs kill -9 | clear")
  end

end
