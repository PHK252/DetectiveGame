extends Node

var count : int = 0
var walking : bool = false
var panda_activate : bool = false
var panda_inside : bool = false
var delivery_activate : bool = false
var go_back_activate : bool = false

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
@export var E_sounds : AnimationPlayer
@export var open_sound : AudioStreamPlayer3D
@export var close_sound : AudioStreamPlayer3D

#deliveryman control
@export var sloth : Node3D
@export var sloth_path : PathFollow3D
@export var sloth_anims : AnimationTree
@export var anim_box : AnimationPlayer
@export var cardboard_anim : Node3D
@export var cardboard_static : Node3D
@export var slothSounds : AnimationPlayer
@export var slothcast : RayCast3D
@export var click_sound : AudioStreamPlayer3D

#panda control
@export var panda : Node3D
@export var panda_path : PathFollow3D
@export var panda_anims : AnimationTree
@export var pandaSounds : AnimationPlayer
@export var pandacast : RayCast3D

func _ready():
	wander_character.visible = false
	walking_character.visible = false
	cardboard_static.visible = false
	cardboard_anim.visible = true
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


func floor_type_walk_P():
	if pandacast.is_colliding():
		var collider = pandacast.get_collider()
		if collider.is_in_group("tile"):
			pandaSounds.play("TileFootsteps")
		if collider.is_in_group("carpet"):
			pandaSounds.play("CarpetFootsteps")

func floor_type_walk_S():
	if slothcast.is_colliding():
		var collider = slothcast.get_collider()
		if collider.is_in_group("tile"):
			slothSounds.play("TileFootsteps")
		if collider.is_in_group("carpet"):
			slothSounds.play("CarpetFootsteps")

func _physics_process(delta: float) -> void:
	if walking and path.progress_ratio < 1:
		path.progress_ratio += speed * delta
	
	if panda_activate and panda_path.progress_ratio < 1:
		if panda_inside == false:
			floor_type_walk_P()
			panda_anims.set("parameters/OpenDoor/request", 2)
			panda_anims.set("parameters/BlendSpace1D/blend_position", 1)
			panda_path.progress_ratio += speed * delta
			
		
	if delivery_activate and sloth_path.progress_ratio < 1:
		#sloth_anims.set("parameters/BlendSpace1D/blend_position", 1)
		floor_type_walk_S()
		sloth_anims.set("parameters/blendHold/blend_amount", 0)
		sloth_anims.set("parameters/BlendSpaceBox/blend_position", 1)
		sloth_path.progress_ratio += sloth_speed * delta
	
	if go_back_activate and sloth_path.progress_ratio != 0:
		floor_type_walk_S()
		sloth_anims.set("parameters/blendHold/blend_amount", 1)
		sloth_anims.set("parameters/BlendSpaceNone/blend_position", 1)
		sloth_path.progress_ratio -= sloth_speed * delta
		
	
func _on_window_close_became_inactive() -> void:
	wander_character.visible = false
	walking_character.visible = false
	walking = false

func _on_panda_timer_timeout() -> void:
	elevator_anim.play("elevatorOpenClose")
	E_sounds.play("OpenClose")
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
	E_sounds.play("OpenClose")
	sloth.visible = true
	var flipped_deliver = sloth_path.global_transform.basis
	flipped_deliver.x = -flipped_deliver.x  # Flip the X basis vector to mirror rotation on the Y-axis
	flipped_deliver.z = -flipped_deliver.z  # Flip the Z basis vector to mirror rotation on the Y-axis
	sloth.basis = flipped_deliver 
	#await get_tree().create_timer(0.3).timeout
	delivery_activate = true

func _on_panda_door_body_entered(body: Node3D) -> void:
	panda_inside = true
	panda_anims.set("parameters/BlendSpace1D/blend_position", 0)
	panda_anims.set("parameters/OpenDoor/request", true)
	await get_tree().create_timer(2.0).timeout
	door_anim.play("doorOpen")
	open_sound.play()
	await get_tree().create_timer(2.0).timeout
	panda_inside = false
	await get_tree().create_timer(2.0).timeout
	door_anim.play("doorClose")
	close_sound.play()
	

func _on_delivery_door_body_entered(body: Node3D) -> void:
	delivery_activate = false
	sloth_anims.set("parameters/BlendSpaceBox/blend_position", 0)
	sloth_anims.set("parameters/Blend2/blend_amount", 0)
	await get_tree().create_timer(1.2).timeout
	sloth_anims.set("parameters/PutDown/request", true)
	anim_box.play("box_drop")
	await get_tree().create_timer(10.5).timeout
	cardboard_static.visible = true
	cardboard_anim.visible = false
	var flipped_deliver = sloth.global_transform.basis
	var rotation = Basis(Vector3.UP, deg_to_rad(87))
	sloth.basis = rotation * flipped_deliver
	delivery_activate = false
	go_back_activate = true


func _on_elevator_button_body_entered(body: Node3D) -> void:
	if go_back_activate:
		go_back_activate = false
		sloth_anims.set("parameters/BlendSpaceNone/blend_position", 0)
		sloth_anims.set("parameters/DeliveryHitButton/request", true)
		await get_tree().create_timer(5).timeout
		click_sound.play()
		await get_tree().create_timer(10).timeout
		elevator_anim.play("elevatorOpenClose")
		E_sounds.play("OpenClose")
		go_back_activate = true
		


func _on_interactable_interacted(interactor: Interactor) -> void:
	print("focusedI")
	if panda_activate:
		panda_anims.set("parameters/BlendSpace1D/blend_position", 0)
		panda_activate = false
	

func _on_interactable_focused(interactor: Interactor) -> void:
	print("focused")
	if panda_activate:
		panda_anims.set("parameters/BlendSpace1D/blend_position", 0)
		panda_activate = false
		
	if delivery_activate:
		delivery_activate = false
		sloth_anims.set("parameters/BlendSpaceBox/blend_position", 0)
		
	if go_back_activate:
		go_back_activate = false
		sloth_anims.set("parameters/BlendSpaceNone/blend_position", 0)
		
		

func _on_interactable_unfocused(interactor: Interactor) -> void:
	print("unfocused")
	if panda_activate == false:
		panda_activate = true
		
	if delivery_activate == false:
		delivery_activate = true
		
	if go_back_activate == false and sloth_anims["parameters/blendHold/blend_amount"] == 1:
		delivery_activate = false
		go_back_activate = true
