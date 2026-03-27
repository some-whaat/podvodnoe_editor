extends RichTextLabel

var aspect_ratio : Vector2i
@onready var main_editor: VBoxContainer = $"../../main_editor/main_editor"

var visuals : Dictionary # obj_name : [image_arr, pos, color]

var resize_delay = 11
@onready var last_resize_time = Time.get_ticks_usec()


func update_visuals(obj_name : String, image_arr : Array, pos : Vector2i, color : Array):
	print("update_visuals() ", obj_name)
	print(image_arr)
	if not main_editor:
		await get_tree().process_frame
	visuals[obj_name] = [image_arr, pos, color]
	
	render_visuals()

func render_visuals():
	print("render_visuals()")
	update_aspect_ratio_in_symbols()
	var output = []
	for _a in range(aspect_ratio.y):
		output.append([])
		for _b in range(aspect_ratio.x):
			output[-1].append(' ')
	
	
	var center_of_coord_relative_to_aspect_ratio = Vector2i(aspect_ratio.x, -aspect_ratio.y)/2
	for image_arr_key in visuals:
		var pic = visuals[image_arr_key][0]
		var pos = visuals[image_arr_key][1]
		#var color = visuals[image_arr_key][2]
		var pic_center = Vector2i(len(pic[0])/2, len(pic)/2)
		for layer_inx_y in range(len(pic)):
			for layer_inx_x in range(len(pic[layer_inx_y])):
				var pix_pos = Vector2i(layer_inx_x, layer_inx_y) + pos - pic_center
				var pix_arr_pos =  pix_pos + center_of_coord_relative_to_aspect_ratio
				
				if pix_arr_pos.x >= 0 and pix_arr_pos.y >= 0 and pix_arr_pos.x < len(output[0]) and pix_arr_pos.y < len(output):
					output[pix_arr_pos.y][pix_arr_pos.x] = pic[layer_inx_y][layer_inx_x]
		
	var output_string : String = ""
	for line in output:
		for pix in line:
			output_string += pix
		output_string += '\n'
	
	#print(output_string)
	text = output_string

func update_aspect_ratio_in_symbols():
	# Ensure the text is updated before measuring
	#self.force_update_transform()
	
	# Get total content size in pixels
	var content_width = size.x #get_content_width()
	var content_height = size.y #get_content_height()
	
	# Get default font information
	var font = get_theme_font("normal_font")
	var font_size = get_theme_font_size("normal_font_size")
	
	# Calculate avg character size (e.g., width of a space or average glyph)
	# Using 'x' or a space is a common approximation
	var char_width = font.get_string_size(" ", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var line_height = font.get_height(font_size)
	
	if char_width == 0 or line_height == 0: return Vector2.ZERO
	
	# Calculate symbols
	var symbols_wide = content_width / char_width
	var symbols_high = content_height / line_height
	
	aspect_ratio = Vector2(symbols_wide, symbols_high)
	print("update_aspect_ratio_in_symbols() ", aspect_ratio)

func _on_resized() -> void:
	
	if last_resize_time:
		if Time.get_ticks_usec() - last_resize_time > 555555:
			render_visuals()
	
	last_resize_time = Time.get_ticks_usec()
	
