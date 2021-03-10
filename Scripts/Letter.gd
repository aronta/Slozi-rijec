extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var drag_position = null
var change_mouse_pos = Vector2()
var changed_mouse_x
var changed_mouse_y

func _on_Letter_gui_input(event):
	print("Miš poz:", get_global_mouse_position())
	if event is InputEventMouseButton:
		#first_position = rect_global_position
		#print("Prva poz:", first_position)
		if event.is_action_pressed("left_click"):
			drag_position = get_global_mouse_position() - rect_global_position
			#emit_signal('move_to_top', self)
		else:
			drag_position = null
			
	if event is InputEventMouseMotion and drag_position:
		#print(get_viewport().get_visible_rect())
		#print(get_global_mouse_position().x)
#		if(get_global_mouse_position().x > 700 || get_global_mouse_position().x < 55 || get_global_mouse_position().y > 620 || get_global_mouse_position().y < 100):
#			return
		if(get_global_mouse_position().x > 1250 || get_global_mouse_position().x < 30 || get_global_mouse_position().y > 690 || get_global_mouse_position().y < 30):
			return
#		if(get_global_mouse_position().x > 700):
#			changed_mouse_x = get_global_mouse_position().x - 50
#			change_mouse_pos.x = changed_mouse_x
#			change_mouse_pos.y = get_global_mouse_position().y
#			rect_global_position = change_mouse_pos - drag_position
#			return
		rect_global_position = get_global_mouse_position() - drag_position
