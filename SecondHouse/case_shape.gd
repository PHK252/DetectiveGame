extends Area2D

@onready var object = $"."
@onready var case_top = $"../../SubViewportContainer/SubViewport/SecondHouseUpdate/Armature/Skeleton3D/topcase"
@onready var case_bottom = $"../../SubViewportContainer/SubViewport/SecondHouseUpdate/bottomcase"
@onready var apron = $"../../SubViewportContainer/SubViewport/SecondHouseUpdate/apron"
@onready var letter = $"../../SubViewportContainer/SubViewport/SecondHouseUpdate/letter"
@onready var bill =  $"../../SubViewportContainer/SubViewport/SecondHouseUpdate/bill"
@onready var look = $"../Case UI"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_input_event(viewport, event, shape_idx):
	if GlobalVars.in_look_screen == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				case_top.hide()
				case_bottom.hide()
				apron.hide()
				letter.hide()
				bill.hide()
				object.hide()
				look.show()
				GlobalVars.viewing = "case"
				GlobalVars.in_look_screen = true
				GlobalVars.clicked_case_Juniper = GlobalVars.clicked_case_Juniper + 1

	

func _on_exit_pressed():
	if GlobalVars.viewed_Juniper_case == false and GlobalVars.clicked_case_Juniper == 1:
		case_top.show()
		case_bottom.show()
		apron.show()
		letter.show()
		bill.show()
		object.show()
		GlobalVars.viewed_Juniper_case = true
		GlobalVars.viewing = ""
	else:
		case_top.show()
		case_bottom.show()
		apron.show()
		letter.show()
		bill.show()
		GlobalVars.viewing = ""


func _input(event):
	if Input.is_action_just_pressed("Exit") and GlobalVars.viewing == "bookmark":
		if GlobalVars.viewed_Juniper_case == false and GlobalVars.clicked_case_Juniper == 1:
			case_top.show()
			case_bottom.show()
			apron.show()
			letter.show()
			bill.show()
			GlobalVars.viewed_Juniper_case = true
			GlobalVars.viewing = "" 
		else:
			case_top.show()
			case_bottom.show()
			apron.show()
			letter.show()
			bill.show()
			await get_tree().create_timer(.3).timeout
			GlobalVars.viewing = ""
	
	
