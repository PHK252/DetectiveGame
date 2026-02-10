extends CanvasLayer

@onready var fade = $Fade
@onready var glitch = $Glitch
@onready var glitch_shader = $ColorRect2
@onready var color_rect = $ColorRect
@onready var sf_xs = $SFXs


func fade_change_packed_scene(target : PackedScene):
	#await get_tree().create_timer(.5)
	fade.play("Dissolve")
	await fade.animation_finished
	get_tree().change_scene_to_packed(target)
	print("load packed")
	fade.play_backwards("Dissolve")


func fade_change_scene(target : String):
	print(fade)
	fade.play("Dissolve")
	await fade.animation_finished
	get_tree().change_scene_to_file(target)
	fade.play_backwards("Dissolve")

func fade_to_load():
	print("fade")
	fade.play("Dissolve")
	await fade.animation_finished
	fade.play_backwards("Dissolve")
	print("fade_end")

func glitch_change_packed_scene(target : PackedScene):
	#await get_tree().create_timer(.5)
	sf_xs.play()
	glitch_shader.show()
	glitch.play("Glitch")
	await glitch.animation_finished
	get_tree().change_scene_to_packed(target)
	print("load packed")
	sf_xs.play()
	glitch.play_backwards("Glitch")
	await glitch.animation_finished
	glitch_shader.hide()

func glitch_to_load():
	sf_xs.play()
	glitch_shader.show()
	glitch.play("Glitch")
	await glitch.animation_finished
	#glitch.play_backwards("Glitch")
	#await glitch.animation_finished
	glitch_shader.hide()
	color_rect.hide()

func glitch_to_load_back():
	sf_xs.play()
	glitch_shader.show()
	glitch.play_backwards("Glitch")
	await glitch.animation_finished
	#glitch.play_backwards("Glitch")
	#await glitch.animation_finished
	glitch_shader.hide()
	color_rect.hide()

func glitch_change_scene(target : String):
	sf_xs.play()
	glitch_shader.show()
	glitch.play("Glitch")
	await glitch.animation_finished
	get_tree().change_scene_to_file(target)
	await get_tree().create_timer(1.0).timeout
	sf_xs.play()
	glitch.play_backwards("Glitch")
	await glitch.animation_finished
	glitch_shader.hide()
