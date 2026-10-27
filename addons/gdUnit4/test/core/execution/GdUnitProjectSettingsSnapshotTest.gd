# GdUnit generated TestSuite
class_name GdUnitProjectSettingsSnapshotTest
extends GdUnitTestSuite

const IGNORE := GdUnitSettings.GdScriptWarningMode.IGNORE
const WARN := GdUnitSettings.GdScriptWarningMode.WARN
const ERROR := GdUnitSettings.GdScriptWarningMode.ERROR
const EXCLUDE := GdUnitSettings.GdScriptWarningDirectoryMode.EXCLUDE
const INCLUDE := GdUnitSettings.GdScriptWarningDirectoryMode.INCLUDE


#region save / restore


func test_restore_restores_scalar_setting() -> void:
	# Setup
	var snapshot := GdUnitProjectSettingsSnapshot.new()
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION, IGNORE)
	snapshot.save()
	# Act
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION, ERROR)
	snapshot.restore()
	# Verify
	assert_int(ProjectSettings.get_setting(GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION))\
		.is_equal(IGNORE)


func test_restore_restores_dictionary_setting() -> void:
	# Setup
	var snapshot := GdUnitProjectSettingsSnapshot.new()
	var original_rules: Dictionary = { "res://addons": EXCLUDE }
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_DIRECTORY_RULES, original_rules.duplicate())
	snapshot.save()
	# Act
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_DIRECTORY_RULES, { "res://modified": INCLUDE })
	snapshot.restore()
	# Verify
	assert_dict(ProjectSettings.get_setting(GdUnitSettings.GDSCRIPT_WARNINGS_DIRECTORY_RULES))\
		.is_equal(original_rules)


func test_restore_does_not_change_unmodified_settings() -> void:
	# Setup
	var snapshot := GdUnitProjectSettingsSnapshot.new()
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION, IGNORE)
	snapshot.save()
	# Act
	snapshot.restore()
	# Verify
	assert_int(ProjectSettings.get_setting(GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION))\
		.is_equal(IGNORE)


func test_restore_without_save_does_nothing() -> void:
	# Setup
	var snapshot := GdUnitProjectSettingsSnapshot.new()
	# Act
	snapshot.restore()
	snapshot.restore()
	# Verify — no error, no crash
	assert_bool(true).is_true()


func test_restore_returns_the_restored_values() -> void:
	# Setup
	var snapshot := GdUnitProjectSettingsSnapshot.new()
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION, IGNORE)
	snapshot.save()
	# Act
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION, ERROR)
	var restored := snapshot.restore()
	# Verify
	assert_int(restored[GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION]).is_equal(IGNORE)
	assert_dict(snapshot.restore()).is_empty()


func test_take_restores_the_taken_values() -> void:
	# Setup
	var first := GdUnitProjectSettingsSnapshot.new()
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION, IGNORE)
	first.save()
	var second := GdUnitProjectSettingsSnapshot.new()
	second.take(first.restore())
	# Act
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION, ERROR)
	second.restore()
	# Verify
	assert_int(ProjectSettings.get_setting(GdUnitSettings.GDSCRIPT_WARNINGS_INFERRED_DECLARATION))\
		.is_equal(IGNORE)


func test_restored_dictionary_is_a_copy() -> void:
	# Setup
	var snapshot := GdUnitProjectSettingsSnapshot.new()
	var original_rules: Dictionary = { "res://addons": EXCLUDE }
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_DIRECTORY_RULES, original_rules.duplicate())
	snapshot.save()
	ProjectSettings.set_setting(GdUnitSettings.GDSCRIPT_WARNINGS_DIRECTORY_RULES, { "res://modified": INCLUDE })
	var restored := snapshot.restore()
	# Act
	var rules: Dictionary = ProjectSettings.get_setting(GdUnitSettings.GDSCRIPT_WARNINGS_DIRECTORY_RULES)
	rules["res://edited"] = INCLUDE
	# Verify
	assert_dict(restored[GdUnitSettings.GDSCRIPT_WARNINGS_DIRECTORY_RULES]).is_equal(original_rules)

#endregion
