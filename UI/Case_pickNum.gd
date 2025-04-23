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
		if Input.is_action_just_pressed("case_right"):
			if posClick < 5:
				posClick = posClick + 1 
			else:
				posClick = 0
			posChange()
		
		if Input.is_action_just_pressed("case_left"):
			if posClick > 0:
				posClick = posClick - 1
			else:
				posClick = 5
			posChange()
		if Input.is_action_just_pressed("ui_accept"):
			print(check)
#	if Input.is_action_just_pressed("Exit"):
	#	$".".hide()

func _process(delta):
	if GlobalVars.Micah_in_case == true:
		check = str(pos1.numClick) + str(pos2.numClick) + str(pos3.numClick) + str(pos4.numClick) +str(pos5.numClick) + str(pos6.numClick) 
		if check == password:
			print("opened")
			GlobalVars.open_micah_case.connect(_open_case) 
			print("Open")
			GlobalVars.emit_open_micah_case()
			await get_tree().create_timer(1.5).timeout
			#print("opened case " + str(GlobalVars.opened_jun_case))
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
	cam_anim.play("Case_look")
	hide_closed_case()
	show_open_case()
	GlobalVars.in_look_screen = false
	GlobalVars.Micah_in_case = false
	$".".hide()
	open_animation.play("caseopened")
	await open_animation.animation_finished
	await get_tree().create_timer(.03).timeout
	GlobalVars.viewing = ""
	interact_area_1.show()
	interact_area_2.show()
	interact_area_3.show()
	GlobalVars.open_micah_case.disconnect(_open_case)


func posChange():
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
