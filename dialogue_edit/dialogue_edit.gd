extends GraphEdit

@export var big_json_path : String
@export var layer_name : String
@export var character_name : String

const DIALOGUE_LINE = preload("res://dialogue_edit/scenes/dialogue_nodes/dialogue_line.tscn")
const DUMMY = preload("res://dialogue_edit/scenes/dialogue_nodes/dummy.tscn")
const PLAYER_CHOICE = preload("res://dialogue_edit/scenes/dialogue_nodes/player_choice.tscn")
const LOGIC = preload("res://dialogue_edit/scenes/dialogue_nodes/for_logic/logic.tscn")
const NPC_ACTION = preload("res://dialogue_edit/scenes/dialogue_nodes/for_action/npc_action.tscn")


@onready var grathnode_type_to_scene : Dictionary[BroManager.DialNodeType, PackedScene] = {
	BroManager.DialNodeType.DIALOGUE : DIALOGUE_LINE,
	BroManager.DialNodeType.CHOICE : PLAYER_CHOICE,
	BroManager.DialNodeType.DUMMY : DUMMY,
	BroManager.DialNodeType.LOGIC : LOGIC,
	BroManager.DialNodeType.NPC_ACTION : NPC_ACTION
}

@onready var start: GraphNode = $START

var indexes_given : int = 0

func _ready() -> void:
	$"../HBoxContainer/butt_add_dialogue_line".pressed.connect(_on_butt_add_dialogue_line_pressed)
	$"../HBoxContainer/butt_add_player_answer".pressed.connect(_on_butt_add_player_answer_pressed)
	#$"../HBoxContainer/save_button/FileDialog".file_selected.connect(_on_file_dialog_file_selected)
	delete_nodes_request.connect(_on_delete_nodes_request)
	connection_request.connect(_on_connection_request)
	disconnection_request.connect(_on_disconnection_request)
	
	'''!!!!!!!!!!!!ВРЕМЕННО, ПЕРЕНЕСТИ!!!!!!!!!!!!'''
	BroManager.import_player_from_file("res://game/Player.json")
	'''!!!!!!!!!!!!ВРЕМЕННО, ПЕРЕНЕСТИ!!!!!!!!!!!!'''
#func get_connection_list_from_port(node : StringName, port : int):
	#var connections = get_connection_list_from_node(node)
	#var result = []
	#for connection in connections:
		#var dict = {}
		#if connection["from_node"] == node and connection["from_port"] == port:
			#dict["node"] = connection["to_node"]
			#dict["port"] = connection["to_port"]
			#dict["type"] = "left"
			#result.push_back(dict)
		##elif connection["to_node"] == node and connection["to_port"] == port:
			##dict["node"] = connection["from_node"]
			##dict["port"] = connection["from_port"]
			##dict["type"] = "right"
			##result.push_back(dict)
	#return result

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)


func add_grath_node(pos : Vector2, dial_type : BroManager.DialNodeType) -> GraphNode:
	var new_node : GraphNode = grathnode_type_to_scene[dial_type].instantiate()
	new_node.position_offset = pos
	#new_dial_line.position_offset.y -= new_dial_line.size.y/2
	new_node.state_index = indexes_given
	indexes_given += 1
	add_child(new_node)
	
	return new_node

func _on_butt_add_dummy_pressed() -> void:
	add_grath_node(scroll_offset + Vector2(88, 222), BroManager.DialNodeType.DUMMY)

func _on_butt_add_dialogue_line_pressed() -> void:
	add_grath_node(scroll_offset + Vector2(88, 222), BroManager.DialNodeType.DIALOGUE)

func _on_butt_add_player_answer_pressed() -> void:
	add_grath_node(scroll_offset + Vector2(88, 88), BroManager.DialNodeType.CHOICE)

func _on_button_add_logic_pressed() -> void:
	add_grath_node(scroll_offset + Vector2(88, 88), BroManager.DialNodeType.LOGIC)

func _on_button_add_npc_action_pressed() -> void:
	add_grath_node(scroll_offset + Vector2(88, 88), BroManager.DialNodeType.NPC_ACTION)

#func _on_file_dialog_file_selected(path: String) -> void:
	#print(path)
	#
	#save_everything(path)
#


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for node in nodes:
		if node != &"START":
			get_node(String(node)).queue_free()

#func _on_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	#
	# можно сократить чтоб не копировать код, но искренне, who cares
	#var new_node : GraphNode
	#
	#if from_node == &"START":
		#new_node = add_dialogue_line(release_position)
		#
	#elif get_node(String(from_node)).has_method("add_new_text_edit"): # is player answer
		#new_node = add_dialogue_line(release_position)
		#
	#else:  # is dial line
		#if from_port == 0:
			#new_node = add_dialogue_line(release_position)
		#else:
			#new_node = add_player_answer(release_position)
	#
	#connect_node(from_node, from_port, new_node.name, 0)

func get_connections_outgoing_from_node(node : StringName) -> Array[Dictionary]:
	var res : Array[Dictionary] =[]
	
	for conn in get_connection_list_from_node(node):
		if conn["from_node"] == node:
			res.append(conn)
	
	return res


func save_everything():
	var save_data : Dictionary
	
	var used_inds : Array[int] = []
	var connections_queue : Array[Dictionary] = get_connections_outgoing_from_node(&"START")
	#print(connections_queue)
	
	var big_json_data : Dictionary = BroManager.load_json_file(big_json_path)
	big_json_data[layer_name][character_name]["NPC"]["defult_state"] = float(get_node(String(connections_queue[0]["to_node"])).state_index)
	
	while len(connections_queue) > 0:
		
		print("connections_queue: ", connections_queue)
		var curr_node_name = connections_queue.pop_front()["to_node"]
		var curr_node = get_node(String(curr_node_name))
		var curr_node_type : BroManager.DialNodeType = curr_node.type
		var curr_node_ind : int = curr_node.state_index
		var curr_conn = get_connections_outgoing_from_node(curr_node_name)
		used_inds.append(curr_node_ind)
		
		if len(curr_conn) > 0:
			for conn in curr_conn:
				if not get_node(String(conn["to_node"])).state_index in used_inds:
					connections_queue.append(conn)
			print("len(curr_conn) > 0")
		
		print("connections_queue: ", connections_queue)
		print("len(connections_queue): ", len(connections_queue), ",   curr_node_name: ", curr_node_name)
		
		match curr_node_type:
			BroManager.DialNodeType.DIALOGUE:
				save_data[curr_node_ind] = get_data_from_dialogue(curr_node, curr_conn)
				
			BroManager.DialNodeType.CHOICE:
				save_data[curr_node_ind] = get_data_from_choise(curr_node, curr_conn)
				
			BroManager.DialNodeType.DUMMY:
				save_data[curr_node_ind] = { "type" : "dummy", "next_state" : find_1st_connection_node_index_from_port_from_node_or_minus1(curr_conn, curr_node.name, 0) }
				
			BroManager.DialNodeType.NPC_ACTION:
				save_data[curr_node_ind] = get_data_from_npc_action(curr_node, curr_conn)
			
	#var data = big_json_data.data #json_data.stringify(json_data)
	
	print(save_data)
	
	big_json_data[layer_name][character_name]["NPC"]["states"] = save_data
	
	#var pretty_output = JSON.stringify(big_json_data)
	BroManager.save_to_json_file(big_json_data, big_json_path)

func find_connections_from_port_from_node(_connections : Array[Dictionary], from_node : StringName, from_port : int) -> Array[Dictionary]:
	var res : Array[Dictionary]
	
	for con in _connections:
		if con["from_node"] == from_node and con["from_port"] == from_port:
			res.append(con)
	
	return res

func find_1st_connection_node_index_from_port_from_node_or_minus1(_connections : Array[Dictionary], from_node : StringName, from_port : int):
	var cons = find_connections_from_port_from_node(_connections, from_node, from_port)
	if len(cons) > 0:
		return get_node(String(cons[0]["to_node"])).state_index
	return -1

func get_data_from_dialogue(dial : GraphNode, _connections : Array[Dictionary]) -> Dictionary:
	var res_json : Dictionary = {}
	
	res_json["type"] = "dialogue"
	res_json["dialogue"] = dial.get_dial()
	res_json["text_width"] = dial.text_width.value
	
	res_json["next_state"] = find_1st_connection_node_index_from_port_from_node_or_minus1(_connections, dial.name, 0)
	
	return res_json

func get_data_from_choise(choise : GraphNode, _connections : Array[Dictionary]) -> Dictionary:
	var res_json : Dictionary = {}
	
	res_json["type"] = "player_choice"
	res_json["choices"] = []
	res_json["next_states"] = []
	
	for connection in _connections:
		
		res_json["choices"].append(choise.get_child(connection["from_port"] + 1).text)
		res_json["next_states"].append(get_node(String(connection["to_node"])).state_index)
	
	return res_json

func get_data_from_npc_action(node : GraphNode, _connections : Array[Dictionary]) -> Dictionary:
	var res_json : Dictionary = node.get_data()
	
	res_json["type"] = "npc_action"

	res_json["next_state"] = find_1st_connection_node_index_from_port_from_node_or_minus1(_connections, node.name, 0)
	
	return res_json





#func extract_dial_passage(node_name : StringName, slot : int) -> DialoguePassage:
	#var dial_pass : DialoguePassage = DialoguePassage.new()
	#var connections_queue = get_connection_list_from_port(node_name, slot)
	#print(connections_queue)
	#
	#while len(connections_queue) > 0:
		#var curr_node_name = connections_queue.pop_front()["node"]
		#var new_conn = get_connection_list_from_port(curr_node_name, 0)
		#if len(new_conn) > 0:
			#connections_queue.append(new_conn[0])
		#var extracted_dial_line = extract_dial_line(get_node(String(curr_node_name)))
		#dial_pass.dialogue_passage.append(extracted_dial_line)
	#
	#return dial_pass
#
#func extract_dial_line(node : GraphNode) -> DialogueLine:
	#var the_line : DialogueLine = DialogueLine.new()
	#
	#the_line.line = node.get_node("the_text").text
	#the_line.expression_index = node.get_node("sprite_index").value
	#
	#var questions = get_connection_list_from_port(node.name, 1)
	#if len(questions) > 0:
		#the_line.question = get_question_data_from_answ_quest(questions[0].node)
	#
	#return the_line
#
#
#func get_question_data_from_answ_quest(answ_quest_name : String) -> QuestionLine:
	#var result : QuestionLine = QuestionLine.new()
	#var answ_quest = get_node(answ_quest_name)
	#for slot_index in range(1, answ_quest.answers_count + 1):
		#result.choices_answers.set(answ_quest.ansvers[slot_index - 1].text, extract_dial_passage(answ_quest.name, slot_index - 1))
	#
	#return result
#
#
#
#func download_from_file(path: String):
	#var the_passage : DialoguePassage = load(path).duplicate()
	#
	#extract_dial_pass(the_passage, &"START")
#
#
#func extract_dial_pass(dial_pass : DialoguePassage, node_to_connect_to : StringName, slot_from : int = 0):
	#var dial_queue = dial_pass.dialogue_passage
	#
	#while len(dial_queue) > 0:
		#var curr_dial_line : DialogueLine = dial_queue.pop_front()
		#
		#
		#var new_dial_line : GraphNode = add_dialogue_line(get_node(String(node_to_connect_to)).position_offset + Vector2(555, 0))
		#new_dial_line.get_node("the_text").text = curr_dial_line.line
		#new_dial_line.get_node("sprite_index").value = curr_dial_line.expression_index
		#
		#if (curr_dial_line.question):
			#var curr_quest_answ : QuestionLine = curr_dial_line.question
			#
			#var new_question = add_player_answer(new_dial_line.position_offset + Vector2(555, 555))
			#new_question.delete_last_ansv_()
			#for key in curr_quest_answ.choices_answers:
				#new_question.add_new_text_edit(key)
				#extract_dial_pass(curr_quest_answ.choices_answers[key], new_question.name, new_question.answers_count - 1)
				#
				#connect_node(new_dial_line.name, 1, new_question.name, 0)
		#
		#connect_node(node_to_connect_to, slot_from, new_dial_line.name, 0)
		#node_to_connect_to = new_dial_line.name
		#slot_from = 0

func clean_everything():
	for node in get_children():
		if node.name != &"START":
			node.queue_free()

#func _on_file_extract_file_selected(path: String) -> void:
	##clean_everything()
	#
	#download_from_file(path)


func _on_save_button_pressed() -> void:
	save_everything()
