extends Control


@export var collage:Collage

@export var columns:SpinBox
@export var order:OptionButton
@export var image_size_info:Label


func _ready() -> void:
	collage.resized.connect(_on_collage_resized)
	columns.value_changed.connect(_on_columns_changed)


func _on_collage_resized(size:Vector2i) -> void:
	image_size_info.text = "Image size: %dpx x %dpx" % [size.x, size.y]


func _on_columns_changed(value:float) -> void:
	collage.columns = int(value)
