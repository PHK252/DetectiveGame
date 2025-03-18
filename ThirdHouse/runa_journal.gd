extends Control

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var blank_turn_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_forward_pressed():
	animation_tree["parameters/conditions/turn_page_forward"] = true
	await get_tree().create_timer(.5).timeout
	animation_tree["parameters/conditions/turn_page_forward"] = false

func _on_backward_pressed():
	animation_tree["parameters/conditions/turn_page_backward"] = true
	await get_tree().create_timer(.5).timeout
	animation_tree["parameters/conditions/turn_page_backward"] = false
