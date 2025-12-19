extends MeshInstance3D

@export var dialogue_file: String
@export var player: CharacterBody3D
@export var alert : Sprite3D
@export var interactable : Interactable
var knock_count = 0
var in_knock = false

func _on_interactable_interacted(interactor):
	if in_knock == false:
		in_knock = true
		player.stop_player()
		alert.hide()
		knock_count +=1
		if knock_count < 3:
			Dialogic.start(dialogue_file, "knock")
			Dialogic.timeline_ended.connect(_on_timeline_ended)
			return
		Dialogic.start(dialogue_file, "reply")
		Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_timeline_ended():
	print(knock_count)
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	in_knock = false
	player.start_player()
	if knock_count == 5:
		interactable.queue_free()
		return
	alert.show()
