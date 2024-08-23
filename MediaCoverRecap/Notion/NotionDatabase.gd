extends Resource

class_name NotionDatabase

@export var id: String
@export var properties: Dictionary

func get_property_by_id(id:String) -> Dictionary:
	for property in properties:
		if properties[property].id == id:
			return properties[property]
	
	return {}
