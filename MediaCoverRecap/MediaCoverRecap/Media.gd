class_name Media

signal cover_updated(cover:ImageTexture)

var name:String
var cover_url:String
var completed:String
var type:String
var properties:Array[String]

var cover:ImageTexture:
	get:
		return cover
	set(value):
		cover = value
		cover_updated.emit(cover)


func _init(name:String, cover_url:String, completed:String, type:String, properties:Array[String]) -> void:
	self.name = name
	self.cover_url = cover_url
	self.completed = completed
	self.type = type
	self.properties = properties
