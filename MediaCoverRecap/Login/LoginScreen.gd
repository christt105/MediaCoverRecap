class_name LoginScreen
extends Control

const DEFAULT_DATABASE_ID = "d2e54cb577014d5a920cc8ce3aebe651"


signal login_done(notion_clinet:NotionController)


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
	
	if notion_media_database_id_line_edit.text.is_empty():
		write_error("Notion database id field cannot be empty")
		return
	
	var notion := NotionController.new(notion_api_secret_line_edit.text)
	add_child(notion)
	
	var response := await notion.check_database(notion_media_database_id_line_edit.text)
	if response.status != HTTPClient.RESPONSE_OK:
		write_error(response.message)
		return
	
	print("success")
	login_done.emit(notion, notion_media_database_id_line_edit.text)
	

func write_error(text:String) -> void:
	error_label.text = text
