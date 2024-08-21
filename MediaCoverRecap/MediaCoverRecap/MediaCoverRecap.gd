class_name MediaCoverRecap
extends Control


@export var collage_display:TextureRect
@export var collage:Collage
@export var database_configuration:Database
@export var save_covers_button:Button


var _notion:NotionController
var _database:Dictionary # TODO: Convert to class


func _ready() -> void:
	if get_parent() == get_tree().root and _notion == null:
		print("Running the scene individually")
		var notion := NotionController.new(NotionSecretGetter.GetNotionSecret())
		add_child(notion)
		
		var response := await notion.get_database(LoginScreen.DEFAULT_DATABASE_ID)
		if response.status != HTTPClient.RESPONSE_OK:
			push_error(response.message)
			return
		print("Database loaded correctly")
		init(notion, response["body"])
	
	database_configuration.load.connect(_load_images)
	save_covers_button.pressed.connect(_save_images)


func init(notion:NotionController, database:Dictionary) -> void:
	_notion = notion
	_database = database


func _load_images(data:Database.Data) -> void:
	_notion.get_media(_database["id"], NotionBody.create_body(
		{
			"and": [
			NotionFilters.completed_on_year(data.year)
			]
		}, NotionSorts.get_sort(NotionDatabaseKeys.property_completed, NotionSorts.SortDirection.ASCENDING)
		), _on_get_media)


func _on_get_media(media:Array[Media]) -> void:
	collage.clear()
	
	for m in media:
		var request = HTTPRequest.new()
		add_child(request)
		request.request_completed.connect(_on_cover_download_request_completed.bind(m))
		print("Downloading image from " + m.cover_url)
		request.request(m.cover_url)
	
	collage.create_collage(media)


func _on_cover_download_request_completed(result, response_code, headers:Array, body, media:Media) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	
	var error := OK
	match _get_image_type(headers):
		"jpg", "jpeg":
			error = image.load_jpg_from_buffer(body)
		"png":
			error = image.load_png_from_buffer(body)
	
	if error != OK:
		push_error("Couldn't load the image. " + error_string(error))
		return
	
	if image.is_empty():
		push_error("Image from " + media.cover_url + " is empty.")
		return;
	
	# image.save_png("res://Tests/Images/" + media.name + ".png")
	var texture = ImageTexture.create_from_image(image)
	
	media.cover = texture


func _get_image_type(headers:Array) -> String:
	for header in headers:
		if header.begins_with("Content-Type:"):
			return header.substr("Content-Type: image/".length())
	
	return ""


func _save_images() -> void:
	var time := Time.get_datetime_dict_from_system()
	var dir_path := "res://Tests/Results/"
	var path:String = dir_path + "%02d%02d%02d_%02d%02d%02d.png" % [time["year"], time["month"], time["day"], time["hour"], time["minute"], time["second"]]
	DirAccess.make_dir_absolute(dir_path)
	collage.get_texture().get_image().save_png(path)
	print("CoverRecap saved in " + path)
