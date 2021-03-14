extends Node2D

onready var blank_letter_box = preload("res://Scenes/BlankLetter.tscn")
onready var letter_box = preload("res://Scenes/Letter.tscn")
onready var hint_image_box = preload("res://Scenes/HintImg.tscn")
onready var timer = get_node("HintButtonTimer")
var img_animation
var img_fadeIn_flag
var hint_animation_counter = 0
onready var hint_animation = get_node("HintButton/AnimationPlayer")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.correct_answer_pop_up = get_node("UI/Menu/PopupMenu")
	Global.end_pop_up = get_node("UI/Menu/EndPopupMenu")\

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Global.timer_hint_flag):
		_on_Timer_timeout_show_hint_button()
	
func reset_suggestion_box_positions():
	var suggestion_container = get_node("SuggestedLetters/HBoxContainer")
	suggestion_container.set_alignment(0)

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
	blank_letters_container.add_constant_override("separation", 65)
	blank_letters_container.margin_left = 65

func generate_suggested_letters(suggested_word):
	var suggested_letters_container = get_node("SuggestedLetters/HBoxContainer");
	Global.suggested_letters_container = suggested_letters_container
	delete_children_nodes(suggested_letters_container)
	for i in range (Global.letters_len):
		var letter = letter_box.instance()
		letter.get_children()[0].text = suggested_word[i]
		suggested_letters_container.add_child(letter)
	#MOZDA IFAT za ljepotu
	suggested_letters_container.add_constant_override("separation", 65)
	suggested_letters_container.margin_left = 65

func generate_hint_image(img_path):
	var hint_image_container = get_node("HintImage")
	Global.hint_image_container = hint_image_container
	delete_children_nodes(hint_image_container)
	var hint_image = hint_image_box.instance()
	hint_image_container.add_child(hint_image)
	hint_image_container.get_children()[0].texture = load(img_path)
	
	
	
func setup_game_scene():
	Global.stop_hint_timer_all_correct = false
	Global.correct_counter = 0
	Global.error_cnt = 0
	var word_array = []
	var joined_word_array
	var word_and_img
	var word
	var img_path
	var number_of_words = Global.words.size();
	Global.words_len = number_of_words
	var used_words
	
	var rand
#   random za izabrat neki word iz json-a te popunit used words kako bi znali koje smo prosli
	while true:
		randomize()
		rand = randi() % number_of_words
		rand = str(rand)
		if !(rand in Global.used_words):
			break
	
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
	
	timer.set_wait_time(Global.letters_len * 4)
	
	img_animation = get_node("HintImage/TextureRect/AnimationPlayer")
	timer.start()
	
	img_fadeIn_flag = true
	hint_animation_counter = 0

func move_all():
	#.move(x, y) -1280 -> znaci gore
	get_node("UI").move(Vector2(0, -1280))
	get_node("BlankLetters").move(Vector2(0, 140))
	get_node("SuggestedLetters").move(Vector2(0, 550))
	get_node("BackButton").move(Vector2(35, 10))
	get_node("HouseButton").move(Vector2(-400, 0))
	get_node("ResetButton").move(Vector2(-390, 0))

func easyPressed(full_reset = true):
	if full_reset:
		Global.used_words = []
	Global.difficulty = 1
	Global.letters_len = 3
	Global.load_json("res://Data/easy_db.json")
	setup_game_scene()
	move_all()
	
func mediumPressed(full_reset = true):
	if full_reset:
		Global.used_words = []
	Global.difficulty = 2
	Global.letters_len = 4
	Global.load_json("res://Data/medium_db.json")
	setup_game_scene()
	move_all()
	
func hardPressed(full_reset = true):
	if full_reset:
		Global.used_words = []
	Global.difficulty = 3
	Global.letters_len = 5
	Global.load_json("res://Data/hard_db.json")
	setup_game_scene()
	move_all()
	
func inGameBackButtonPressed():
	get_node("UI").move(Vector2(0, 0))
	get_node("BlankLetters").move(Vector2(0, -300))
	get_node("SuggestedLetters").move(Vector2(0, 840))
	get_node("BackButton").move(Vector2(0, -100))
	#get_node("HintButton").move(Vector2(1296, 616))
	get_node("HouseButton").move(Vector2(1296, 0))
	get_node("ResetButton").move(Vector2(1400, 0))
	timer.stop()
	Global.error_cnt = 0
	Global.timer_hint_flag = false 
	get_node("HintButton").move(Vector2(1496, 0))
	delete_children_nodes(Global.hint_image_container)


func _on_Timer_timeout_show_hint_button():
	if(Global.stop_hint_timer_all_correct):
		timer.stop()
		return
	#MOVAJ BUTTON NE EKRAN
	get_node("HintButton").move(Vector2(-370, 0))
	hint_animation.get_animation("hintButton-color-fadeIn")
	#hint_animation.set_loop(true)
	hint_animation.play("hintButton-color-fadeIn")
	Global.timer_hint_flag = false
	#hint_animation.play("hintButton-color-fadeIn")
	timer.stop()

func hintButton_pressed():
	if(img_fadeIn_flag):
		img_animation.play('Img-fadeIn')
		img_fadeIn_flag = false

func hint_animation_finished(anim_name):
	if(hint_animation_counter == 2):
		return
	hint_animation_counter += 1
	hint_animation.play("hintButton-color-fadeIn")

func continue_pressed():
	Global.correct_answer_pop_up.hide()
	#get_node("BlankLetters").move(Vector2(0, -300))
	reset_suggestion_box_positions()
	#get_node("SuggestedLetters").move(Vector2(0, 840))
	#yield(get_tree().create_timer(0.2), "timeout")
	
	if Global.difficulty == 1:
		easyPressed(false)
	elif Global.difficulty == 2:
		mediumPressed(false)
	else:
		hardPressed(false)

func houseButtonPressed():
	get_node("UI").move(Vector2(0, 0))
	get_node("UI/Menu/Options").move(Vector2(1280, 256))
	get_node("UI/Menu/Start").move(Vector2(0, 0))
	
	get_node("BlankLetters").move(Vector2(0, -300))
	get_node("SuggestedLetters").move(Vector2(0, 840))
		
	get_node("BackButton").move(Vector2(0, -100))
	get_node("HouseButton").move(Vector2(1296, 0))
	get_node("ResetButton").move(Vector2(1400, 0))
	timer.stop()
	Global.error_cnt = 0
	Global.timer_hint_flag = false 
	get_node("HintButton").move(Vector2(1496, 0))
	
	delete_children_nodes(Global.hint_image_container)
	reset_suggestion_box_positions()

#na reset button se bas resetira cijeli taj lvl tjst izbrisu se sve zapamcene rijesene rijeci!!!
func resetButtonPressed():
	timer.stop()
	get_node("HintButton").move(Vector2(1496, 0))
	reset_suggestion_box_positions()
	if Global.difficulty == 1:
		easyPressed(true)
	elif Global.difficulty == 2:
		mediumPressed(true)
	else:
		hardPressed(true)
		
func helpPressed():
	get_node("UI/Menu/Start").move(Vector2(-1280, 0))
	get_node("UI/Menu/Help").move(Vector2(0, 100))
	
func helpBackButtonPressed():
	get_node("UI/Menu/Start").move(Vector2(0, 0))
	get_node("UI/Menu/Help").move(Vector2(1280, 100))
	
func endButtonPressed():
	Global.end_pop_up.hide()
	get_node("UI").move(Vector2(0, 0))
	reset_suggestion_box_positions()
	get_node("BlankLetters").move(Vector2(0, -300))
	get_node("SuggestedLetters").move(Vector2(0, 840))

func _on_Quit_pressed():
	get_tree().quit()
