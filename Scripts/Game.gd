extends Node2D

onready var blank_letter_box = preload("res://Scenes/BlankLetter.tscn")
onready var letter_box = preload("res://Scenes/Letter.tscn")
onready var hint_image_box = preload("res://Scenes/HintImg.tscn")
onready var timer = get_node("HintButtonTimer")
var img_animation
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func delete_children_nodes(parent_node):
	for n in parent_node.get_children():
		parent_node.remove_child(n)
		n.queue_free()

func generate_blank_words():
	var blank_letters_container = get_node("BlankLetters/HBoxContainer")
	Global.blank_letters_container = blank_letters_container
	delete_children_nodes(blank_letters_container)
	for i in range (Global.letters_len):
		var letter = blank_letter_box.instance()
		blank_letters_container.add_child(letter)
	#MOZDA IFAT za ljepotu
	blank_letters_container.add_constant_override("separation", 50)
	blank_letters_container.margin_left = 50

func generate_suggested_letters(suggested_word):
	var suggested_letters_container = get_node("SuggestedLetters/HBoxContainer");
	Global.suggested_letters_container = suggested_letters_container
	delete_children_nodes(suggested_letters_container)
	for i in range (Global.letters_len):
		var letter = letter_box.instance()
		letter.get_children()[0].text = suggested_word[i]
		suggested_letters_container.add_child(letter)
	#MOZDA IFAT za ljepotu
	suggested_letters_container.add_constant_override("separation", 50)
	suggested_letters_container.margin_left = 50

func generate_hint_image(img_path):
	var hint_image_container = get_node("HintImage")
	Global.hint_image_container = hint_image_container
	delete_children_nodes(hint_image_container)
	var hint_image = hint_image_box.instance()
	hint_image_container.add_child(hint_image)
	hint_image_container.get_children()[0].texture = load(img_path)
	
	
	
func setup_game_scene():
	var word_array = []
	var joined_word_array
	var word_and_img
	var word
	var img_path
	var number_of_words = Global.words.size();
	var used_words
	
	var rand = '0'
#   random za izabrat neki word iz json-a te popunit used words kako bi znali koje smo prosli
#	while true:
#		randomize()
#		rand = randi() % number_of_words
#		rand = str(rand)
#		if !(rand in Global.used_words):
#			break
	
	Global.used_words.append(rand)
	
	word_and_img = Global.words[rand]
	word = word_and_img.word.to_upper()
	Global.wanted_word = word
	img_path = word_and_img.img_path
	
	#string se ne moze direktno shufflat so this
	for i in range (word.length()):
		word_array.append(word[i])
	
	#randomize word letters tako da nikad nebude isto a ni pocetno stanje
	while true:
		randomize()
		word_array.shuffle()
		joined_word_array = PoolStringArray(word_array).join("")
		#print(joined_word_array)
		if(!joined_word_array == word):
			break
	#stvaranje praznih polja za slova (? boxes)
	generate_blank_words()
	
	#stvaranje ponudenih slova (suggested boxes) 
	generate_suggested_letters(joined_word_array)
	
	generate_hint_image(img_path)
	
	timer.set_wait_time(Global.letters_len * 1)
	img_animation = get_node("HintImage/TextureRect/AnimationPlayer")
	timer.start()
	
	

func move_all():
	#.move(x, y) -1280 -> znaci gore
	get_node("UI").move(Vector2(0, -1280))
	get_node("BlankLetters").move(Vector2(0, 140))
	get_node("SuggestedLetters").move(Vector2(0, 550))
	get_node("BackButton").move(Vector2(35, 10))

func easyPressed():
	Global.difficulty = 1
	Global.letters_len = 3
	Global.load_json("res://Data/easy_db.json")
	setup_game_scene()
	move_all()
	
func inGameBackButtonPressed():
	get_node("UI").move(Vector2(0, 0))
	get_node("BlankLetters").move(Vector2(0, -300))
	get_node("SuggestedLetters").move(Vector2(0, 840))
	get_node("BackButton").move(Vector2(0, -100))
	get_node("HintButton").move(Vector2(1296, 616))
	delete_children_nodes(Global.hint_image_container)


func _on_Timer_timeout_show_hint_button():
	#MOVAJ BUTTON NE EKRAN
	get_node("HintButton").move(Vector2(1100, 560))
	timer.stop()

func hintButton_pressed():
	img_animation.play('Img-fadeIn')
