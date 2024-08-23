class_name NotionController
extends Node

var _token: String = ""




func _init(token: String) -> void:
	_token = token


func get_headers() -> PackedStringArray:
	return ["Notion-Version: 2022-06-28", "Authorization: Bearer " + _token, "Content-Type: application/json"]


func _get_url_database(database:String) -> String:
	if OS.has_feature("editor") or !OS.has_feature("web"):
		return "https://api.notion.com/v1/databases/" + database
	
	# Web builds cannot access APIs because the CORS policy
	# I have created a redirect in a free platform
	return "https://christt105.npkn.net/get-notion-database/" + database + "/" + _token
	

func _get_url_query(database:String) -> String:
	if OS.has_feature("editor") or !OS.has_feature("web"):
		return "https://api.notion.com/v1/databases/" + database + "/query"
	
	# Same as _get_url_query
	return "https://christt105.npkn.net/notion-query-database/" + database + "/" + _token
	

func get_media(database: String, notion_body: String, on_completed: Callable) -> void:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_get_database_completed.bind(on_completed))
	
	var error := http_request.request(
		_get_url_query(database),
		get_headers(),
		HTTPClient.METHOD_POST,
		notion_body)
	
	if error != OK:
		push_error(error_string(error))


func get_database(database_id: String) -> NotionDatabase:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	
	var error := http_request.request(
		_get_url_database(database_id),
		get_headers())
	
	if error != OK:
		push_error(error_string(error))
	
	var request_response = await http_request.request_completed
	var result = request_response[1]
	
	if result != HTTPClient.RESPONSE_OK:
		request_response = JSON.parse_string(request_response[3].get_string_from_utf8())
		push_error(request_response.message)
		return null
	
	var dict:Dictionary = JSON.parse_string(request_response[3].get_string_from_utf8())
	var database := NotionDatabase.new()
	database.id = dict["id"]
	database.properties = dict["properties"]
	
	return database

func _on_get_database_completed(result, response_code, headers, body, on_completed: Callable) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	var data:Array[Media] = []
	
	for media in response["results"]:
		data.append(
			Media.new(
			get_property_by_id(media, NotionDatabaseKeys.property_name)["title"][0]["plain_text"],
			get_file_url(get_property_by_id(media, NotionDatabaseKeys.property_cover)["files"][0]),
			get_property_by_id(media, NotionDatabaseKeys.property_completed)["date"]["start"],
			get_property_by_id(media, NotionDatabaseKeys.property_type)["select"]["name"],
			get_properties(get_property_by_id(media, NotionDatabaseKeys.property_properties)["multi_select"])
			))
	
	on_completed.call(data)


func get_property_by_id(media:Dictionary, id:String) -> Dictionary:
	for property in media["properties"]:
		if media["properties"][property]["id"] == id:
			return media["properties"][property]
	
	return {}


func get_file_url(file: Dictionary) -> String:
	if file["type"] == "external":
		return file["external"]["url"]
	else:
		return file["file"]["url"]


func get_properties(properties: Array) -> Array[String]:
	var props:Array[String] = []
	
	for property in properties:
		props.append(property["name"])
	
	return props
