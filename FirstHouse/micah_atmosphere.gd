extends Node

var count : int = 0
var walking : bool = false
var panda_activate : bool = false
var delivery_activate : bool = false

var speed : float = 0.1
var sloth_speed : float = 0.05

@export var wander_character : Node3D
@export var wander_anim : AnimationPlayer

@export var walking_character : Node3D
@export var walking_anim : AnimationPlayer
@export var path : PathFollow3D

#timers
@export var panda_timer : Timer
@export var delivery_timer : Timer

#elevator and door control
@export var elevator_anim : AnimationPlayer
@export var door_anim : AnimationPlayer

#deliveryman control
@export var sloth : Node3D
@export var sloth_path : PathFollow3D
@export var sloth_anims : AnimationTree

#panda control
@export var panda : Node3D
@export var panda_path : PathFollow3D
@export var panda_anims : AnimationTree

func _ready():
	wander_character.visible = false
	walking_character.visible = false
	sloth.visible = false
	panda.visible = false
	panda_timer.start()

func _on_window_close_became_active() -> void:
	count += 1
	if count == 2: 
		wander_character.visible = true
		wander_anim.play("characInspect")
		
	if count == 4:
		walking_character.visible = true
		walking_anim.play("WalkDetective")
		var flipped_basis = path.global_transform.basis
		flipped_basis.x = -flipped_basis.x  # Flip the X basis vector to mirror rotation on the Y-axis
		flipped_basis.z = -flipped_basis.z  # Flip the Z basis vector to mirror rotation on the Y-axis
		walking_character.basis = flipped_basis
		walking = true
		
func _physics_process(delta: float) -> void:
	if walking and path.progress_ratio < 1:
		path.progress_ratio += speed * delta
	
	if panda_activate and panda_path.progress_ratio < 1:
		panda_anims.set("parameters/BlendSpace1D/blend_position", 1)
		panda_path.progress_ratio += speed * delta
		
	if delivery_activate and sloth_path.progress_ratio < 1:
		#sloth_anims.set("parameters/BlendSpace1D/blend_position", 1)
		sloth_anims.set("parameters/Blend2/blend_amount", 1)
		sloth_path.progress_ratio += sloth_speed * delta
	
func _on_window_close_became_inactive() -> void:
	wander_character.visible = false
	walking_character.visible = false
	walking = false

func _on_panda_timer_timeout() -> void:
	elevator_anim.play("elevatorOpenClose")
	panda.visible = true
	var flipped_panda = panda_path.global_transform.basis
	flipped_panda.x = -flipped_panda.x  # Flip the X basis vector to mirror rotation on the Y-axis
	flipped_panda.z = -flipped_panda.z  # Flip the Z basis vector to mirror rotation on the Y-axis
	panda.basis = flipped_panda
	await get_tree().create_timer(1.3).timeout
	panda_activate = true
	delivery_timer.start()

func _on_delivery_timer_timeout() -> void:
	elevator_anim.play("elevatorOpenClose")
	sloth.visible = true
	var flipped_deliver = sloth_path.global_transform.basis
	flipped_deliver.x = -flipped_deliver.x  # Flip the X basis vector to mirror rotation on the Y-axis
	flipped_deliver.z = -flipped_deliver.z  # Flip the Z basis vector to mirror rotation on the Y-axis
	sloth.basis = flipped_deliver 
	await get_tree().create_timer(1.3).timeout
	delivery_activate = true
