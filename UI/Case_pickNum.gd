extends CanvasLayer

@onready var pos1 = $Pos1
@onready var pos2 = $Pos2
@onready var pos3 = $Pos3
@onready var pos4 = $Pos4
@onready var pos5 = $Pos5
@onready var pos6 = $Pos6

@onready var password = "100404"
@onready var check = ""

@onready var posClick = 0

@export var cam_anim : AnimationPlayer
@export var open_animation : AnimationPlayer
@export var open_animation_2 : AnimationTree
@export var interact_area_1 : Area2D
@export var interact_area_2 : Area2D
@export var interact_area_3 : Area2D

@export var case_top_1 : MeshInstance3D
@export var case_bottom_1 : MeshInstance3D

@export var case_top_2 : MeshInstance3D
@export var case_bottom_2 : MeshInstance3D
@export var case_hair : MeshInstance3D
@export var case_note : MeshInstance3D
@export var case_key : MeshInstance3D

@export var collision : CollisionShape3D
#sounds
@export var case_locked : AudioStreamPlayer3D
@export var case_unlocked : AudioStreamPlayer3D
@export var switch : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	#$".".hide()
	posChange()

func hide_open_case():
	case_top_2.hide()
	case_bottom_2.hide()
	case_hair.hide()
	case_note.hide()
	case_key.hide()

func show_open_case():
	case_top_2.show()
	case_bottom_2.show()
	if Dialogic.VAR.get_variable("Asked Questions.has_hair") == true:
		case_hair.hide()
	else:
		case_hair.show()
	case_note.show()
	case_key.show()
	
func  hide_closed_case():
	case_top_1.hide()
	case_bottom_1.hide()
	
func  show_closed_case():
	case_top_1.show()
	case_bottom_1.show()

func _input(event):
	if GlobalVars.Micah_in_case == true:
		#if Input.is_action_just_pressed("case_right"):
			#switch.play()
#
		#
		#if Input.is_action_just_pressed("case_left"):
			#switch.play()

		if Input.is_action_just_pressed("ui_accept"):
			print(check)
			if check != password:
				case_locked.play()
#	if Input.is_action_just_pressed("Exit"):
	#	$".".hide()

func _process(delta):
	if GlobalVars.Micah_in_case == true:
		check = str(pos1.numClick) + str(pos2.numClick) + str(pos3.numClick) + str(pos4.numClick) +str(pos5.numClick) + str(pos6.numClick) 
		if check == password:
			GlobalVars.open_micah_case.connect(_open_case) 
			GlobalVars.emit_open_micah_case()
			await get_tree().create_timer(1.5).timeout
			GlobalVars.emit_add_note("micah", "case", "unlock")
			password = ""
			pos1.hideArrows()
			pos2.hideArrows()
			pos3.hideArrows()
			pos4.hideArrows()
			pos5.hideArrows()
			pos6.hideArrows()
			

func _on_exit_pressed():
	$".".hide()

func _open_case():
	case_unlocked.play()
	cam_anim.play("Case_look")
	hide_closed_case()
	show_open_case()
	GlobalVars.in_look_screen = false
	GlobalVars.Micah_in_case = false
	$".".hide()
	collision.set_deferred("disabled", true)
	Dialogic.VAR.set_variable("Asked Questions.Micah_Solved_Case", true)
	open_animation_2["parameters/conditions/case_opened"] = true
	await open_animation_2.animation_finished
	await get_tree().create_timer(.03).timeout
	GlobalVars.viewing = ""
	interact_area_1.show()
	interact_area_2.show()
	interact_area_3.show()
	GlobalVars.open_micah_case.disconnect(_open_case)


func posChange():
	switch.play()
	if posClick == 0:
		pos1.showArrows()
		pos2.hideArrows()
		pos3.hideArrows()
		pos4.hideArrows()
		pos5.hideArrows()
		pos6.hideArrows()
	elif posClick == 1:
		pos1.hideArrows()
		pos2.showArrows()
		pos3.hideArrows()
		pos4.hideArrows()
		pos5.hideArrows()
		pos6.hideArrows()
	elif posClick == 2:
		pos1.hideArrows()
		pos2.hideArrows()
		pos3.showArrows()
		pos4.hideArrows()
		pos5.hideArrows()
		pos6.hideArrows()
	elif posClick == 3:
		pos1.hideArrows()
		pos2.hideArrows()
		pos3.hideArrows()
		pos4.showArrows()
		pos5.hideArrows()
		pos6.hideArrows()
	elif posClick == 4:
		pos1.hideArrows()
		pos2.hideArrows()
		pos3.hideArrows()
		pos4.hideArrows()
		pos5.showArrows()
		pos6.hideArrows()
	elif posClick == 5:
		pos1.hideArrows()
		pos2.hideArrows()
		pos3.hideArrows()
		pos4.hideArrows()
		pos5.hideArrows()
		pos6.showArrows()


func _on_letter_exit_pressed():
	show_open_case()
