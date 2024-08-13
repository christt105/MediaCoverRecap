class_name NotionSecretGetter
extends Node

static func GetNotionSecret() -> String:
	if FileAccess.file_exists("res://config.secret"):
		var file = FileAccess.open("res://config.secret", FileAccess.READ)
		var token = file.get_as_text()
		file.close()
		return token
	else:
		print("Notion Secret file not found.")
		return ""
