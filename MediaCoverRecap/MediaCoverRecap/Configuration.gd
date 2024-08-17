class_name Configuration
extends Control


@export var collage:Collage

@export var film:CheckBox
@export var serie:CheckBox
@export var videogame:CheckBox

@export var columns:SpinBox
@export var sort:OptionButton
@export var image_size_info:Label

enum Order {OLDER, NEWER}


func _ready() -> void:
	collage.resized.connect(_on_collage_resized)
	columns.value_changed.connect(_on_columns_changed)
	sort.item_selected.connect(_on_sort_changed)
	
	film.toggled.connect(_on_film_toggled)
	serie.toggled.connect(_on_serie_toggled)
	videogame.toggled.connect(_on_videogame_toggled)


func _on_collage_resized(size:Vector2i) -> void:
	image_size_info.text = "Image size: %dpx x %dpx" % [size.x, size.y]


func _on_columns_changed(value:float) -> void:
	collage.columns = int(value)


func _on_sort_changed(index:int) -> void:
	collage.sort(index)


func _on_film_toggled(toggled_on:bool) -> void:
	pass


func _on_serie_toggled(toggled_on:bool) -> void:
	pass


func _on_videogame_toggled(toggled_on:bool) -> void:
	pass
