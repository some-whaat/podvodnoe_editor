extends GraphNode

var state_index
const type : BroManager.DialNodeType = BroManager.DialNodeType.DIALOGUE

@onready var dialogue: TextEdit = $dial1
@onready var text_width: SpinBox = $text_width

var dial_count : int = 1
@onready var lines : Array[TextEdit] = [$dial1]
@onready var delete_last_dial_butt: Button = $delete_last_dial_butt

func _on_delete_request() -> void:
    queue_free()

func get_dial() -> Array[String]:
    var res : Array[String] = []
    
    for line : TextEdit in lines:
        res.append(line.text)
    
    return res

func  _ready() -> void:
    $more_dial_butt.pressed.connect(_on_button_pressed)
    delete_last_dial_butt.pressed.connect(_on_delete_last_dial_pressed)

func _on_button_pressed() -> void:
    add_new_text_edit()

func _on_delete_last_dial_pressed() -> void:
    delete_last_dial_()

func delete_last_dial_():
    if dial_count > 0:
        get_child(dial_count + 1).queue_free()
        lines.pop_back()
        dial_count -= 1
        #call_deferred("reset_size")

func add_new_text_edit(text : String = "") -> void:
    dial_count += 1
    var new_text_edit = TextEdit.new()
    
    new_text_edit.name = "dial" + str(dial_count)
    new_text_edit.placeholder_text = "character says... " + str(dial_count)
    new_text_edit.custom_minimum_size.y = 141.0
    new_text_edit.text = text
    add_child(new_text_edit)
    
    lines.append(new_text_edit)
    
    move_child(delete_last_dial_butt, -1)

func get_lines_text() -> Array[String]:
    var res := []
    
    for text : TextEdit in lines:
        res.append(text.text)
    
    return res

func set_data(data : Dictionary):
    
    if len(data["dialogue"]) > 0:
        var data_copy = data.duplicate()
        dialogue.text = data_copy["dialogue"].pop_front()
        
        for line in data_copy["dialogue"]:
            add_new_text_edit(line)
        
        if data_copy.find_key("text_width"):
            text_width.value = data_copy["text_width"]
