extends MeshInstance3D

@export var towel: Node3D
signal distraction

func _ready() -> void:
	towel.visible = false

func _on_interactable_interacted(interactor: Interactor) -> void:
	emit_signal("distraction")
	await get_tree().create_timer(2).timeout
	towel.visible = true
	await get_tree().create_timer(3).timeout
	towel.visible = false
