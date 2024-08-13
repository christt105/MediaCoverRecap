class_name NotionController
extends Node

var _token:String = ""

func _init(token:String) -> void:
	_token = token


func get_headers() -> PackedStringArray:
	return ["Notion-Version: 2022-06-28", "Authorization: Bearer " + _token, "Content-Type: application/json"]


func get_media(database:String, notion_body:String, on_completed) -> void:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(on_get_database_completed)
	
	var error := http_request.request(
		"https://api.notion.com/v1/databases/" + database + "/query", 
		get_headers(), 
		HTTPClient.METHOD_POST, 
		notion_body)
	
	if error != OK:
		push_error(error_string(error))

func on_get_database_completed(result, response_code, headers, body) -> void:
	var data = JSON.parse_string(body.get_string_from_utf8())
	
	for media in data["results"]:
		print(JSON.stringify(media["properties"]["Nombre"]["title"][0]["plain_text"]))
	
