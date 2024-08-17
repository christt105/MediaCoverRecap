extends Node

const DATABASE_ID := "d2e54cb577014d5a920cc8ce3aebe651"

func _ready() -> void:
	var notion_controller = NotionController.new(NotionSecretGetter.GetNotionSecret())
	add_child(notion_controller)
	
	notion_controller.get_media(DATABASE_ID, NotionBody.create_body(
			{"and": [NotionFilters.ONLY_VIDEOGAMES, NotionFilters.completed_on_year(2023)]},
			NotionSorts.get_sort(NotionDatabaseKeys.property_completed, NotionSorts.SortDirection.ASCENDING)
		), on_completed)

func on_completed(media:Array) -> void:
	print(media)
	
