class_name NotionFilters

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
