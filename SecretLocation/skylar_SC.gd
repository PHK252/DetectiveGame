extends CharacterBody3D

# start at side, if triggered signal (e), then walk
# towards marker for 3 seconds, set one on w/anim then lerp to 0 on animtree for idle

@export var armature = Node3D
@export var anim_tree : AnimationTree
@export var path: PathFollow3D
@export var sound_player : AnimationPlayer
