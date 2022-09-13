tool
extends EditorPlugin

var markup_text_editor_button : ToolButton
var markup_text_editor
var editor_parent : Control
var button_parent : Control
var last_editor : Control

func _enter_tree():
	if !ProjectSettings.has_setting("addons/advanced_text_editor/preview_enabled"):
		ProjectSettings.set_setting("addons/advanced_text_editor/preview_enabled", "right")


	ProjectSettings.add_property_info({
		"name": "addons/advanced_text_editor/preview_enabled", 
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "right,bottom,none"
	})

	if !ProjectSettings.has_setting("addons/advanced_text_editor/preview_width"):
		ProjectSettings.set_setting("addons/advanced_text_editor/preview_width", 100.0)

	ProjectSettings.add_property_info({
		"name": "addons/advanced_text_editor/preview_width", 
		"type": TYPE_REAL,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "100,600"
	})
	
	if !ProjectSettings.has_setting("addons/advanced_text_editor/preview_height"):
		ProjectSettings.set_setting("addons/advanced_text_editor/preview_height", 100.0)

	ProjectSettings.add_property_info({
		"name": "addons/advanced_text_editor/preview_height", 
		"type": TYPE_REAL,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "100,600"
	})

	if !ProjectSettings.has_setting("addons/advanced_text_editor/files_panel_width"):
		ProjectSettings.set_setting("addons/advanced_text_editor/files_panel_width", 100.0)

	ProjectSettings.add_property_info({
		"name": "addons/advanced_text_editor/files_panel_width", 
		"type": TYPE_REAL,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "100,600"
	})

	load_and_enable_markup_edit()

func load_and_enable_markup_edit():
	# load ram / last file session
	add_autoload_singleton("TextEditorHelper", "res://addons/advanced-text-editor/TextEditorHelper.gd")
	add_autoload_singleton("ATESettings", "res://addons/advanced-text-editor/ATESettings.gd")

	# load and add MarkupTextEditor to EditorUI
	markup_text_editor = preload("Main.tscn")
	markup_text_editor = markup_text_editor.instance()
	editor_parent = get_editor_interface().get_editor_viewport()
	markup_text_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	markup_text_editor.size_flags_vertical = Control.SIZE_EXPAND_FILL
	markup_text_editor.visible = false
	markup_text_editor.editor = get_editor_interface()
	editor_parent.add_child(markup_text_editor)
	
	# add button for MarkupTextEditor to toolbar
	markup_text_editor_button = ToolButton.new()
	markup_text_editor_button.text = "Adavnced Text Editor"
	markup_text_editor_button.icon = preload("icons/MarkupTextEditor.svg")
	markup_text_editor_button.toggle_mode = true
	markup_text_editor_button.pressed = false
	markup_text_editor_button.action_mode = ToolButton.ACTION_MODE_BUTTON_RELEASE

	# hack to add the button to the editor modes tabs
	add_control_to_container(CONTAINER_TOOLBAR, markup_text_editor_button)
	button_parent = markup_text_editor_button.get_parent()
	button_parent.remove_child(markup_text_editor_button)
	button_parent = button_parent.get_child(2)
	button_parent.add_child(markup_text_editor_button)

	for b in button_parent.get_children():
		var args := [false, b]
		if b == markup_text_editor_button:
			args[0] = true
		
		b.connect("pressed", self, "_on_toggle", args)
	
	connect("scene_changed", self, "_on_scene_changed")

func unload_and_disable_markup_edit():
	if last_editor:
		last_editor.show()

	# remove MarkupTextEditor from EditorUI
	if markup_text_editor != null:
		if is_connected("scene_changed", self, "_on_scene_changed"):
			disconnect("scene_changed", self, "_on_scene_changed")

		markup_text_editor.queue_free()
		remove_autoload_singleton("FilesRam") 

	# remove button from toolbar
	if markup_text_editor_button != null:
		for b in button_parent.get_children():
			var args := [false, b]
			if b == markup_text_editor_button:
				args[0] = true
			
			b.disconnect("pressed", self, "_on_toggle")
			
		markup_text_editor_button.queue_free()

func _exit_tree():
	ProjectSettings.set_setting("addons/advanced_text_editor/preview_enabled", null)
	unload_and_disable_markup_edit()

func hide_current_editor():
	for editor in editor_parent.get_children():
		if editor.has_method("show"):
			if editor.visible:
				editor.visible = false
				break

	for b in button_parent.get_children():
		if b.pressed:
			b.pressed = false
			return

func _on_scene_changed(scene_root: Node):
	for b in button_parent.get_children():
		if b.pressed:
			_on_show_editor(b)
		
	markup_text_editor_button.pressed = false
	markup_text_editor.visible = false

func _on_show_editor(button: ToolButton):
	for editor in editor_parent.get_children():
		if editor is Control:
			match button.text:
				"2D":
					if editor.get_class() == "CanvasItemEditor":
						last_editor = editor
						editor.show()

				"3D":
					if editor.get_class() == "SpatialEditor":
						last_editor = editor
						editor.show()

				"Script":
					if editor.get_class() == "ScriptEditor":
						last_editor = editor
						editor.show()

				"AssetLib":
					if editor.get_class() == "AssetLibraryEditor":
						last_editor = editor
						editor.show()
				_:
					continue

func _on_toggle(toggled:bool, button:ToolButton):
	if toggled:
		hide_current_editor()
	
	else:
		button.pressed = true
		_on_show_editor(button)

	markup_text_editor_button.pressed = toggled
	markup_text_editor.visible = toggled