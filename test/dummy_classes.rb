# DummyClasses is a set of classes defined only within the testing environment
# used for testing. E.g used for testing whether extending/including modules
# in a class worked as expected. Having all these dummy classes at one common
# place reduces code duplication and the risk of potential side effects when
# defining in two different test classes a dumming class having the same name,
# with a method having the same name but a different implementation.
#
# @example: How a new dummy class is supposed to look like:
#
#   # @info is used by
#   # MENTION HERE IN WHICH TEST CLASS THIS DUMMY IS USED
#   class ANewDummy
#
module DummyClasses

  # @info is used by:
  #   TestCanvas
  class ACanvas < Canvas
    def public_scope_draw(g)
      drawing_methods(g)
    end
  end

  # @info is used by:
  #   TestGameMetaData
  class FancyView; end

  # @info is used by:
  #   TestGameMetaData
  class FancyAchievementSystem
    def initialize; end

    def self.instance
      FancyAchievementSystem.new
    end
  end

  # @info is used by:
  #   TestGameMetaData
  class ANewMetaDataGame
    extend GameMetaData
  end

  # @info is used by:
  #   TestGameMetaData
  class BNewMetaDataGame
    extend GameMetaData

    def self.gui_type
      FancyView
    end

    def self.achievement_system
      FancyAchievementSystem.instance
    end
  end

  # @info is used by:
  #   TestLayer
  class ANewDrawableL
    def initialize(id="")
      @id = id
      @state = "init"
    end

    def drawable?
      true
    end

    def state
      @state
    end

    def id
      @id
    end

    def update_animation_state
      @state = "#{id}"
    end

    def draw_onto(g)
      @state = "drawing #{id}"
    end
  end

  # @info is used by:
  #   TestObserver
  class ADrawable; end

  # @info is used by:
  #   TestObserver
  class ARandomClass < Observer; end

  # @info is used by:
  #   TestObserver
  class BRandomClass < Observer
    def handle_event
      puts "implemented 1"
    end

    def handle_event_with(message)
      puts "implemented 2"
    end
  end

end
