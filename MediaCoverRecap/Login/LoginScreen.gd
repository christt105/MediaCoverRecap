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
	
	var response := await notion.get_database(database_id)
	if response.status != HTTPClient.RESPONSE_OK:
		write_error(response.message)
		return
	
	print("Database loaded correctly")
	login_done(notion, response["body"])
	


func write_error(text:String) -> void:
	error_label.text = text


func login_done(notion:NotionController, notion_database:Dictionary) -> void:
	var recap_scene := RECAP_SCENE.instantiate() as MediaCoverRecap
	recap_scene.init(notion, notion_database)
	
	get_tree().root.add_child(recap_scene)
	
	self.queue_free()
	
