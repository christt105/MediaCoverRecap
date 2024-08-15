class_name Configuration
extends Control


@export var collage:Collage

@export var columns:SpinBox
@export var sort:OptionButton
@export var image_size_info:Label

enum Order {OLDER, NEWER}


func _ready() -> void:
	collage.resized.connect(_on_collage_resized)
	columns.value_changed.connect(_on_columns_changed)
	sort.item_selected.connect(_on_sort_changed)


func _on_collage_resized(size:Vector2i) -> void:
	image_size_info.text = "Image size: %dpx x %dpx" % [size.x, size.y]


func _on_columns_changed(value:float) -> void:
	collage.columns = int(value)


func _on_sort_changed(index:int) -> void:
	collage.sort(index)
