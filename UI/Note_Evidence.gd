extends Control

@export var container : VBoxContainer
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

@export var no_evidence: RichTextLabel
@export var description: RichTextLabel
@export var description_body: RichTextLabel

signal added_notes_overlay
#func _ready():
	#_add_evidence(micah_letter)
	#_add_evidence(micah_key)
	#_add_evidence(micah_fur)
	#_add_evidence(juniper_letter)
	#_add_evidence(juniper_pie)
	#_add_evidence(quincy_letter)
	#_add_evidence(quincy_hammer)
	#_add_evidence(quincy_coors)
	#_add_evidence(quincy_choco)

func _process(delta):
	if GlobalVars.evi_char == "":
		return
	_recieve_evidence()
	
	

func _add_evidence(evidence : TextureButton):
	if row_1.get_child_count() < 5:
		_attach_button(evidence, row_1)
	elif row_2.get_child_count() < 5:
		_attach_button(evidence, row_2)
	else:
		print_debug("Evidence placement in trouble")
	_clear_evidence()

func _clear_evidence():
	GlobalVars.evi_char = ""
	GlobalVars.evidence = ""

func _attach_button(evidence : TextureButton, row_num : HBoxContainer):
	remove_child(evidence)
	row_num.add_child(evidence)
	evidence.show()
	GlobalVars.evidence_container = container

func _recieve_evidence():
	if GlobalVars.evi_char == "micah":
		if GlobalVars.evidence == "fur":
			_add_evidence(micah_fur)
		elif GlobalVars.evidence == "key":
			_add_evidence(micah_key)
		elif GlobalVars.evidence == "letter":
			_add_evidence(micah_letter)
		else:
			print_debug("Micah recieving evidence in trouble")
	elif GlobalVars.evi_char == "juniper":
		if GlobalVars.evidence == "pie":
			_add_evidence(juniper_pie)
		elif GlobalVars.evidence == "letter":
			_add_evidence(juniper_letter)
		else:
			print_debug("Juniper recieving evidence in trouble")
	elif GlobalVars.evi_char == "quincy":
		if GlobalVars.evidence == "hammer":
			_add_evidence(quincy_hammer)
		elif GlobalVars.evidence == "coors":
			_add_evidence(quincy_coors)
		elif GlobalVars.evidence == "choco":
			_add_evidence(quincy_choco)
		elif GlobalVars.evidence == "letter":
			_add_evidence(quincy_letter)
		else:
			print_debug("Quincy recieving evidence in trouble")
	else:
		print_debug("Recieving evidence in trouble")
	emit_signal("added_notes_overlay")


func _on_evidence_pressed():
	if row_1.get_child_count() == 0:
		no_evidence.show()
		description.hide()
		description_body.hide()
	else:
		no_evidence.hide()
		description.show()
		description_body.show()
