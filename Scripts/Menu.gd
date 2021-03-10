extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func startPressed():
	get_node("Start").move(Vector2(-1280, 0))
	get_node("Options").move(Vector2(0, 256))


func optionsBackButtonPressed():
	get_node("Start").move(Vector2(0, 0))
	get_node("Options").move(Vector2(1280, 256))
