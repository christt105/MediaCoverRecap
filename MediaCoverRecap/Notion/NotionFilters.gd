class_name NotionFilters

const ONLY_SERIES := {
			"property": NotionDatabaseKeys.PROPERTY_TYPE,
			"select": {
				"equals": "Serie"
			}
		}

const ONLY_VIDEOGAMES := {
			"property": NotionDatabaseKeys.PROPERTY_TYPE,
			"select": {
				"equals": NotionDatabaseKeys.TYPE_VIDEOGAME
			}
		}

const ONLY_FILMS := {
			"property": NotionDatabaseKeys.PROPERTY_TYPE,
			"select": {
				"equals": NotionDatabaseKeys.TYPE_FILM
			}
		}

static func completed_on_year(year: int) -> Dictionary:
	return {
		"and": [
			{
				"property": NotionDatabaseKeys.PROPERTY_COMPLETED,
				"date": {
					"on_or_after": str(year) + "-01-01"
				}
			},
			{
				"property": NotionDatabaseKeys.PROPERTY_COMPLETED,
				"date": {
					"on_or_before": str(year) + "-12-31"
				}
			}
		]
	}
