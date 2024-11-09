extends MeshInstance3D

@onready var pic_cam = $SubViewportContainer/SubViewport/CameraSystem/Picture
@onready var main_cam = $SubViewportContainer/SubViewport/CameraSystem/closet
@onready var player = $Characters/Dalton/CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Exit"):
		pic_cam.priority = 0
		main_cam.priority = 12
		await get_tree().create_timer(.03).timeout
		player.show()
		player.start_player()



func _on_interactable_interacted(interactor):
	pic_cam.priority = 15
	main_cam.priority = 0
	player.hide()
	player.stop_player()
	
	
