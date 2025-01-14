tool
extends VBoxContainer

export var file_box_scene : PackedScene
onready var confirmation_dialog := $Node/ConfirmationDialog

var b_group := ButtonGroup.new()
var f := File.new()
var open_files := {}

func _ready():
	# maybe it should be called in other way as session_loaded can be called before ui is ready
	TextEditorHelper.connect("session_loaded", self, "_on_session_loaded")
	confirmation_dialog.connect("confirmed", self, "_on_confirmed")

func _on_session_loaded():
	for file in TextEditorHelper.files_ram:
		pass

func new_file_tab(file_path : String, select := false, new_file := false):
	print_debug("open file ", file_path)
	var file_name = file_path.get_file()
	var file_ext = file_path.get_extension()

	if file_path in open_files.keys():
		print_debug("file already open")
		return
	
	var f_box = file_box_scene.instance()
	f_box.name = file_name

	var f_button : Button = f_box.get_node("FileButton")
	f_button.text = file_name
	add_child(f_box)
	f_button.group = b_group
	f_button.pressed = true

	var f_close_button : Button = f_box.get_node("CloseButton")
	f_close_button.text = ""
	f_close_button.icon = get_icon("Close", "EditorIcons")
	
	var f_modified_icon : TextureRect = f_box.get_node("ModifiedIcon")
	f_modified_icon.texture = get_icon("Edit", "EditorIcons")
	f_modified_icon.visible = true if new_file else false
	
	var text := ""
	if file_path != "":
		if f.file_exists(file_path):
			f.open(file_path, File.READ)
			text = f.get_as_text()
			f.close()
		
	var f_data := {
		"f_button": f_button,
		"file_name": file_name,
		"file_ext": file_ext,
		"path": file_path,
		"text": text,
		"modified": true if new_file else false,
		"modified_icon": f_modified_icon,
	}
	
	f_close_button.connect("pressed", self, "_on_file_close_button_pressed", [f_box])
	f_button.connect("pressed", TextEditorHelper, "select_file", [f_data])

	open_files[file_path] = f_box
	TextEditorHelper.files_ram[f_box] = f_data
	if select:
		TextEditorHelper.select_file(f_data)

func _on_file_close_button_pressed(f_box):
	if TextEditorHelper.files_ram[f_box]["modified"]:
		confirmation_dialog.popup_centered(Vector2(390, 75))
		return
		
	_on_confirmed(f_box)

func _on_confirmed(f_box):
	f_box.queue_free()
	TextEditorHelper.files_ram.erase(f_box)
	open_files.erase(f_box["path"])
	TextEditorHelper.edit_container.text = ""

