extends CharacterBody3D

# start at side, if triggered signal (e), then walk
# towards marker for 3 seconds, set one on w/anim then lerp to 0 on animtree for idle

@export var armature = Node3D
@export var anim_tree : AnimationTree
@export var path: PathFollow3D
@export var sound_player : AnimationPlayer
var activate := false
var pre_walk := false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		pre_walk = true
		await get_tree().create_timer(2.5).timeout
		pre_walk = false
		activate = true
	
	if pre_walk:
		sound_player.play("walk_skylar")
	
	if activate and path.progress_ratio < 1.0:
		path.progress_ratio += (0.5 * delta)
		sound_player.play("walk_skylar")
	elif activate and path.progress_ratio == 1.0:
		activate = false
		sound_player.play("gather_skylar")
	
	if activate:
		anim_tree.set("parameters/BlendSpace1D/blend_position", 1)
	else:
		anim_tree.set("parameters/BlendSpace1D/blend_position", 0)
