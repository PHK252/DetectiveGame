extends Control

#screens
@export var home: Control
@export var case: Control
@export var micah: Control
@export var juniper: Control
@export var quincy: Control
@export var evidence : Control

#button behavior
func _on_visibility_changed():
	if visible == true:
		set_default()

func set_default():
	micah.hide() 
	juniper.hide()
	quincy.hide()
	case.hide()
	evidence.hide()
	home.show()


func _on_notes_pressed():
	case.show()
	home.hide()


func _on_victim_1_pressed():
	case.hide()
	micah.show()
	
func _on_victim_2_pressed():
	case.hide()
	juniper.show()

func _on_victim_3_pressed():
	case.hide()
	quincy.show()

func _on_back_pressed():
	case.hide()
	home.show()


func _on_micah_back_pressed():
	micah.hide()
	case.show()


func _on_Juniper_back_pressed():
	juniper.hide()
	case.show()


func _on_quincy_back_pressed():
	quincy.hide()
	case.show()


func _on_evidence_pressed():
	case.hide()
	evidence.show()


func _on_evidence_back_pressed():
	case.show()
	evidence.hide()
