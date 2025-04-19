extends Node3D

@export var animation_tree : AnimationTree
@export var animation_tree_2 : AnimationTree

@export var collision : CollisionShape3D
@export var collision_2 : CollisionShape3D
@export var animation : AnimationPlayer

@export var dialogue_file : String
#@onready var dalton_marker = $"../../../UI/Dalton_marker"
#@onready var micah_marker = $"../../../UI/Micah_marker"
#@onready var theo_marker = $"../../../UI/Theo_marker"
@export var player = CharacterBody3D
var is_open: bool = false
var did_dialogue = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func open() -> void:
	#print("Opening")
	animation_tree["parameters/conditions/is_opened"] = true
	animation_tree_2["parameters/conditions/is_opened"] = true
	animation_tree["parameters/conditions/is_closed"] = false
	animation_tree_2["parameters/conditions/is_closed"] = false
	animation_tree["parameters/conditions/speed"] = false
	animation_tree_2["parameters/conditions/speed"] = false
	is_open = true
	
func close() -> void:
	#print("Opening")
	animation_tree["parameters/conditions/is_closed"] = true
	animation_tree_2["parameters/conditions/is_closed"] = true
	animation_tree["parameters/conditions/is_opened"] = false
	animation_tree_2["parameters/conditions/is_opened"] = false
	is_open = false
	await get_tree().create_timer(1.63).timeout
	animation_tree["parameters/conditions/speed"] = true
	animation_tree_2["parameters/conditions/speed"] = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distracted = Dialogic.VAR.get_variable("Quincy.is_distracted")
	if distracted == true: 
		if is_open == false:
			await animation.animation_finished
			open()
			collision.disabled = true
			collision_2.disabled = true
			if did_dialogue == false:
				GlobalVars.in_dialogue = true
				Dialogic.timeline_ended.connect(_on_timeline_ended)
				Dialogic.start(dialogue_file)
		if is_open == true: 
			close()
			collision.disabled = false
			collision_2.disabled = false

	
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	GlobalVars.in_dialogue = false
	did_dialogue = true
	
	
