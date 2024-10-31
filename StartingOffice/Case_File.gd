extends MeshInstance3D

@onready var object = $"."
@onready var look = $"../../../../UI/Case Look"


func _on_interactable_interacted(interactor):
	object.hide()
	look.show()
	GlobalVars.in_look_screen = true
	print("case file")
