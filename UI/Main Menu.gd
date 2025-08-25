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
	Loading.load_scene(self, "res://StartingOffice/starting_office.tscn", false, "", "")
