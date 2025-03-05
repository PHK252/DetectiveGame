extends MeshInstance3D

@export var doughnut: Node3D
signal time_to_eat

func _ready() -> void:
	doughnut.visible = false

func _on_interactable_interacted(interactor: Interactor) -> void:
	emit_signal("time_to_eat")
	await get_tree().create_timer(2.5).timeout
	doughnut.visible = true
	await get_tree().create_timer(2.5).timeout
	doughnut.visible = false
