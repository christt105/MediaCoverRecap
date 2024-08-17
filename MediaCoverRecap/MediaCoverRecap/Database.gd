class_name Database
extends Control

class Data:
	var year:int

signal load(data:Data)

@export var property_name:LineEdit
@export var property_type:LineEdit
@export var property_completed:LineEdit
@export var property_cover:LineEdit
@export var property_properties:LineEdit

@export var type_film:LineEdit
@export var type_serie:LineEdit
@export var type_videogame:LineEdit

@export var year:LineEdit

@export var load_button:Button


func _ready() -> void:
	load_button.pressed.connect(_on_load_button_pressed)
	
	property_name.text = NotionDatabaseKeys.property_name
	property_type.text = NotionDatabaseKeys.property_type
	property_completed.text = NotionDatabaseKeys.property_completed
	property_cover.text = NotionDatabaseKeys.property_cover
	property_properties.text = NotionDatabaseKeys.property_properties
	
	type_film.text = NotionDatabaseKeys.type_film
	type_serie.text = NotionDatabaseKeys.type_serie
	type_videogame.text = NotionDatabaseKeys.type_videogame
	
	year.text = str(Time.get_date_dict_from_system()["year"])
	


func _on_load_button_pressed() -> void:
	var data := Data.new()
	
	data.year = year.text.to_int()
	
	load.emit(data)
