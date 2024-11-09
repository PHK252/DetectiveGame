extends Node3D


@onready var note_interaction = $closet/Note
@onready var pic_fall_interact = $"SubViewportContainer/FirstHouseUpdated/PictureFrameFriend/Pic fall Interact"
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.current_level = "Micah"
	note_interaction.hide()
	pic_fall_interact.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
