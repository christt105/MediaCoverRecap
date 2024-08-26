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


static func from_to_date(from:Dictionary, to:Dictionary) -> Dictionary:
	return {
		"and": [
			{
				"property": NotionDatabaseKeys.property_completed,
				"date": {
					"on_or_after": "%04d-%02d-%02d" % [from["year"], from["month"], from["day"]]
				}
			},
			{
				"property": NotionDatabaseKeys.property_completed,
				"date": {
					"on_or_before": "%04d-%02d-%02d" % [to["year"], to["month"], to["day"]]
				}
			}
		]
	}
