extends LookAtModifier3D

var head_jitter := false
var time_passed: float = 0.0
@export var amplitude: float = 0.05  # head rotation 0.05 base
@export var speed: float = 15.0       # oscillations per second 20 base
@export var limit_angle: float = 9.84
@export var character_string := ""
@export var influence_target := 0.493
var activate_look := false

@export var lookat_speed: float = 0.4
@export var lookaway_speed: float = 0.7

func _ready() -> void:
	secondary_limit_angle = limit_angle
	influence = 0 
	active = true
	Dialogic.Text.about_to_show_text.connect(_on_about_to_show_text)
	Dialogic.Text.text_finished.connect(_on_about_to_end_text)

func _on_about_to_show_text(info:Dictionary):
	var character = info.get("character")
	character = str(character)
	character = character.split(":")[0].lstrip("[")
	if character == character_string:
		head_jitter = true
		
func _on_about_to_end_text(info:Dictionary):
	var character = info.get("character")
	var path = character
	var name = path.get_file().get_basename()
	if name == character_string:
		head_jitter = false

func _process(delta: float) -> void:
	if head_jitter:
		time_passed += delta
		var angle: float = sin(time_passed * speed) * amplitude
		# use angle here
		secondary_limit_angle = angle
	else:
		secondary_limit_angle = lerp(secondary_limit_angle, limit_angle, delta * 0.15)

	if activate_look:
		influence = lerp(influence, influence_target, delta * lookat_speed) #lerp to influence
	else:
		influence = lerp(influence, 0.0, delta * lookaway_speed)
		
func _activate_lookAt():
	activate_look = true
	
func _disactivate_lookAt():
	activate_look = false
		
