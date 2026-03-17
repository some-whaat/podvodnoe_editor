extends Node

enum DialNodeType { DIALOGUE, CHOICE, DUMMY, LOGIC, NPC_ACTION }

var ALL_DATA : Dictionary
#var player_data : Dictionary


func load_json_file(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: ", file_path)
		return null

	var json_text = file.get_as_text()
	file.close()

	var data = JSON.parse_string(json_text)
	if data == null:
		push_error("Failed to parse JSON from file: ", file_path)
		return null

	return data

func save_to_json_file(data, file_path: String) -> bool:
	# Convert data to JSON string
	var json_string = JSON.stringify(data)

	# Open file for writing
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("File saved successfully to: ", file_path)
		return true
	else:
		print("Failed to open file for writing: ", file_path)
		return false
		
#func import_player_from_file(file_path: String):
	#player_data = load_json_file(file_path)

func import_all_data_from_file(file_path: String):
	ALL_DATA = load_json_file(file_path)
