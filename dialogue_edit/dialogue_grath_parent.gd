extends Control

@onready var graph_edit: GraphEdit = $GraphEdit

func import_from_states_data(states_data : Dictionary, defoult_state : float):
	graph_edit.import_from_states_data(states_data, defoult_state)
