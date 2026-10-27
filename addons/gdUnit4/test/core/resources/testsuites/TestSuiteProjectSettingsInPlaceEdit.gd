# Inner suite for GdUnitProjectSettingsAutoSaveTest.
# The first two tests edit the same dictionary setting in place, without set_setting; each test
# after the first starts from the values the one before it restored. The last test records what
# the setting holds when it starts, where the suite's own snapshot has not yet undone a leak:
#   restored values handed back to the setting as copies -> it holds neither edit
#   the restored values themselves                       -> the second edit leaks into it
extends GdUnitTestSuite

const SEEN_META := "gdunit_in_place_probe_seen"


func test_edits_setting_in_place_first() -> void:
	var rules: Dictionary = ProjectSettings.get_setting(GdUnitSettings.GDSCRIPT_WARNINGS_DIRECTORY_RULES)
	rules["res://__in_place_probe_a__"] = GdUnitSettings.GdScriptWarningDirectoryMode.INCLUDE
	assert_dict(rules).contains_keys(["res://__in_place_probe_a__"])


func test_edits_setting_in_place_second() -> void:
	var rules: Dictionary = ProjectSettings.get_setting(GdUnitSettings.GDSCRIPT_WARNINGS_DIRECTORY_RULES)
	rules["res://__in_place_probe_b__"] = GdUnitSettings.GdScriptWarningDirectoryMode.INCLUDE
	assert_dict(rules).contains_keys(["res://__in_place_probe_b__"])


func test_records_setting_it_starts_from() -> void:
	var rules: Dictionary = ProjectSettings.get_setting(GdUnitSettings.GDSCRIPT_WARNINGS_DIRECTORY_RULES)
	Engine.set_meta(SEEN_META, rules.duplicate())
	assert_dict(rules).is_not_null()
