extends CenterContainer

onready var file_name := $HBoxContainer/FileName
onready var file_icon := $HBoxContainer/FileIcon
onready var modified_icon := $HBoxContainer/ModifiedIcon

func _ready():
	TextEditorHelper.connect("selected_mode", self, "_on_selected_mode")

func _on_selected_mode(mode:String):
	match mode:
		"file":
			file_name.text = "Select File"
		
		"node":
			file_name.text = "Select Node"
