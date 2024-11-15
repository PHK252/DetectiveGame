extends CanvasLayer

@onready var pos1 = $Pos1
@onready var pos2 = $Pos2
@onready var pos3 = $Pos3
@onready var pos4 = $Pos4
@onready var pos5 = $Pos5
@onready var pos6 = $Pos6

@onready var posClick = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	posChange()


func _input(event):
	if Input.is_action_just_pressed("case_right"):
		if posClick < 5:
			posClick = posClick + 1 
		else:
			posClick = 0
		posChange()
	
	if Input.is_action_just_pressed("case_left"):
		if posClick > 0:
			posClick = posClick - 1
		else:
			posClick = 5
		posChange()

func posChange():
	if posClick == 0:
		pos1.showArrows()
		pos2.hideArrows()
		pos3.hideArrows()
		pos4.hideArrows()
		pos5.hideArrows()
		pos6.hideArrows()
	elif posClick == 1:
		pos1.hideArrows()
		pos2.showArrows()
		pos3.hideArrows()
		pos4.hideArrows()
		pos5.hideArrows()
		pos6.hideArrows()
	elif posClick == 2:
		pos1.hideArrows()
		pos2.hideArrows()
		pos3.showArrows()
		pos4.hideArrows()
		pos5.hideArrows()
		pos6.hideArrows()
	elif posClick == 3:
		pos1.hideArrows()
		pos2.hideArrows()
		pos3.hideArrows()
		pos4.showArrows()
		pos5.hideArrows()
		pos6.hideArrows()
	elif posClick == 4:
		pos1.hideArrows()
		pos2.hideArrows()
		pos3.hideArrows()
		pos4.hideArrows()
		pos5.showArrows()
		pos6.hideArrows()
	elif posClick == 5:
		pos1.hideArrows()
		pos2.hideArrows()
		pos3.hideArrows()
		pos4.hideArrows()
		pos5.hideArrows()
		pos6.showArrows()
