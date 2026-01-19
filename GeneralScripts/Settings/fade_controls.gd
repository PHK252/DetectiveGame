extends Node

var music_index = AudioServer.get_bus_index("Music") #case sensitive
var effect = AudioServer.get_bus_effect(music_index, 1) #amplify effect
var fading_in := false
var fading_out := false

@export var fade_speed := 15.0
var silence := -80.0
var ceiling := 0.0
var break_time := false
var in_out_needed := false

@export var fade_time_break := 0.1 #how long we want silence in between music
@export var fade_time_break_timer : Timer 

func _ready() -> void:
	effect.volume_db = ceiling 
	fade_time_break_timer.wait_time = fade_time_break

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("call"):
		#fade_in_out()
		#testing
	if break_time:
		fade_time_break_timer.start()
		break_time = false
		in_out_needed = false
		
	if fading_in:
		if effect.volume_db <= ceiling:
			effect.volume_db += fade_speed * delta
			print(effect.volume_db)
		else:
			fading_in = false
			print("fade_in_finished")
	
	if fading_out: #use to fade_back in after
		if effect.volume_db >= silence:
			effect.volume_db -= fade_speed * delta
		else:
			fading_out = false
			print("fade_out_finished")
			if in_out_needed:
				break_time = true

func fade_in_audio():
	fading_in = true
	fading_out = false
	
func fade_out_audio():
	fading_in = false
	fading_out = true
	
func fade_in_out():
	in_out_needed = true
	fade_out_audio()
	
func _on_fade_music_timer_timeout() -> void:
	fade_in_audio()
