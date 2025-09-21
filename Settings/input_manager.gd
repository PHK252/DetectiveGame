extends Node
class_name InputManager

# reasons useful:
# customizable UI elements (signal icons when controller in use)
# rumble control
# analog dead zone control on controller for movement
# possibly makes easier to use controller for cursor
#can pare down thse scripts to just detect each state

enum InputSource {KEYBOARD, CONTROLLER}

var activeInputSource = InputSource.KEYBOARD

signal InputSourceChanged(source)
@onready var controllerManager = $ControllerManager

func _ready() -> void:
	controllerManager.ControllerConnected.connect(onControllerConnected)
	controllerManager.ControllerDisconnected.connect(onControllerDisconnected)

#func _physics_process(delta: float) -> void:
	#GetMovementVector()
	#GetActionPressed("interact")

func detectInitialInputSource():
	if controllerManager.activeController != -1:
		print("usingkeyboard")
		setInputSource(InputSource.KEYBOARD)
	else:
		print("usingController")
		setInputSource(InputSource.CONTROLLER)

func GetMovementVector():
	if activeInputSource == InputSource.KEYBOARD:
		print("getting movement (keys)")
		return Input.get_vector("Right", "Left", "Back", "Forward")
	if activeInputSource == InputSource.CONTROLLER:
		print("getting movement (controller)")
		return controllerManager.GetControllerStickInput()
	return Vector2.ZERO 

func GetActionPressed(action_name):
	print("successful")
	return Input.is_action_pressed(action_name)
	
#detect what device used
func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouse:
		setInputSource(InputSource.KEYBOARD)
	elif event is InputEventJoypadButton:
		setInputSource(InputSource.CONTROLLER)
	elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.2:#should be deadzoneval:
		setInputSource(InputSource.CONTROLLER)
	
func setInputSource(source):
	if activeInputSource != source:
		activeInputSource = source
		print("input changed to ", source)
		InputSourceChanged.emit(source)
		
func onControllerConnected(id):
	print("usingController")
	setInputSource(InputSource.CONTROLLER)
	
func onControllerDisconnected(id):
	print("usingKeys")
	setInputSource(InputSource.KEYBOARD)
	
func RumbleController(intensity = 0.5, duration = 0.5, id = -1):
	if activeInputSource == InputSource.CONTROLLER:
		controllerManager.RumbleController(intensity, duration, id)
