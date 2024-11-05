extends Node3D

@onready var animation_tree : AnimationTree = $bonedoor/AnimationDoor
@export var collision : CollisionShape3D

var is_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	print("Opening")
	animation_tree["parameters/conditions/is_opened"] = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	if not is_open:
		$Interactable.queue_free()
		open()
		collision.disabled = true
		is_open = true
	
