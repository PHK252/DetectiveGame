extends Node3D

signal distraction
@export var phantom_cam = Node3D

func _ready() -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	phantom_cam.priority = 21
	emit_signal("distraction")
