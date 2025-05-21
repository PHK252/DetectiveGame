extends MeshInstance3D

@export var doughnut: Node3D
signal time_to_eat
var just_interacted = false
@export var alert : Sprite3D
func _ready() -> void:
	doughnut.visible = false

func _on_interactable_interacted(interactor: Interactor) -> void:
	if just_interacted == false:
		alert.hide()
		just_interacted = true
		emit_signal("time_to_eat")
		await get_tree().create_timer(2.5).timeout
		doughnut.visible = true
		await get_tree().create_timer(2.0).timeout
		doughnut.visible = false
		await get_tree().create_timer(1.8).timeout
		just_interacted = false
		alert.show()
