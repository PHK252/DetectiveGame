extends Interactor

@export var player: CharacterBody3D
@onready var highlight = $CollisionShape3D/Alert
@onready var animplay = $CollisionShape3D/AnimationPlayer
var cached_closest: Interactable
signal interacted_now

func _ready() -> void:
	controller = player

func _physics_process(_delta: float) -> void:
	var new_closest: Interactable = get_closest_interactable()
	if new_closest != cached_closest:
		if is_instance_valid(cached_closest):
			unfocus(cached_closest)
			highlight.hide()
			animplay.play("RESET")
		if new_closest:
			focus(new_closest)
			highlight.show()
			if GlobalVars.current_level == "Office":
				animplay.play("Alert_Animation_Office")
				#print("office_interact")
			elif GlobalVars.current_level == "micah":
				animplay.play("Alert_Animation_Micah")
			elif GlobalVars.current_level == "juniper":
				animplay.play("Alert_Animation_Juniper")
			elif GlobalVars.current_level == "quincy":
				animplay.play("Alert_Animation_Quincy")
			elif GlobalVars.current_level == "Beginning" or GlobalVars.current_level == "secret" or GlobalVars.current_level == "Transition" or GlobalVars.current_level == "Give Cure":
				animplay.play("Alert_Animation_Beginning")
		cached_closest = new_closest

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if is_instance_valid(cached_closest):
			interact(cached_closest)
			emit_signal("interacted_now")

func _on_area_exited(area: Interactable) -> void:
	if cached_closest == area:
		unfocus(area)
