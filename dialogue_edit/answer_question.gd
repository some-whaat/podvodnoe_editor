extends GraphNode

const type : BroManager.DialNodeType = BroManager.DialNodeType.CHOICE
var state_index

var answers_count : int = 1
@onready var choises : Array[TextEdit] = [$ansv1]
@onready var delete_last_ansv: Button = $delete_last_ansv

func  _ready() -> void:
	$more_ansv_butt.pressed.connect(_on_button_pressed)
	delete_last_ansv.pressed.connect(_on_delete_last_ansv_pressed)

func _on_button_pressed() -> void:
	add_new_text_edit()

func _on_delete_last_ansv_pressed() -> void:
	delete_last_ansv_()

func delete_last_ansv_():
	if answers_count > 0:
		get_child(answers_count).queue_free()
		set_slot_enabled_right(answers_count, false)
		choises.pop_back()
		answers_count -= 1
		#call_deferred("reset_size")

func add_new_text_edit(text : String = "") -> void:
	answers_count += 1
	var new_text_edit = TextEdit.new()
	
	new_text_edit.name = "ansv" + str(answers_count)
	new_text_edit.placeholder_text = "player's answer " + str(answers_count)
	new_text_edit.custom_minimum_size.y = 88
	new_text_edit.text = text
	add_child(new_text_edit)
	
	choises.append(new_text_edit)
	set_slot_enabled_right(answers_count, true)
	
	move_child(delete_last_ansv, -1)

func get_choises_text() -> Array[String]:
	var res := []
	
	for text : TextEdit in choises:
		res.append(text.text)
	
	return res

func _on_delete_request() -> void:
	queue_free()


func set_data(data : Dictionary):
	var data_copy = data.duplicate()
	$ansv1.queue_free()
	
	for line in data_copy["choices"]:
		add_new_text_edit(line)
	
