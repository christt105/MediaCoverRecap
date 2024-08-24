class_name LoginScreen
extends Control

const DEFAULT_DATABASE_ID = "d2e54cb577014d5a920cc8ce3aebe651"

const RECAP_SCENE:PackedScene = preload("res://MediaCoverRecap/MediaCoverRecap.tscn")


@export var notion_api_secret_line_edit:LineEdit
@export var notion_media_database_id_line_edit:LineEdit
@export var error_label:Label
@export var login_button:Button


func _ready() -> void:
	login_button.pressed.connect(on_login_button_pressed)
	
	if OS.has_feature("editor"):
		notion_api_secret_line_edit.text = NotionSecretGetter.GetNotionSecret()
		notion_media_database_id_line_edit.text = DEFAULT_DATABASE_ID
	else:
		load_from_user()


func load_from_user() -> void:
	if not FileAccess.file_exists("user://login.save"):
		return
	
	var file := FileAccess.open("user://login.save", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	notion_api_secret_line_edit.text = data["token"]
	notion_media_database_id_line_edit.text = data["database"]


func save_user() -> void:
	var notion_secret := notion_api_secret_line_edit.text
	var database := notion_media_database_id_line_edit.text
	
	var file := FileAccess.open("user://login.save", FileAccess.WRITE)
	file.store_line(JSON.stringify({"token": notion_secret, "database": database}))


func on_login_button_pressed() -> void:
	if notion_api_secret_line_edit.text.is_empty():
		write_error("Notion api secret cannot be empty")
		return
	
	var database_id := notion_media_database_id_line_edit.text
	
	if database_id.is_empty():
		write_error("Notion database id field cannot be empty")
		return
	
	var notion := NotionController.new(notion_api_secret_line_edit.text)
	get_tree().root.add_child(notion)
	
	var database := await notion.get_database(database_id)
	if database == null:
		return
	
	print("Database loaded correctly")
	
	save_user()
	
	login_done(notion, database)
	


func write_error(text:String) -> void:
	error_label.text = text


func login_done(notion:NotionController, notion_database:NotionDatabase) -> void:
	var recap_scene := RECAP_SCENE.instantiate() as MediaCoverRecap
	recap_scene.init(notion, notion_database)
	
	get_tree().root.add_child(recap_scene)
	
	self.queue_free()
	
