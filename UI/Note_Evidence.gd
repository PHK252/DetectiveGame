extends Control

@export var row_1: HBoxContainer
@export var row_2: HBoxContainer

@export var micah_letter : TextureButton
@export var micah_key : TextureButton
@export var micah_fur : TextureButton
@export var juniper_letter : TextureButton
@export var juniper_pie : TextureButton
@export var quincy_letter : TextureButton
@export var quincy_hammer : TextureButton
@export var quincy_coors : TextureButton
@export var quincy_choco : TextureButton


func _ready():
	_add_evidence(micah_letter)
	_add_evidence(micah_key)
	_add_evidence(micah_fur)
	_add_evidence(juniper_letter)
	_add_evidence(juniper_pie)
	_add_evidence(quincy_letter)
	_add_evidence(quincy_hammer)
	_add_evidence(quincy_coors)
	_add_evidence(quincy_choco)

func _add_evidence(evidence : TextureButton):
	if row_1.get_child_count() < 5:
		_attach_button(evidence, row_1)
	elif row_2.get_child_count() < 5:
		_attach_button(evidence, row_2)
	else:
		print_debug("Evidence in trouble")


func _attach_button(evidence : TextureButton, row_num : HBoxContainer):
	remove_child(evidence)
	row_num.add_child(evidence)
	evidence.show()
