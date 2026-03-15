extends TextureRect

@export var emo_array : Array[String]
@export var character: String
@export var low : int
@export var high : int
@export var  note_screen : Node
 
func _on_notes_vis_change():
	if note_screen.visible:
		var aff_points = Dialogic.VAR.get_variable(character)
		#happy
		if aff_points >= high:
			texture = load(emo_array[0])
		#Sad
		elif aff_points <= low:
			texture = load(emo_array[2])
		#Neutral
		else:
			texture = load(emo_array[1])
