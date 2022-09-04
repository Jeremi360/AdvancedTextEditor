tool
extends HBoxContainer

onready var files_toggle = $FileMode
onready var node_toggle = $NodeMode

func _ready():
	node_toggle.connect("pressed", self, "_on_node_mode_toggled")
	node_toggle.icon = get_icon("Control", "EditorIcons")

	files_toggle.pressed = true
	files_toggle.connect("pressed", self, "_on_file_mode_toggled")
	files_toggle.icon = get_icon("File", "EditorIcons")

func _on_node_mode_toggled():
	TextEditorHelper.mode = "node"
	TextEditorHelper.emit_signal("selected_mode", "node")

func _on_file_mode_toggled():
	TextEditorHelper.mode = "file"
	TextEditorHelper.emit_signal("selected_mode", "file")