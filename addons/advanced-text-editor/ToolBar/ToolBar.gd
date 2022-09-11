tool
extends Control

onready var preview_toggle := $HBoxContainer/PreviewOptions/PreviewToggle
onready var preview_switch := $HBoxContainer/HBoxContainer/PreviewOptions/PreviewSwitch

func _ready():
	preview_toggle.connect("toggled", self, "_on_preview_toggled")
	preview_toggle.icon = get_icon("RichTextEffect", "EditorIcons")

	preview_switch.connect("item_selected", self, "_on_preview_changed")
	preview_switch.set_item_icon(0, get_icon("ControlAlignRightWide", "EditorIcons"))
	preview_switch.set_item_icon(1, get_icon("ControlAlignBottomWide", "EditorIcons"))

func _on_preview_toggled(toggle:bool):
	emit_signal("preview_toggled", toggle)

func _on_preview_changed(mode):
	var txt_mode = preview_switch.get_item_text(mode)
	emit_signal("selected_preview", txt_mode)





