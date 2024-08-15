class_name Collage
extends SubViewport

@export var grid_container:GridContainer

@export var columns:int:
	get:
		return grid_container.columns
	set(value):
		if grid_container != null:
			grid_container.columns = columns
			update_size()


func clear() -> void:
	for child in grid_container.get_children():
		child.queue_free()


func create_collage(media:Array[Media]) -> void:
	for m in media:
		var texture_rect = TextureRect.new()
		texture_rect.name = m.name
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		grid_container.add_child(texture_rect)
		m.cover_updated.connect(_cover_updated.bind(texture_rect))


func _cover_updated(image:ImageTexture, texture_rect:TextureRect) -> void:
	texture_rect.texture = image
	update_size()


func update_size() -> void:
	size = grid_container.size
