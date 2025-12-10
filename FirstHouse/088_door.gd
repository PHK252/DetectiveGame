extends MeshInstance3D

@export var dialogue_file: String
@export var player: CharacterBody3D
@export var alert : Sprite3D
@export var interactable : Interactable
var knock_count = 0

func _on_interactable_interacted(interactor):
	player.stop_player()
	alert.hide()
	#Knock anim
	knock_count +=1
	if knock_count < 2:
		await get_tree().create_timer(1.0)
		player.start_player()
		return
	Dialogic.start(dialogue_file)
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	player.start_player()
	if knock_count != 5:
		interactable.set_deferred("monitorable", false)
