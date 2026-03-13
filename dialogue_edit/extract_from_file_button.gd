extends Button

@onready var file_extract: FileDialog = $FileExtract


func _on_pressed() -> void:
	file_extract.popup()
