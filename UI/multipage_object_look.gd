extends CanvasLayer

@onready var pages = [$Page1, $Page2, $Page3, $Page4, $Page5]
@onready var pCount = 0
@export var pageCount = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	pages[pCount].show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_forward_pressed():
	#turnPageForward(5)
	
	if pCount == pageCount - 1:
		pCount = 0
		pages[pageCount-1].hide()
	else:
		pCount += 1
		pages[pCount - 1].hide()
	pages[pCount].show()
	#print(pCount)

func _on_back_pressed():
	if pCount == 0:
		pCount = pageCount - 1
		pages[0].hide()
	else:
		pCount -= 1
		pages[pCount + 1].hide()
	pages[pCount].show()
	#print(pCount)



func _on_exit_pressed():
	$".".hide()
	GlobalVars.in_look_screen = false
	GlobalVars.viewing = ""

func _input(event):
	if Input.is_action_just_pressed("Exit"):
		$".".hide()
		GlobalVars.in_look_screen = false
		await get_tree().create_timer(.3).timeout
		GlobalVars.viewing = ""

	
