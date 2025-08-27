extends Node

@export var door_anim : AnimationPlayer
@export var dalton_look : AnimationTree
@export var dalton_room : AnimationTree
@export var brother_anims : AnimationTree

var stop_repeat := false
var check_repeat = false

@export var isaac_marker : Marker2D
@export var kale_marker : Marker2D
@export var player: CharacterBody3D

@export var doorSound : AudioStreamPlayer3D
@export var seizure_sound : AnimationPlayer

signal start_Isaac
signal check_on_isaac
signal switch_cam_bed

func _on_enter_room_body_entered(body: Node3D) -> void:
	if stop_repeat == false and GlobalVars.in_dialogue == false:
		door_anim.play("DoorOpen")
		doorSound.play()
		stop_repeat = true
		GlobalVars.in_dialogue = true
		var bedroom_open_dialogue = Dialogic.start("Day_1_Isaac", "bedroom_open")
		Dialogic.timeline_ended.connect(_on_open_ended)
		bedroom_open_dialogue.register_character(load("res://Dialogic Characters/Kale.dch"), kale_marker)
		bedroom_open_dialogue.register_character(load("res://Dialogic Characters/Isaac.dch"), isaac_marker)
		player.stop_player()


func _on_check_kale_body_entered(body):
	if check_repeat == false and GlobalVars.in_dialogue == false:
		emit_signal("check_on_isaac")
		GlobalVars.in_dialogue = true
		check_repeat = true
		player.stop_player()
		await get_tree().create_timer(1.8).timeout
		var bedroom_open_dialogue = Dialogic.start("Day_1_Isaac", "bedroom_check")
		Dialogic.timeline_ended.connect(_on_flash_ended)
		bedroom_open_dialogue.register_character(load("res://Dialogic Characters/Kale.dch"), kale_marker)
		bedroom_open_dialogue.register_character(load("res://Dialogic Characters/Isaac.dch"), isaac_marker)
		



func _on_start_kitchen_dialogue():
	GlobalVars.in_dialogue = true
	var kitchen_dialogue = Dialogic.start("Day_1_Isaac", "kitchen")
	Dialogic.timeline_ended.connect(_on_kitchen_ended)
	kitchen_dialogue.register_character(load("res://Dialogic Characters/Kale.dch"), kale_marker)
	kitchen_dialogue.register_character(load("res://Dialogic Characters/Isaac.dch"), isaac_marker)

func _on_kitchen_ended():
	Dialogic.timeline_ended.disconnect(_on_kitchen_ended)
	GlobalVars.in_dialogue = false
	emit_signal("start_Isaac")

func _on_open_ended():
	Dialogic.timeline_ended.disconnect(_on_open_ended)
	GlobalVars.in_dialogue = false
	player.start_player()
	dalton_look["parameters/conditions/go_in"] = true
	dalton_room["parameters/conditions/seizure"] = true
	brother_anims["parameters/conditions/start_anim"] = true
	seizure_sound.play("tweak")
	emit_signal("switch_cam_bed")


func _on_flash_ended():
	Dialogic.timeline_ended.disconnect(_on_flash_ended)
	GlobalVars.in_dialogue = false
	player.stop_player()
	SceneTransitions.glitch_change_scene(GlobalVars.flashback_1_2)
	await get_tree().create_timer(3.0).timeout
	player.start_player()
	await get_tree().create_timer(3.0).timeout
	self.queue_free()
