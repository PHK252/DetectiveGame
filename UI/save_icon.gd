extends TextureRect

@onready var animation_player = $AnimationPlayer


func _ready():
	SaveLoad.saving.connect(_on_saving)

func _on_saving():
	print("saved")
	show()
	animation_player.play("Saving")
	await get_tree().create_timer(5.0).timeout
	hide()
	animation_player.play("RESET")
