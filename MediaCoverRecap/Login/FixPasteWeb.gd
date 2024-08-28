extends Node

# Web Exports have problems with Paste from Clipboard
# This is a workaround from https://github.com/godotengine/godot/issues/83752
# Other related issues https://github.com/godotengine/godot/issues/81252 and https://github.com/Praytic/youtd2/issues/418

func _ready() -> void:
	JavaScriptBridge.eval('
window.getclip = async function () {
  try {
	const permission = await navigator.permissions.query({
	  name: "clipboard-read",
	});
	if (permission.state === "denied") {
	  throw new Error("Not allowed to read clipboard.");
	}
	const clipboardContent = await navigator.clipboard.readText();
	window.imgtext = clipboardContent;
  } catch (error) {
	console.error(error.message);
	window.imgtext = "";
  }
};
')


func get_clipboard():
	JavaScriptBridge.eval('getclip()')
	var imgtext = JavaScriptBridge.eval("window.imgtext")
	print(imgtext)


func _process(delta):
	if Input.is_action_just_pressed("ui_paste"):
		get_clipboard()
