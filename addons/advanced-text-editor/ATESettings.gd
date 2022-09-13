# ATESettings
extends Node

var settings := {
	"preview_enabled": "addons/advanced_text_editor/preview_enabled",
	"default_markup": "addons/advanced_text/markup",
	"preview_width": "addons/advanced_text_editor/preview_width",
	"preview_height": "addons/advanced_text_editor/preview_height",
	"file_panel_width": "addons/advanced_text_editor/file_panel_width",
}

func has(property:String) -> bool:
	if property in settings:
		return ProjectSettings.has_setting(settings[property])

	return false

func _set(property:String, value) -> bool:
	if property in settings:
		ProjectSettings.set_setting(settings[property], value)
		return true

	return false

func _get_property_list():
	return settings.keys()

func _get(property : String):
	if property in settings:
		return ProjectSettings.get_setting(settings[property])
	
	return null

