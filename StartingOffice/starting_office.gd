extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	#Dialogic.start("Day 1 Office timeline")
	var layout = Dialogic.start("Office_contact_ad")
	layout.register_character(load("res://Dialogic Characters/Dalton.dch"), $Dalton/CharacterBody3D/Marker2D)
	##var pos = $Dalton/CharacterBody3D/Marker3D.get_child(0).global_positon
	#print(pos)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
