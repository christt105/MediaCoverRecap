class_name NotionController
extends Node

var _token: String = ""

func _init(token: String) -> void:
	_token = token


func get_headers() -> PackedStringArray:
	return ["Notion-Version: 2022-06-28", "Authorization: Bearer " + _token, "Content-Type: application/json"]


func get_media(database: String, notion_body: String, on_completed: Callable) -> void:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_get_database_completed.bind(on_completed))
	
	var error := http_request.request(
		"https://api.notion.com/v1/databases/" + database + "/query",
		get_headers(),
		HTTPClient.METHOD_POST,
		notion_body)
	
	if error != OK:
		push_error(error_string(error))


func check_database(database_id: String) -> Dictionary:
	var http_request := HTTPRequest.new()
	add_child(http_request)
	
	var error := http_request.request(
		"https://api.notion.com/v1/databases/" + database_id,
		get_headers())
	
	if error != OK:
		push_error(error_string(error))
	
	var request_response = await http_request.request_completed
	var result = {"status": request_response[1]}
	
	if result.status != HTTPClient.RESPONSE_OK:
		request_response = JSON.parse_string(request_response[3].get_string_from_utf8())
		result["message"] = request_response.message
	
	return result

func _on_get_database_completed(result, response_code, headers, body, on_completed: Callable) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	var data:Array[Media] = []
	
	for media in response["results"]:
		data.append(
			Media.new(
			media["properties"][NotionDatabaseKeys.property_name]["title"][0]["plain_text"],
			get_file_url(media["properties"][NotionDatabaseKeys.property_cover]["files"][0]),
			media["properties"][NotionDatabaseKeys.property_completed]["date"]["start"],
			media["properties"][NotionDatabaseKeys.property_type]["select"]["name"],
			get_properties(media["properties"][NotionDatabaseKeys.property_properties]["multi_select"])
			))
	
	on_completed.call(data)


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
