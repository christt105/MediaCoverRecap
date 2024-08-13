class_name NotionSorts

enum SortDirection {ASCENDING, DESCENDING}


static func get_sort(what:String, direction:SortDirection) -> Array[Dictionary]:
	return [{"property": what, "direction": _sort_direction_to_string(direction)}]


static func _sort_direction_to_string(direction:SortDirection) -> String:
	match direction:
		SortDirection.ASCENDING:
			return "ascending"
		SortDirection.DESCENDING:
			return "descending"
	
	return ""
