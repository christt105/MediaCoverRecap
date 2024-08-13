class_name NotionBody


static func create_body(filter:Dictionary = {}, sorts:Array[Dictionary] = []) -> String:
	var data := {}
	if !filter.is_empty():
		data["filter"] = filter
	
	if !sorts.is_empty():
		data["sorts"] = sorts
	
	return JSON.stringify(data)

