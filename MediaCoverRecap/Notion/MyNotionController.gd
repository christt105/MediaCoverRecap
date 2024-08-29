class_name MyNotionController
extends NotionController

# A NotionController overriding the urls to get my Notion Database as Demo

func _init() -> void:
	pass

func _get_url_database(_database:String) -> String:
	return "https://christt105.npkn.net/get-my-notion-database/"


func _get_url_query(_database:String) -> String:
	return "https://christt105.npkn.net/notion-query-my-database/"
