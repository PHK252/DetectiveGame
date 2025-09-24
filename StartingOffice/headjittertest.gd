extends LookAtModifier3D

var head_jitter := false
var time_passed: float = 0.0
@export var amplitude: float = 0.05  # head rotation 0.05 base
@export var speed: float = 15.0       # oscillations per second 20 base
var activate_look := false


func _ready() -> void:
	secondary_limit_angle = 4.82
	influence = 0
	active = true
	activate_look = false
	Dialogic.Text.about_to_show_text.connect(_on_about_to_show_text)
	Dialogic.Text.text_finished.connect(_on_about_to_end_text)

func _on_about_to_show_text(info:Dictionary):
	var character = info.get("character")
	character = str(character)
	character = character.split(":")[0].lstrip("[")
	if character == "Theo":
		print("TheoSpeaking(Nod)")
		head_jitter = true
		
func _on_about_to_end_text(info:Dictionary):
	var character = info.get("character")
	var path = character
	var name = path.get_file().get_basename()
	if name == "Theo":
		print("TheoDoneSpeaking(StopNod)")
		head_jitter = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		pass
		#head_jitter = true
	if Input.is_action_just_pressed("meeting_done"):
		pass
		#head_jitter = false
	if head_jitter:
		time_passed += delta
		var angle: float = sin(time_passed * speed) * amplitude
		# use angle here
		secondary_limit_angle = angle
	else:
		secondary_limit_angle = lerp(secondary_limit_angle, 4.82, delta * 0.2)

	if activate_look:
		influence = lerp(influence, 1.0, delta * 0.4) #lerp to influence
	else:
		influence = lerp(influence, 0.0, delta * 0.7)

func _on_character_body_3d_look_dalton() -> void:
	activate_look = true
