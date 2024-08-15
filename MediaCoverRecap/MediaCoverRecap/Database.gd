class_name Database
extends Control

class Data:
	var film:bool
	var serie:bool
	var videogame:bool
	var year:int

signal load(data:Data)


@export var film:CheckBox
@export var serie:CheckBox
@export var videogame:CheckBox

@export var year:LineEdit

@export var load_button:Button


func _ready() -> void:
	load_button.pressed.connect(_on_load_button_pressed)
	
	year.text = str(Time.get_date_dict_from_system()["year"])
	


func _on_load_button_pressed() -> void:
	var data := Data.new()
	
	data.film = film.button_pressed
	data.serie = serie.button_pressed
	data.videogame = videogame.button_pressed
	data.year = year.text.to_int()
	
	load.emit(data)
