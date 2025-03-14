extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Home/Dropdown.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_icon_toggled(toggled_on):
	if toggled_on == true:
		$Home/Dropdown.show()
	else:
		$Home/Dropdown.hide()
