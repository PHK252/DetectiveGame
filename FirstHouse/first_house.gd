extends Node3D


@onready var note_interaction = $closet/Note
@onready var pic_fall_interact = $"SubViewportContainer/FirstHouseUpdated/FrameFalling/Armature_001/Skeleton3D/PictureFrameFriend/Pic fall Interact"
@onready var pic_look_interact = $"SubViewportContainer/FirstHouseUpdated/FrameFalling/Armature_001/Skeleton3D/PictureFrameFriend/Picture Look"
@onready var bookmark_interact = $"SubViewportContainer/FirstHouseUpdated/Bookshelf/Bookshelf interact/Bookmark_interact"
@onready var cab_interact = $"SubViewportContainer/FirstHouseUpdated/cabinetz/Cab Interact/Cab"
@onready var tool_look = $UI/Tool_note
@onready var bookmark_look = $UI/Bookmark

@onready var Dalton_marker = $UI/Dalton_marker
@onready var Micah_marker = $UI/Micah_marker
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.current_level = "Micah"
	note_interaction.hide()
	pic_fall_interact.hide()
	bookmark_interact.hide()
	tool_look.hide()
	bookmark_look.hide()
	cab_interact.hide()
	pic_look_interact.hide()
	#var layout = Dialogic.start("Office_Donuts")
	#layout.register_character(load("res://Dialogic Characters/Dalton.dch"), Micah_marker)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
	
	#print($SubViewportContainer/SubViewport/CameraSystem/Camera3D.rotation_degrees.y)
