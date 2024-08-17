class_name NotionFilters

static var ONLY_SERIES := {
			"property": NotionDatabaseKeys.property_type,
			"select": {
				"equals": "Serie"
			}
		}

static var ONLY_VIDEOGAMES := {
			"property": NotionDatabaseKeys.property_type,
			"select": {
				"equals": NotionDatabaseKeys.type_videogame
			}
		}

static var ONLY_FILMS := {
			"property": NotionDatabaseKeys.property_type,
			"select": {
				"equals": NotionDatabaseKeys.type_film
			}
		}

static func completed_on_year(year: int) -> Dictionary:
	return {
		"and": [
			{
				"property": NotionDatabaseKeys.property_completed,
				"date": {
					"on_or_after": str(year) + "-01-01"
				}
			},
			{
				"property": NotionDatabaseKeys.property_completed,
				"date": {
					"on_or_before": str(year) + "-12-31"
				}
			}
		]
	}
