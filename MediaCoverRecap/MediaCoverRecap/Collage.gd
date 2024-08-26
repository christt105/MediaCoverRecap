class_name Collage
extends SubViewport

signal resized(new_size:Vector2i)

@export var grid_container:GridContainer

@export var columns:int:
	get:
		return grid_container.columns
	set(value):
		if grid_container != null:
			grid_container.columns = value
			reset_grid_container_size()


var media_type_filter:Dictionary = {}


func _ready() -> void:
	grid_container.resized.connect(copy_size)


func clear() -> void:
	for child in grid_container.get_children():
		child.queue_free()


func set_media_types(media_types:Array[MediaType]) -> void:
	media_type_filter = {}
	for media_type in media_types:
		media_type_filter[media_type.id] = true


func set_media_type_filter(key:String, toggled_on:bool) -> void:
	media_type_filter[key] = toggled_on
	refresh()


func create_collage(media:Array[Media]) -> void:
	for m in media:
		var texture_rect = TextureRect.new()
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		grid_container.add_child(texture_rect)
		m.cover_updated.connect(_cover_updated.bind(texture_rect))
		set_cover(texture_rect, m)
	
	reset_grid_container_size()


func sort(order:Configuration.Order) -> void:
	var media:Array[Media]
	for m in grid_container.get_children():
		media.push_back(m.get_meta("media"))
	
	media.sort_custom(sort_media_ascending if order == Configuration.Order.OLDER else sort_media_descending)
	
	for i in range(media.size()):
		var tr := grid_container.get_child(i) as TextureRect
		set_cover(tr, media[i])


func set_cover(texture_rect:TextureRect, media:Media) -> void:
	texture_rect.set_meta("media", media)
	texture_rect.name = media.name
	texture_rect.texture = media.cover
	texture_rect.visible = media_type_filter[media.type]


func refresh() -> void:
	for m in grid_container.get_children():
		var media := m.get_meta("media") as Media
		m.visible = media_type_filter[media.type]


func sort_media_ascending(a:Media, b:Media) -> bool:
	return a.completed < b.completed

func sort_media_descending(a:Media, b:Media) -> bool:
	return a.completed > b.completed


func _cover_updated(image:ImageTexture, texture_rect:TextureRect) -> void:
	texture_rect.texture = image
	reset_grid_container_size()


func reset_grid_container_size() -> void:
	grid_container.reset_size()


func copy_size() -> void:
	size = grid_container.size
	resized.emit(size)
