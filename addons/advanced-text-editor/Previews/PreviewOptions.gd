tool
extends HBoxContainer

onready var preview_toggle = $PreviewToggle
onready var preview_switch = $PreviewSwitch

var preview_types := {
	"right": 0,
	"bottom": 1
}

func _ready():
	preview_toggle.connect("toggled", self, "_on_preview_toggled")
	preview_toggle.icon = get_icon("RichTextEffect", "EditorIcons")

	preview_switch.connect("item_selected", self, "_on_preview_changed")
	preview_switch.set_item_icon(0, get_icon("ControlAlignRightWide", "EditorIcons"))
	preview_switch.set_item_icon(1, get_icon("ControlAlignBottomWide", "EditorIcons"))
	
	var preview_setting = ATESettings.preview_enabled
	_on_preview_toggled(preview_setting != "none")
	if preview_setting != "none":
		preview_switch.selected = preview_types[preview_setting]

func _on_preview_toggled(toggle:bool):
	TextEditorHelper.emit_signal("preview_toggled", toggle)	
	preview_switch.disabled = !toggle
	ATESettings.preview_enabled = preview_switch.selected if toggle else "none"

func _on_preview_changed(mode):
	var txt_mode = preview_switch.get_item_text(mode).to_lower()
	TextEditorHelper.emit_signal("selected_preview", txt_mode)
	ATESettings.preview_enabled = txt_mode
	





