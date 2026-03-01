extends CanvasLayer

@export var music_player : AudioStreamPlayer
@export var ending_label : RichTextLabel
@export var icon : TextureRect
@export var dev_team : AnimatedSprite2D
@export var threeDs : AnimatedSprite2D
@export var twoDs : AnimatedSprite2D
@export var writer : AnimatedSprite2D
@export var UI : AnimationPlayer
@export var audio : AnimatedSprite2D
@export var sfx : AnimatedSprite2D
@export var music : AnimationPlayer


@export var layers : Array[Control]
signal oneshot_finished
signal fading(value)
var cur_layer := 0
var in_fade := false:
	set(value):
		in_fade = value
		if in_fade == false:
			fading.emit()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	await get_tree().process_frame
	_show_ending()
	SaveLoad.clearSave(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	GlobalVars.reset_globals()
	await oneshot_finished
	play_oneshot_cred(threeDs, "Spin", 8.0)
	await oneshot_finished
	play_oneshot_cred(twoDs, "Flap", 8.0)
	await oneshot_finished
	play_oneshot_cred(writer, "Map", 8.0)
	await oneshot_finished
	play_oneshot_cred(UI, "Button Movement", 8.0)
	await oneshot_finished
	play_oneshot_cred(audio, "Engine", 6.0)
	await oneshot_finished
	play_oneshot_cred(sfx, "Footsteps", 6.0)
	await oneshot_finished
	play_oneshot_cred(music, "Play", 6.0)
	await oneshot_finished
	play_dev_cred()
	await oneshot_finished
	await get_tree().create_timer(6.0).timeout
	_fade_in_out()
	await get_tree().create_timer(6.5).timeout
	_hide_skip()
	_fade_in_out()
	await music_player.finished
	_fade(layers[cur_layer], 0.0, 2.0)
	await get_tree().create_timer(5.0).timeout
	print("done")
	_end_credits()

func _show_ending():
	_fade(layers[cur_layer], 1.0, 2.0)
	match Dialogic.VAR.get_variable("Endings.Ending_type"):
		"Arrested Skylar":
			ending_label.text = "[center]Bare Minimum[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Minimum.png")
		"Keep Confidential":
			ending_label.text = "[center]Ignorance by Omission[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Ignorance.png")
		"Give Skylar Cure":
			ending_label.text = "[center]In Over Your Head[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Overhead.png")
		"Give Skylar Cure And Choco":
			ending_label.text = "[center]The Storm before the Calm[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Storm.png")
		"Give Kale Cure":
			ending_label.text = "[center]Human Proof[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Human.png")
		"Give Kale Cure And Choco":
			ending_label.text = "[center]Isaac’s Requiem[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Isaac.png")
		"Chief fired":
			ending_label.text = "[center]Lost Cause[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Lost.png")
		"Quincy fired":
			ending_label.text = "[center]Poked the Cat’s Nest[/center]"
			icon.texture = load("res://UI/Assets/Credits/Endings/Poke.png")
		_:
			print_debug("How did this happen")
	await get_tree().create_timer(8.0).timeout
	_fade_in_out()
	emit_signal("oneshot_finished")
	await get_tree().create_timer(1.0).timeout
	skip_anim.play("Pulse")

func play_dev_cred():
	dev_team.play("Beginning")
	await dev_team.animation_finished
	dev_team.play("Loading")
	await dev_team.animation_finished
	dev_team.play("Loading")
	await dev_team.animation_finished
	dev_team.play("Loading")
	await dev_team.animation_finished
	dev_team.play("Ending")
	await dev_team.animation_finished
	_fade_in_out()
	emit_signal("oneshot_finished")


func play_oneshot_cred(sprite, anim : String, time : float = 5.0, delay : bool = false, delay_time : float = 1.0):
	await fading
	sprite.play(anim)
	await get_tree().create_timer(time).timeout
	_fade_in_out()
	emit_signal("oneshot_finished")
	

func _fade_in_out():
	if cur_layer < layers.size():
		in_fade = true
		_fade(layers[cur_layer], 0)
		await get_tree().create_timer(1.0).timeout
		layers[cur_layer].hide()
		cur_layer += 1
		layers[cur_layer].show()
		_fade(layers[cur_layer], 1)
		in_fade = false
	else:
		print("credit end")
		return

func _fade(lay : Control, value : float, time : float = 1.0):
	var tween = create_tween()
	tween.tween_property(lay, "modulate:a", value, time)
	await get_tree().create_timer(time).timeout

@export var skip : TextureRect
@export var skip_anim : AnimationPlayer
@export var timer : Timer
var skip_tween : Tween
var pressed := false
var ending := false
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		if pressed == false and ending == false:
			timer.start()
			pressed = true
			await get_tree().process_frame
			_op_skip()
	if event is InputEventKey and event.is_released() and event.keycode == KEY_SPACE:
		timer.stop()
		pressed = false
		await get_tree().process_frame
		_op_skip()
	
func _on_timer_timeout():
	timer.stop()
	_end_credits()

func _op_skip():
	if pressed == true:
		skip_tween = create_tween()
		skip_anim.pause()
		skip_tween.tween_property(skip, "modulate:a", 1, 3.0)
		await get_tree().process_frame
		skip_anim.stop()
	else:
		#skip.modulate.a = 0
		skip_tween.kill()
		if ending == false:
			skip_anim.play("Pulse")
		else:
			_hide_skip()

func _hide_skip():
	ending = true
	if pressed == false:
		skip_anim.pause()
		create_tween().tween_property(skip, "modulate:a", 0, 0.5)
		
func _end_credits():
	MusicFades.fade_out_audio()
	SceneTransitions.fade_change_scene(GlobalVars.main_menu)
	await get_tree().create_timer(1.0).timeout
	queue_free()
