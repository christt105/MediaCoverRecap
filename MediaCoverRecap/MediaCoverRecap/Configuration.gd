class_name Configuration
extends Control

@export var collage:Collage

@export var filters_container:GridContainer
@export var columns:SpinBox
@export var h_separation:SpinBox
@export var v_separation:SpinBox
@export var sort:OptionButton
@export var image_size_info:Label

enum Order {OLDER, NEWER}

func _ready() -> void:
	collage.resized.connect(_on_collage_resized)
	columns.value_changed.connect(_on_columns_changed)
	sort.item_selected.connect(_on_sort_changed)
	h_separation.value_changed.connect(_on_horizontal_separation_changed)
	v_separation.value_changed.connect(_on_vertical_separation_changed)


func set_media_types(media_types:Array[MediaType]) -> void:
	for child in filters_container.get_children():
		child.queue_free()
	
	for media_type in media_types:
		var checkbox := CheckBox.new()
		checkbox.button_pressed = true
		filters_container.add_child(checkbox)
		checkbox.text = media_type.name
		checkbox.toggled.connect(_on_filter_type_toggled.bind(media_type.id))


func _on_collage_resized(size:Vector2i) -> void:
	image_size_info.text = "Image size: %dpx x %dpx" % [size.x, size.y]


func _on_horizontal_separation_changed(value:float) -> void:
	collage.h_separation = int(value)


func _on_vertical_separation_changed(value:float) -> void:
	collage.v_separation = int(value)


func _on_columns_changed(value:float) -> void:
	collage.columns = int(value)


func _on_sort_changed(index:int) -> void:
	collage.sort(index)


func _on_filter_type_toggled(toggled_on:bool, key:String) -> void:
	collage.set_media_type_filter(key, toggled_on)
