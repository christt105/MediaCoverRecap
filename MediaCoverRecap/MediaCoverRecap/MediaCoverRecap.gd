extends Control


@export var texture_rect:TextureRect
@export var load_images_button:Button


var _notion:NotionController
var _database_id:String


func _ready() -> void:
	if get_parent() == get_tree().root:
		print("Running the scene individually")
		var notion := NotionController.new(NotionSecretGetter.GetNotionSecret())
		add_child(notion)
		init(notion, LoginScreen.DEFAULT_DATABASE_ID)
	
	load_images_button.pressed.connect(_load_images)


func init(notion:NotionController, database_id:String) -> void:
	_notion = notion
	_database_id = database_id


func _load_images() -> void:
	_notion.get_media(_database_id, "", _on_get_media)


func _on_get_media(media:Array) -> void:
	for m in media:
		var request = HTTPRequest.new()
		add_child(request)
		request.request_completed.connect(_on_cover_download_request_completed)
		print(m.cover_url)
		request.request(m.cover_url)
		
		break


func _on_cover_download_request_completed(result, response_code, headers:Array, body) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)

	texture_rect.texture = texture

