require "test_helper"

class TestGameMetaData < Minitest::Test

  def test_extending_works_as_expected
    assert_raises(RuntimeError, "not implemented yet"){ANewMetaDataGame.theme_list}
    assert_raises(RuntimeError, "not implemented yet"){ANewMetaDataGame.sound_effect_list}
    assert_raises(RuntimeError, "not implemented yet"){ANewMetaDataGame.achievement_system}
    assert_raises(RuntimeError, "not implemented yet"){ANewMetaDataGame.game_map}
    assert_raises(RuntimeError, "not implemented yet"){ANewMetaDataGame.canvas}
    assert_raises(RuntimeError, "not implemented yet"){ANewMetaDataGame.render_attributes}
    assert_raises(RuntimeError, "not implemented yet"){ANewMetaDataGame.gui_type}
    assert_raises(RuntimeError, "not implemented yet"){ANewMetaDataGame.allowed_controls}
  end

  def test_normalization
    filepathed_symbol = BNewMetaDataGame.gui_type_as_sym.to_s.split("/").last.to_sym
    normalized_symbol = filepathed_symbol.to_s.split("/").last.to_sym
    assert_equal(normalized_symbol, :fancy_view)
    filepathed_symbol = BNewMetaDataGame.model_type_as_sym(ANewMetaDataGame)
    normalized_symbol = filepathed_symbol.to_s.split("/").last.to_sym
    assert_equal(normalized_symbol, :a_new_meta_data_game)
    filepathed_symbol = Utility.underscore(GameMetaData.to_s)
    normalized_symbol = filepathed_symbol.to_s.split("/").last.to_sym
    assert_equal(normalized_symbol, :game_meta_data)
  end

  def test_achievment_system_sym
    filepathed_symbol = BNewMetaDataGame.achievement_system_sym
    normalized_symbol = filepathed_symbol.to_s.split("/").last.to_sym
    assert_equal(normalized_symbol, :fancy_achievement_system)
  end

end
