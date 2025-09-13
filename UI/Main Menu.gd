extends Node2D

@onready var start_butt = $Start
@onready var continue_butt = $Continue

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVars.current_level == "":
		start_butt.show()
		continue_butt.hide()
	else:
		start_butt.hide()
		continue_butt.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	#SceneTransitions.glitch_change_scene("res://StartingOffice/starting_office.tscn")
	#LoadManager.load_scene(GlobalVars.first_house_path)
	#Loading.load_scene(self, GlobalVars.first_house_path, true, "morning", "yes_diner")
	Loading.load_scene(self, GlobalVars.beginning_office, false, "", "")


func _on_continue_pressed():
	Loading.load_scene(self, GlobalVars.beginning_office, false, "", "")
