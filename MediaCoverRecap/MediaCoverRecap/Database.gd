class_name Database
extends Control

class Data:
	var year:int

signal load(data:Data)

@export var year:LineEdit

@export var load_button:Button


func _ready() -> void:
	load_button.pressed.connect(_on_load_button_pressed)
	
	year.text = str(Time.get_date_dict_from_system()["year"])
	


func _on_load_button_pressed() -> void:
	var data := Data.new()
	
	data.year = year.text.to_int()
	
	load.emit(data)
