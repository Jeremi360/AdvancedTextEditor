tool
extends AdvancedTextLabel

export (int, "right", "bottom") var preview_type := 0 

func _ready():
	._ready()
	TextEditorHelper.connect("preview_toggled", self, "_on_preview_toggled")
	TextEditorHelper.connect("selected_preview", self, "_on_preview_type_changed")
	TextEditorHelper.connect("selected_mode", self, "_on_mode_changed")
	connect("resized", self, "_on_resized")

	markup = ATESettings.default_markup
	visible = ATESettings.preview_enabled == preview_type
	
	match preview_type:
		0: # right
			rect_size.x = ATESettings.preview_width
		
		1: # bottom
			rect_size.y = ATESettings.preview_height
			

func update_preview():
	markup = TextEditorHelper.current_markup
	visible = ATESettings.preview_enabled == preview_type

func _on_preview_toggled( toggled: bool ):
	if toggled:
		update_preview()
	else:
		hide()

func _on_preview_type_changed( type: int ):
	if visible:
		update_preview()

func _on_mode_changed( mode: String ):
	if visible:
		markup = mode

func _on_resized():
	if visible:
		match preview_type:
			0: # right
				ATESettings.preview_width = rect_size.x
			
			1: # bottom
				ATESettings.preview_height = rect_size.y