extends RichTextLabel

@export var in_level : bool 
@export var level_timer : Timer
@export var in_game_time : int
@export var global_timer : Timer

@onready var hour : int = 0
@onready var minute : int = 0
@onready var time : Array[int] = [hour, minute]
#@onready var change : bool
func _ready():
	if in_level == true:
		var level_time_mins = level_timer.wait_time/in_game_time
		global_timer.wait_time = level_time_mins
	else:
		global_timer.wait_time = 60
		global_timer.start()
	await get_tree().process_frame
	start_time()

func start_time():
	match GlobalVars.day:
		1:
			match GlobalVars.current_level:
				"Office":
					if GlobalVars.time == "morning":
						hour = 9
						minute = 0
					else:
						
						hour = 4
						minute = 45
				"micah":
					if Dialogic.VAR.get_variable("Global.first_house") == "Micah":
						hour = 10
						minute = 15
					else:
						hour = 3
						minute = 0
				"juniper":
					if Dialogic.VAR.get_variable("Global.first_house") == "Juniper":
						hour = 10
						minute = 15
					else:
						hour = 3
						minute = 0
		2:
			match GlobalVars.current_level:
				"Office":
					if GlobalVars.time == "morning":
						hour = 9
						minute = 0
					else:
						hour = 4
						minute = 45
				"quincy":
					hour = 11
					minute = 0
		3:
			match GlobalVars.current_level:
				"Office":
					if GlobalVars.time == "morning":
						hour = 9
						minute = 0
					else:
						hour = 3
						minute = 0
				"secret":
					hour = 11
					minute = 45
	set_time(hour, minute)

func set_time(cur_hour : int, cur_minute : int):
	var str_hour = ""
	var str_min = ""
	time = [cur_hour, cur_minute]
	GlobalVars.clock_time = time
	#setting hour
	if cur_hour < 10:
		str_hour = str(time[0]).pad_zeros(2)
	else:
		str_hour = str(time[0])
	#setting minute
	if  cur_minute < 10:
		str_min = str(time[1]).pad_zeros(2)
	else:
		str_min = str(time[1])
	text = str_hour + ":" + str_min


func _on_timer_timeout():
	if minute < 59:
		minute += 1
		set_time(hour, minute)
	else:
		minute = 0
		if hour < 23:
			hour += 1
		else:
			hour = 0
		set_time(hour, minute)

func _level_timer_start():
	global_timer.start()
