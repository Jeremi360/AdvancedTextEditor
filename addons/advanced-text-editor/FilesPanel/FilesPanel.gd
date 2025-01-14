tool
extends Control

onready var open_file_button := $GridContainer/OpenFileButton
onready var save_file_button := $GridContainer/SaveFileButton
onready var save_as_file_button := $GridContainer/SaveAsFileButton
onready var new_file_button := $GridContainer/NewFileButton
onready var file_dialog := $Node/FileDialog
onready var files_box := $ScrollContainer/Panel/FilesBox

export var file_dialog_size := Vector2(700, 500)

func _ready():
	open_file_button.connect("pressed", self, "_on_open_file")
	save_file_button.connect("pressed", self, "_on_save_file")
	save_as_file_button.connect("pressed", self, "_on_save_as_file")
	new_file_button.connect("pressed", self, "_on_new_file")
	file_dialog.connect("file_selected", self, "_on_file_selected")
	file_dialog.connect("files_selected", self, "_on_files_selected")
	TextEditorHelper.connect("selected_mode", self, "_on_selected_mode")
	connect("resized", self, "_on_resized")

	rect_size.x = ATESettings.file_panel_width


func _on_selected_mode(mode:String):
	visible = mode == "file"	

func _on_open_file():
	file_dialog.mode = FileDialog.MODE_OPEN_FILES
	file_dialog.popup_centered(file_dialog_size)

func _on_save_as_file():
	file_dialog.mode = FileDialog.MODE_SAVE_FILE
	file_dialog.popup_centered(file_dialog_size)

func _on_file_selected(file_path:String):
	match file_dialog.mode:
		FileDialog.MODE_SAVE_FILE:
			var d := TextEditorHelper.current_f_data
			if d == null:
				var f := File.new()
				f.open(file_path, File.WRITE)
				var text := TextEditorHelper.edit_container.text
				f.store_string(text)
				f.close()

			else:
				d["modified"] = false
				d["path"] = file_path
				var f := File.new()
				f.open(file_path, File.WRITE)
				f.store_string(d["text"])
				f.close()

func _on_files_selected(file_paths:PoolStringArray):
	match file_dialog.mode:
		FileDialog.MODE_OPEN_FILES:
			var i := 0 
			for file_path in file_paths:
				# automatic select last file
				var select := file_paths.size() - 1 == i
				files_box.new_file_tab(file_path, select)

func _on_new_file():
	var number : int = files_box.open_files.size()
	files_box.new_file_tab("New Text File " + str(number))

func _on_save_file():
	var d := TextEditorHelper.current_f_data
	d["modified"] = false
	var f := File.new()
	f.open(d["path"], File.WRITE)
	f.store_string(d["text"])
	f.close()

func _on_resized():
	ATESettings.file_panel_width = rect_size.x

