class_name GdUnitProjectSettingsSnapshot
extends RefCounted
## Captures and restores all in-memory [ProjectSettings] values around a single
## stage of test execution.[br]
## Each [GdUnitExecutionContext] owns one instance. Suite-level and test-level
## isolation are achieved by the two separate contexts rather than by stacking:[br]
## [codeblock]
##   GdUnitTestSuiteExecutionStage  -> save()   (before before())
##     GdUnitTestCaseExecutionStage -> save()   (before before_test() of the first test)
##     GdUnitTestCaseExecutionStage -> restore() (after after_test())
##     GdUnitTestCaseExecutionStage -> take()   (before before_test() of the next test)
##   GdUnitTestSuiteExecutionStage  -> restore() (after after())
## [/codeblock]
## A test restores the settings it started from, so the next test of the suite takes
## those values instead of reading every setting again.

var _snapshot: Dictionary = {}


func save() -> void:
	_snapshot.clear()
	for property: Dictionary in ProjectSettings.get_property_list():
		var name: String = property["name"]
		if ProjectSettings.has_setting(name):
			var value: Variant = ProjectSettings.get_setting(name)
			@warning_ignore("unsafe_method_access")
			_snapshot[name] = value.duplicate() if (value is Dictionary or value is Array) else value


## Takes [param values], returned by [method restore] of another snapshot, as the saved values.
func take(values: Dictionary) -> void:
	_snapshot = values


## Restores the saved values and returns them, the values [ProjectSettings] holds afterwards.[br]
## A restored [Dictionary] or [Array] is set as a copy, so a test editing the setting in place
## leaves the returned values unchanged.
func restore() -> Dictionary:
	var restored := _snapshot
	_snapshot = {}
	for name: String in restored:
		if not ProjectSettings.has_setting(name):
			continue
		var current: Variant = ProjectSettings.get_setting(name)
		var original: Variant = restored[name]
		if current != original:
			@warning_ignore("unsafe_method_access")
			ProjectSettings.set_setting(name, original.duplicate() if (original is Dictionary or original is Array) else original)
	return restored
