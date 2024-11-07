extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_firsthouse_button_pressed() -> void:
	get_tree().change_scene_to_file("res://FirstHouse/first_house.tscn")
	pass # Replace with function body.


func _on_secondhouse_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SecondHouse/second_house.tscn")
	pass # Replace with function body.


func _on_thirdhouse_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ThirdHouse/third_house.tscn")
	pass # Replace with function body.
