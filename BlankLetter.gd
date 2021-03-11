extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flag
var letter
var letterTexture
var i
onready var timer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func move_buttons_away():
	get_tree().get_root().get_node("Game").get_node("HouseButton").move(Vector2(1296, 0))
	get_tree().get_root().get_node("Game").get_node("ResetButton").move(Vector2(1400, 0))
	get_tree().get_root().get_node("Game").get_node("HintButton").move(Vector2(1496, 0))
	get_tree().get_root().get_node("Game").get_node("BackButton").move(Vector2(0, -100))
	get_tree().get_root().get_node("Game").get_node("SuggestedLetters").move(Vector2(0, 840))
	get_tree().get_root().get_node("Game").get_node("BlankLetters").move(Vector2(0, -300))

func _ready():
	timer.set_wait_time(0.65)

#Global.wanted_word
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flag and Input.is_action_just_released("left_click"):
		var blank_letter = self
		var blank_letter_pos = self.get_position_in_parent()
		
		#ovdje hendlat ovisno koji letter je dobro postavljen
		#ako se desio snap na mjesto nedopustit vise da nesto moze uc u taj area
		if(letter == Global.wanted_word[blank_letter_pos]):
			print("Dobro stavljeno")
			blank_letter.texture = load("res://Assets/Blocks/GreenProjectile.png")
			blank_letter.get_children()[0].text = Global.wanted_word[blank_letter_pos]
			letterTexture.queue_free()
			Global.correct_counter += 1
			#print(Global.blank_letters_container.get_children())
		else:
			print(timer)
			Global.suggested_letters_container.set_alignment(0)
			timer.start()
			blank_letter.texture = load("res://Assets/Blocks/RedProjectile.png")
			print("Lose")
		#ovdje hendlat kad je sve tocno
		if(Global.correct_counter == Global.letters_len):
			Global.correct_counter = 0
			move_buttons_away()
			Global.correct_answer_pop_up.get_child(4).text = Global.wanted_word
			Global.correct_answer_pop_up.show()
			print("Sve je tocno")
		flag = false
		
		
		
		#if(blank_letter_pos )
		
		

func _on_Area2D_area_entered(area):
	#ovo bi trebalo sprijecit ako su dva ista slova da ako se opet stavi dobro slovo al na mjesto di je popunjeno vec s tim slovom
	if(Global.blank_letters_container.get_children()[self.get_position_in_parent()].get_children()[0].text != '?'):
		return
	flag = true
	letterTexture = area.get_owner()
	letter = area.get_owner().get_children()[0].text


func _on_Area2D_area_exited(area):
	flag = false
	pass # Replace with function body.


func _on_Timer_timeout():
	self.texture = load("res://Assets/Blocks/BlueProjectile.png")
	timer.stop()
