extends Node3D


@onready var note_interaction = $closet/Note
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.current_level = "Micah"
	note_interaction.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
