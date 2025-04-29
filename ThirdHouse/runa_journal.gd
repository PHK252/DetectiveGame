extends CanvasLayer

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
	if blank_turn_count > 0:
		animation_tree["parameters/conditions/turn_blank_backward"] = true
		await get_tree().create_timer(.5).timeout
		animation_tree["parameters/conditions/turn_blank_backward"] = false
		blank_turn_count -= 1
		#print(blank_turn_count)
		#print(animation_tree.get_current_node())
	else: 
		animation_tree["parameters/conditions/turn_page_backward"] = true
		await get_tree().create_timer(.5).timeout
		animation_tree["parameters/conditions/turn_page_backward"] = false

#
func _on_animation_tree_animation_started(anim_name):
	if anim_name == "Blank":
		blank_turn_count += 1
		#print(blank_turn_count)
