extends Node3D


@onready var note_interaction = $closet/Note
@onready var pic_fall_interact = $"SubViewportContainer/FirstHouseUpdated/PictureFrameFriend/Pic fall Interact"
@onready var bookmark_interact = $"SubViewportContainer/FirstHouseUpdated/Bookshelf/Bookshelf interact/Bookmark_interact"

@onready var tool_look = $UI/Tool_note
@onready var bookmark_look = $UI/Bookmark
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.current_level = "Micah"
	note_interaction.hide()
	pic_fall_interact.hide()
	bookmark_interact.hide()
	tool_look.hide()
	bookmark_look.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
