class_name Database
extends Control

class Data:
	var from:Dictionary
	var to:Dictionary

signal load(data:Data)

@export var from_date:LineEdit
@export var to_date:LineEdit

@export var load_button:Button


func _ready() -> void:
	load_button.pressed.connect(_on_load_button_pressed)
	
	var year:int = Time.get_date_dict_from_system().year
	from_date.text = "%04d/%02d/%02d" % [year, 1, 1]
	to_date.text = "%04d/%02d/%02d" % [year, 12, 31]
	

func _on_load_button_pressed() -> void:
	var data := Data.new()
	
	data.from = _get_date_dict_from_string(from_date.text)
	data.to = _get_date_dict_from_string(to_date.text)
	
	load.emit(data)


func _get_date_dict_from_string(date:String) -> Dictionary:
	var date_dict := {}
	var date_components := date.split("/")
	
	date_dict["year"] = date_components[0].to_int()
	date_dict["month"] = date_components[1].to_int()
	date_dict["day"] = date_components[2].to_int()
	
	return date_dict
