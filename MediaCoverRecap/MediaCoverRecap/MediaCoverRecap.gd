class_name MediaCoverRecap
extends Control


@export var collage_display:TextureRect
@export var collage:Collage
@export var database_configuration:Database
@export var display_configuration:Configuration
@export var save_covers_button:Button
@export var display_text:Label


var _notion:NotionController
var _database:NotionDatabase

var downloaded_covers:int
var total_covers:int


func _ready() -> void:
	if get_parent() == get_tree().root and _notion == null:
		print("Running the scene individually")
		var notion := NotionController.new(NotionSecretGetter.GetNotionSecret())
		add_child(notion)
		
		var response := await notion.get_database(LoginScreen.DEFAULT_DATABASE_ID)
		if response == null:
			return
		print("Database loaded correctly")
		init(notion, response)
	
	display_text.text = ""
	downloaded_covers = 0
	total_covers = 0
	
	database_configuration.load.connect(_load_images)
	save_covers_button.pressed.connect(_save_images)


func init(notion:NotionController, database:NotionDatabase) -> void:
	_notion = notion
	_database = database
	set_types()


func set_types() -> void:
	var property_type := _database.get_property_by_id(NotionDatabaseKeys.property_type)
	
	var media_types:Array[MediaType] = []
	for option in property_type["select"]["options"]:
		var media_type := MediaType.new(option.id, option.name)
		media_types.push_back(media_type)
	
	collage.set_media_types(media_types)
	display_configuration.set_media_types(media_types)
	

func _load_images(data:Database.Data) -> void:
	_notion.get_media(_database["id"], NotionBody.create_body(
		{
			"and": [
			NotionFilters.from_to_date(data.from, data.to)
			]
		}, NotionSorts.get_sort(NotionDatabaseKeys.property_completed, NotionSorts.SortDirection.ASCENDING)
		), _on_get_media)


func _on_get_media(media:Array[Media]) -> void:
	collage.clear()
	
	_set_info_text("Downloading 0/%d covers..." % media.size())
	downloaded_covers = 0
	total_covers = media.size()
	
	for m in media:
		var request = HTTPRequest.new()
		add_child(request)
		request.request_completed.connect(_on_cover_download_request_completed.bind(m))
		print("Downloading image " + m.cover_url.url)
		var url := _get_cover_url(m.cover_url)
		request.request(url)
	
	collage.create_collage(media)


func _set_info_text(text:String) -> void:
	display_text.text = text


func _get_cover_url(cover:Media.Cover) -> String:
	if !OS.has_feature("editor") and OS.has_feature("web") and cover.is_external:
		return "https://mediacoverrecapserver.onrender.com/image?url=" + cover.url
	else:
		return cover.url


func _on_cover_download_request_completed(result, response_code, headers:Array, body, media:Media) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	
	var error := OK
	var image_type := _get_image_type(headers)
	match image_type:
		"jpg", "jpeg":
			error = image.load_jpg_from_buffer(body)
		"png":
			error = image.load_png_from_buffer(body)
		_:
			push_warning("No image type for " + image_type)
	
	if error != OK:
		push_error("Couldn't load the image. " + error_string(error))
		return
	
	if image.is_empty():
		push_error("Image from " + media.cover_url.url + " is empty.")
		return;
	
	# TODO: Image cache
	# image.save_png("res://Tests/Images/" + media.name + ".png")
	var texture = ImageTexture.create_from_image(image)
	media.cover = texture
	
	downloaded_covers += 1
	_set_info_text("Downloading %d/%d covers..." % [downloaded_covers, total_covers])


func _get_image_type(headers:Array) -> String:
	for header in headers:
		if header.to_lower().begins_with("content-type:"):
			var pos:int = header.to_lower().find("image/")
			return header.substr(pos + "image/".length()).to_lower()
	
	return ""


func _save_images() -> void:
	if OS.has_feature("web"):
		var buffer := collage.get_texture().get_image().save_png_to_buffer()
		JavaScriptBridge.download_buffer(buffer, "Cover.png")
	else:
		var time := Time.get_datetime_dict_from_system()
		var dir_path := "res://Tests/Results/"
		var path:String = dir_path + "%02d%02d%02d_%02d%02d%02d.png" % [time["year"], time["month"], time["day"], time["hour"], time["minute"], time["second"]]
		DirAccess.make_dir_absolute(dir_path)
		collage.get_texture().get_image().save_png(path)
		print("CoverRecap saved in " + path)
