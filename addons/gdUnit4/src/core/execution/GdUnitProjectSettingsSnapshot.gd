class_name GdUnitProjectSettingsSnapshot
extends RefCounted
## Captures and restores all in-memory [ProjectSettings] values around a single
## stage of test execution.[br]
## Suite-level and test-level isolation are achieved by two separate snapshots of the
## test suite context rather than by stacking:[br]
## [codeblock]
##   GdUnitTestSuiteExecutionStage  -> save()   (before before())
##   GdUnitTestSuiteExecutionStage  -> save()   (after before(), the state every test case starts from)
##     GdUnitTestCaseAfterStage     -> restore() (after after_test(), on every attempt)
##   GdUnitTestSuiteExecutionStage  -> restore() (after after())
## [/codeblock]

var _snapshot: Dictionary = {}


func save() -> void:
	_snapshot.clear()
	for property: Dictionary in ProjectSettings.get_property_list():
		var name: String = property["name"]
		if ProjectSettings.has_setting(name):
			var value: Variant = ProjectSettings.get_setting(name)
			@warning_ignore("unsafe_method_access")
			_snapshot[name] = value.duplicate(true) if (value is Dictionary or value is Array) else value


## Restores the saved values and keeps them, so the same state can be restored again.[br]
## A [Dictionary] or [Array] is set back as a deep copy, so a test editing the setting in place
## leaves the saved values unchanged.
func restore() -> void:
	for name: String in _snapshot:
		if not ProjectSettings.has_setting(name):
			continue
		var current: Variant = ProjectSettings.get_setting(name)
		var original: Variant = _snapshot[name]
		if current != original:
			@warning_ignore("unsafe_method_access")
			ProjectSettings.set_setting(name, original.duplicate(true) if (original is Dictionary or original is Array) else original)
