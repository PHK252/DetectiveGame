extends CanvasLayer

@onready var forward = $Forward
@onready var backward = $Backward
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var blank_turn_count = 0
@onready var page_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if page_count == 0:
		backward.disabled = true
		backward.hide()
	else:
		backward.disabled = false


func _on_forward_pressed():
	page_count += 1
	forward.hide()
	backward.hide()
	animation_tree["parameters/conditions/turn_page_forward"] = true
	await get_tree().create_timer(.5).timeout
	animation_tree["parameters/conditions/turn_page_forward"] = false
	await get_tree().create_timer(.5).timeout
	forward.show()
	if page_count != 0:
		backward.show()

func _on_backward_pressed():
	page_count -= 1

	if blank_turn_count > 0:
		forward.hide()
		backward.hide()
		animation_tree["parameters/conditions/turn_blank_backward"] = true
		await get_tree().create_timer(.5).timeout
		animation_tree["parameters/conditions/turn_blank_backward"] = false
		blank_turn_count -= 1
		await get_tree().create_timer(.5).timeout
		backward.show()
		forward.show()
		#print(blank_turn_count)
		#print(animation_tree.get_current_node())
	else: 
		forward.hide()
		backward.hide()
		animation_tree["parameters/conditions/turn_page_backward"] = true
		await get_tree().create_timer(.5).timeout
		animation_tree["parameters/conditions/turn_page_backward"] = false
		await get_tree().create_timer(.5).timeout
		backward.show()
		forward.show()
#
func _on_animation_tree_animation_started(anim_name):
	if anim_name == "Blank":
		blank_turn_count += 1
		#print(blank_turn_count)


func _on_exit_pressed():
	$".".hide()
	GlobalVars.in_look_screen = false
	GlobalVars.viewing = ""

func _input(event):
	if Input.is_action_just_pressed("Exit"):
		$".".hide()
		GlobalVars.in_look_screen = false
		await get_tree().create_timer(.3).timeout
		GlobalVars.viewing = ""
