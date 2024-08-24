class_name Media

signal cover_updated(cover:ImageTexture)

var name:String
var cover_url:Cover
var completed:String
var type:String
var properties:Array[String]

var cover:ImageTexture:
	get:
		return cover
	set(value):
		cover = value
		cover_updated.emit(cover)

class Cover:
	var is_external:bool
	var url:String
	
	func _init(is_external:bool, url:String) -> void:
		self.is_external = is_external
		self.url = url


func _init(name:String, cover_url:Cover, completed:String, type:String, properties:Array[String]) -> void:
	self.name = name
	self.cover_url = cover_url
	self.completed = completed
	self.type = type
	self.properties = properties
