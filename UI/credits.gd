extends CanvasLayer

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

var cur_layer := 0
func _ready():
	#SaveLoad.clearSave(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	#GlobalVars.reset_globals()
	_show_ending()
	play_dev_cred()
	play_oneshot_cred(threeDs, "Spin")
	play_oneshot_cred(twoDs, "Flap")
	play_oneshot_cred(writer, "Writing", 10.0)
	play_oneshot_cred(UI, "Button Movement", 7.0)
	play_oneshot_cred(audio, "Engine", 5.0, true)
	play_oneshot_cred(sfx, "Footsteps")
	play_oneshot_cred(music, "Play", 6.0)
	
	#SaveLoad.clearSave(SaveLoad.SAVE_DIR + SaveLoad.SAVE_FILE_NAME)
	#GlobalVars.reset_globals()
	#get_tree().quit()

func _show_ending():
	_fade(layers[cur_layer], 1)
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
	await get_tree().create_timer(5.0).timeout
	_fade_in_out()

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



func play_oneshot_cred(sprite, anim : String, time : float = 5.0, delay : bool = false, delay_time : float = 1.0):
	if delay:
		await get_tree().create_timer(delay_time).timeout
	sprite.play(anim)
	await get_tree().create_timer(time).timeout
	#_fade_in_out()
	sprite.stop()

func _fade_in_out():
	if cur_layer < layers.size():
		_fade(layers[cur_layer], 0)
		await get_tree().create_timer(0.5).timeout
		layers[cur_layer].hide()
		cur_layer += 1
		layers[cur_layer].show()
		_fade(layers[cur_layer], 1)
	else:
		print("credit end")
		return

func _fade(lay : Control, value : float):
	var tween = create_tween()
	tween.tween_property(lay, "modulate:a", value, 0.5)
	await get_tree().create_timer(0.5).timeout
