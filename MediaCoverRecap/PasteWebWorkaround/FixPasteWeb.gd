extends Node

# Web Exports have problems with Paste from Clipboard
# This is a workaround from https://github.com/godotengine/godot/issues/83752
# Other related issues https://github.com/godotengine/godot/issues/81252 and https://github.com/Praytic/youtd2/issues/418

@export var secret_webfix_button: Button
@export var secret_line_edit: LineEdit

@export var id_webfix_button: Button
@export var id_line_edit: LineEdit


var text_modal_js_path: String = "res://PasteWebWorkaround/text_modal.js"
var text_modal_js: String = read_text_from(text_modal_js_path)


func _ready() -> void:
	secret_webfix_button.pressed.connect(on_pressed_secret)
	id_webfix_button.pressed.connect(on_pressed_id)


func on_pressed_secret() -> void:
	var eval_return: String = await _await_native_js_popup_command(
		"Paste your secret id here",
		"Set Secret Id",
		"",
		"Accept"
)
	if eval_return != null:
		secret_line_edit.text = eval_return

func on_pressed_id() -> void:
	var eval_return: String = await _await_native_js_popup_command(
		"Paste your database id here",
		"Set Database Id",
		"",
		"Accept"
)
	if eval_return != null:
		id_line_edit.text = eval_return


func _await_native_js_popup_command(
input: String, atitle: String, subtitle: String, button: String
) -> String:
	var command: String = _get_native_js_popup_command(input, atitle, subtitle, button)
	var eval_return: Variant = JavaScriptBridge.eval(command)
	while true:
		eval_return = JavaScriptBridge.eval("window.globalTextAreaResult")
		if eval_return != null:
			break
		await get_tree().create_timer(0.1).timeout
	JavaScriptBridge.eval("window.globalTextAreaResult = null;")
	return eval_return


func _get_native_js_popup_command(
	input: String, atitle: String, subtitle: String, button: String
) -> String:
	return text_modal_js.format(
		{"input": input, "atitle": atitle, "subtitle": subtitle, "button": button}
	)


static func read_text_from(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	var content: String = file.get_as_text()
	file.close()
	return content
