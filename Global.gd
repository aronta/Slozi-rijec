extends Node2D

var difficulty
var words : Dictionary
var letters_len
var wanted_word
var correct_counter = 0
var blank_letters_container
var suggested_letters_container
var hint_image_container
var used_words = []

var mistakes_counter
var correct_answer_pop_up
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_json(path):
	var file = File.new()
	
	file.open(path, file.READ)
	words = parse_json(file.get_as_text())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
