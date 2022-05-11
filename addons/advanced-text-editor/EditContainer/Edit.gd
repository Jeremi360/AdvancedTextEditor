tool
extends CodeEdit

export var configs_dict := {
	"markdown": "res://addons/advanced-text/highlights/bbcode.json",
	"bbcode": "res://addons/advanced-text/highlights/bbcode.json",
	"renpy": "res://addons/advanced-text/highlights/renpy.json",
}

func _ready():
	TextEditorHelper.connect("selected_markup", self, "_on_markup_selected")
	TextEditorHelper.connect("selected_file", self, "_on_file_selected")
	connect("text_changed", self, "_on_text_changed")

func _on_markup_selected(markup:String):
	if markup == "none":
		clear_colors()
		return
		
	clear_colors()
	configs = [configs_dict[markup]]
	_add_keywords_highlighting()

func _on_file_selected(f_data: Dictionary):
	text = f_data["text"]

func _on_text_changed():
	TextEditorHelper.update_data("text", text)
	TextEditorHelper.update_data("modified", true)
	


