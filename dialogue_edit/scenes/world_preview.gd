extends RichTextLabel

var screen_size : Vector2i
@onready var main_editor: VBoxContainer = $"../../main_editor/main_editor"

var visuals : Dictionary # obj_name : [image_arr, pos, color, add_paralax]

var resize_delay = 11
@onready var last_resize_time = Time.get_ticks_usec()

var camera_pos = Vector2i.ZERO

var font = get_theme_font("normal_font")
var font_size = get_theme_font_size("normal_font_size")

var char_width = font.get_string_size(" ", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
var line_height = font.get_height(font_size)

var scrolling_speed = 2
@export var show_colors := false

#var colors = {
    #[1, 1, 1] : Color.WHITE_SMOKE,
    #[1, 0, 0] : Color.RED,
    #[0, 1, 0] : Color.MEDIUM_SEA_GREEN,
    #[0, 0, 1] : Color.CORNFLOWER_BLUE,
    #[1, 1, 0] : Color.YELLOW,
    #[1, 0, 1] : Color.PALE_VIOLET_RED,
    #[0, 1, 1] : Color.AQUAMARINE
#}

var colors = {
    [1, 1, 1] : "white",
    [1, 0, 0] : "red",
    [0, 1, 0] : "green",
    [0, 0, 1] : "teal",
    [1, 1, 0] : "yellow",
    [1, 0, 1] : "purple",
    [0, 1, 1] : "aqua",
    [0, 0, 0] : "gray"
}


func _ready() -> void:
    font = get_theme_font("normal_font")
    font_size = get_theme_font_size("normal_font_size")
    
    char_width = font.get_string_size(" ", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
    line_height = font.get_height(font_size)

func update_visuals(obj_name : String, image_arr : Array, pos : Vector2i, color : Array[int], add_paralax):
    print("update_visuals() ", obj_name)
    #print(image_arr)
    if not main_editor:
        await get_tree().process_frame
    visuals[obj_name] = [image_arr, pos, color, add_paralax]
    
    render_visuals()

func render_visuals():
    print("render_visuals()")

    update_screen_size_in_symbols()
    var output = []
    for _a in range(screen_size.y - 1):
        output.append([])
        for _b in range(screen_size.x - 1):
            output[-1].append(' ')
    
    #var output_string : String = ""
    #for _a in range(screen_size.y):
        #for _b in range(screen_size.x):
            #output_string += ' '
        #output_string += '\n'
    #print(len(output_string))
    
    
    #var center_of_coord_relative_to_screen_size = Vector2i(screen_size.x, -screen_size.y)/2
    var half_screen_size = Vector2i(screen_size.x, screen_size.y)/2
    for image_arr_key in visuals:
        var i = 0;
        
        var pic = visuals[image_arr_key][0]
        var pos = visuals[image_arr_key][1]
        var color = colors[visuals[image_arr_key][2]]
        #var color = str(colors[visuals[image_arr_key][2]].ok_hsl_h)
        #print(color)
        var add_paralax = visuals[image_arr_key][3]
        
        var pic_x = 0
        for line in pic:
            pic_x = max(pic_x, len(line))
        
        var pic_size = Vector2i(pic_x, len(pic))
        var half_pic_size = pic_size/2
        
        
        var camOffsetX : int = camera_pos.x * add_paralax
        var camOffsetY : int = camera_pos.y * add_paralax

        var y_coord : int = coord_to_vec_space(pos.y, 'y') - camOffsetY/2;
        var x_coord : int = coord_to_vec_space(pos.x, 'x') + camOffsetX;
        
        
        var iy : int = y_coord - half_pic_size.y
        while iy < y_coord + half_pic_size.y and iy < screen_size.y:
            
            if iy >= 0 and i < pic_size.y:
                
                var ii := 0
                
                var ix : int = x_coord - half_pic_size.x
                #var was_line_color = false
                
                    
                while ix <= x_coord + half_pic_size.x && ix < screen_size.x * 2:
                    if ii >= len(pic[i]) or iy >= len(output):
                        break;
                    
                    #if ix >= 0 and pic[i][ii] != '?' and len(output_string[iy]) > ix:
                        #output_string[iy * screen_size.x * 2 + ix] = pic[i][ii]
                    #
                    if ix >= 0 and pic[i][ii] != '?' and len(output[iy]) > ix:
                        if show_colors:
                            output[iy][ix] = "[color=" + color + "]" + pic[i][ii] + "[/color]"
                        else:
                            output[iy][ix] = pic[i][ii]
                        #output[iy][ix] = pic[i][ii]
                        #output[iy * screen_size.x * 2 + ix] = pic[i][ii]
                        #output_string[iy * screen_size.x + ix].Attributes = color_attr;
                        
                        #if not was_line_color:
                            #output[iy][ix] = "[color=" + color + "]" + output[iy][ix]
                    
                    ii += 1
                    ix += 1
                #if was_line_color:
                    #output[iy][ix-1] +="[/color]"
            i += 1
            iy += 1
        
        
        
        
        #if pos.x - half_pic_size.x > half_screen_size.x or pos.x + half_pic_size.x < -half_screen_size.x or pos.y - half_pic_size.y > half_screen_size.y or pos.y + half_pic_size.y < -half_screen_size.y:
            #continue
        #for pix_inx_y in range(pic_size.y):
            #for pix_inx_x in range(len(pic[pix_inx_y])):
                #var pix_pos = Vector2i(layer_inx_x, layer_inx_y) + pos - pic_center
                #var pix_arr_pos =  pix_pos + center_of_coord_relative_to_screen_size
                #
                #output[pix_arr_pos.y][pix_arr_pos.x] = pic[layer_inx_y][layer_inx_x]
    #
    
    #print(output)
    
    var output_string : String = ""
    for line in output:
        for pix in line:
            output_string += pix
        output_string += '\n'
    
    #print(output_string)
    clear()
    append_text(output_string)
    #text = output_string

func coord_to_vec_space(coord : float, coord_name) -> int:
    
    match coord_name:
        'x':
            return (coord + (screen_size.x / 2.0) - camera_pos.x) * 2.0
        'y':
            return (screen_size.y / 2.0) - (coord - camera_pos.y)
    
    return 0;
    


func update_screen_size_in_symbols():
    #self.force_update_transform()

    var content_width = size.x #get_content_width()
    var content_height = size.y #get_content_height()
    
    if char_width == 0 or line_height == 0: return Vector2.ZERO
    
    var symbols_wide = content_width / char_width
    var symbols_high = content_height / line_height
    
    screen_size = Vector2(symbols_wide, symbols_high)
    print("update_screen_size_in_symbols() ", screen_size)

func _on_resized() -> void:
    
    render_visuals()
    #if last_resize_time:
        #if Time.get_ticks_usec() - last_resize_time > 555555:
            #render_visuals()
    #
    #last_resize_time = Time.get_ticks_usec()

func _input(_event):
    var inp_vec = Vector2i(Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up"))
    
    if inp_vec.length() > 0:
        camera_pos += inp_vec * scrolling_speed
        render_visuals()
    print(camera_pos)
    #if event.is_action_pressed("shoot"):
        #
    
        #if Input.is_action_just_pressed("jump"):
        ## Code for a single jump action
        #pass
