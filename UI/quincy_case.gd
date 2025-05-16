extends CanvasLayer

@onready var label = $Label
@onready var blinker = $Blink


@onready var password = "56423"
@onready var input = ""

@onready var abc_pos = -1
@onready var abc_array = ["2", "a", "b", "c"]

@onready var def_pos = -1
@onready var def_array = ["3", "d", "e", "f"]

@onready var ghi_pos = -1
@onready var ghi_array = ["4", "g", "h", "i"]

@onready var jkl_pos = -1
@onready var jkl_array = ["5", "j", "k", "l"]

@onready var mno_pos = -1
@onready var mno_array = ["6", "m", "n", "o"]

@onready var pqrs_pos = -1
@onready var pqrs_array = ["7", "p", "q", "r", "s"]

@onready var tuv_pos = -1
@onready var tuv_array = ["8", "t", "u", "v"]

@onready var wxyz_pos = -1
@onready var wxyz_array = ["9", "w", "x", "y", "z"]

@onready var blinker_x_pos_intial = 444
@onready var blinker_x_pos = blinker_x_pos_intial
@onready var blinker_anim = $AnimationPlayer
@onready var position = 0
@export var open_animation : AnimationPlayer
@export var interact_area_1 : Area2D
@export var interact_area_2 : Area2D

@onready var current_button = ""
@onready var pressed_button = "1"

func _ready():
	label.text = ""
	#blinker.size = Vector2(15, 3)
	#blinker.position = Vector2(blinker_x_pos, 821.0)
	blinker_anim.play("Blink")
#	open_animation.play("default")

func reset_num():
	abc_pos = -1
	def_pos = -1
	ghi_pos = -1
	jkl_pos = -1
	mno_pos = -1
	pqrs_pos = -1
	tuv_pos = -1
	wxyz_pos = -1

func _on_one_pressed():
	pressed_button = "1"
	reset_when_switch()
	label.text = input + "1"

func _on_zero_pressed():
	pressed_button = "0"
	reset_when_switch()
	label.text = input + "0"
	
func _on_abc_pressed():
	pressed_button = "2"
	reset_when_switch()
	if abc_pos == len(abc_array) - 1:
		abc_pos = 0
		label.text = input + abc_array[abc_pos]
	else:
		abc_pos += 1
		label.text = input + abc_array[abc_pos]

func _on_def_pressed():
	pressed_button = "3"
	reset_when_switch()
	if def_pos == len(def_array) - 1:
		def_pos = 0
		label.text = input + def_array[def_pos]
	else:
		def_pos += 1
		label.text = input + def_array[def_pos]

func _on_ghi_pressed():
	pressed_button = "4"
	reset_when_switch()
	if ghi_pos == len(ghi_array) - 1:
		ghi_pos = 0
		label.text = input + ghi_array[ghi_pos]
	else:
		ghi_pos += 1
		label.text = input + ghi_array[ghi_pos]


func _on_jkl_pressed():
	pressed_button = "5"
	reset_when_switch()
	if jkl_pos == len(jkl_array) - 1:
		jkl_pos = 0
		label.text = input + jkl_array[jkl_pos]
	else:
		jkl_pos += 1
		label.text = input + jkl_array[jkl_pos]


func _on_mno_pressed():
	pressed_button = "6"
	reset_when_switch()
	if mno_pos == len(mno_array) - 1:
		mno_pos = 0
		label.text = input + mno_array[mno_pos]
	else:
		mno_pos += 1
		label.text = input + mno_array[mno_pos]


func _on_pqrs_pressed():
	pressed_button = "7"
	reset_when_switch()
	if pqrs_pos == len(pqrs_array) - 1:
		pqrs_pos = 0
		label.text = input + pqrs_array[pqrs_pos]
	else:
		pqrs_pos += 1
		label.text = input + pqrs_array[pqrs_pos]


func _on_tuv_pressed():
	pressed_button = "8"
	reset_when_switch()
	if tuv_pos == len(tuv_array) - 1:
		tuv_pos = 0
		label.text = input + tuv_array[tuv_pos]
	else:
		tuv_pos += 1
		label.text = input + tuv_array[tuv_pos]


func _on_wxyz_pressed():
	pressed_button = "9"
	reset_when_switch()
	if wxyz_pos == len(wxyz_array) - 1:
		wxyz_pos = 0
		label.text = input + wxyz_array[wxyz_pos]
	else:
		wxyz_pos += 1
		label.text = input + wxyz_array[wxyz_pos]

func _on_next_pressed():
	input = label.text
	if len(input) == position + 1:
		position += 1
		position_blinker_forward(position - 1)
	reset_num()
	#print(input)

func _on_back_pressed():
	if len(input) > 0:
		position_blinker_backwards(position-1)
		label.text = label.text.erase(len(label.text)-1, 1)
		input = label.text
		position -= 1
		print(position)
		reset_num()

func position_blinker_forward(pos : int):
	var offset = label.get_character_bounds(pos)
	#print("Before " + str(blinker.position.x))
	blinker_x_pos = offset.size.x + blinker_x_pos
	blinker.position.x = blinker_x_pos
	#print("After " + str(blinker.position.x))

func position_blinker_backwards(pos : int):
	var offset = label.get_character_bounds(pos)
	#print("Before " + str(blinker.position.x))
	blinker_x_pos =  blinker_x_pos - offset.size.x
	blinker.position.x = blinker_x_pos
	#print("After " + str(blinker.position.x))

func _on_enter_pressed():
	blinker_anim.play("RESET")
	input = label.text
	blinker.position.x = blinker_x_pos_intial
	reset_num()
	if password == input:
		#print("correct")
		label.text = "Opening..."
		GlobalVars.open_quincy_case.connect(_open_case) 
		print("Open")
		GlobalVars.emit_open_quincy_case()
		await get_tree().create_timer(1.5).timeout
	else:
		#print("very wrong")
		label.text = "Wrong"
		await get_tree().create_timer(1.5).timeout
		input = ""
		label.text = input
		position = 0
		blinker_anim.play("Blink")
		pass


func _on_def_mouse_exited():
	reset_num()

func _on_abc_mouse_exited():
	reset_num()

func _on_ghi_mouse_exited():
	reset_num()

func _on_jkl_mouse_exited():
	reset_num()

func _on_mno_mouse_exited():
	reset_num()

func _on_pqrs_mouse_exited():
	reset_num()

func _on_tuv_mouse_exited():
	reset_num()

func _on_wxyz_mouse_exited():
	reset_num()

func reset_when_switch():
	if current_button != pressed_button:
		current_button = pressed_button
		print(current_button)
		reset_num()


func _open_case():
	#case_unlocked.play()
	#cam_anim.play("Case_look")
	#hide_closed_case()
	#show_open_case()
	GlobalVars.in_look_screen = false
	GlobalVars.Quincy_in_case = false
	$".".hide()
	open_animation.play("case_open")
	await open_animation.animation_finished
	await get_tree().create_timer(.03).timeout
	GlobalVars.viewing = ""
	interact_area_1.show()
	interact_area_2.show()
	GlobalVars.open_quincy_case.disconnect(_open_case)
