extends HBoxContainer

var curr_file : String = ""
@onready var file_dialog: FileDialog = $LoadFileButton/FileDialog
@onready var current_filename: Label = $current_filename


func _on_load_file_button_pressed() -> void:
    file_dialog.popup()


func _on_file_dialog_file_selected(path: String) -> void:
    set_filepath(path.split("/")[-1])

func set_filepath(filepath : String):
    curr_file = filepath
    current_filename.text = filepath

#func get_path() -> String:
    #return curr_file
