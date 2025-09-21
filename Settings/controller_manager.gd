extends Node

signal ControllerConnected(deviceId)
signal ControllerDisconnected(deviceId)

var connected_controllers = {}
var activeController = -1

@export var analogDeadzone = 0.2

func _ready() -> void:
	for deviceID in Input.get_connected_joypads():
		registerController(deviceID)
	Input.joy_connection_changed.connect(onJoyConnectionChanged)

func _process(delta: float) -> void:
	pass
	
func registerController(id):
	var controllerName = Input.get_joy_name(id)
	connected_controllers [id] = {
		"name" : controllerName,
		"guid" : Input.get_joy_guid(id)
	}
	if activeController == -1:
		activeController = id
	
	ControllerConnected.emit(id)
	

func deregisterController(id):
	if connected_controllers.has(id):
		var controllerName = connected_controllers[id].name
		connected_controllers.erase(id)
		
		if activeController == id:
			activeController = -1
			if not connected_controllers.is_empty():
				activeController = connected_controllers.keys()[0]
		ControllerDisconnected.emit(id)	
			
	
func onJoyConnectionChanged(id, connected):
	if connected:
		registerController(id)
	else:
		deregisterController(id)
		

func GetControllerList():
	return connected_controllers

func GetActiveController():
	return activeController
	
func SetActiveController(id):
	if connected_controllers.has(id):
		activeController = id
		return true
	return false
	
func GetControllerStickInput(deviceid = -1, leftstick = true):
	if deviceid == -1:
		print("gotController")
		deviceid = activeController
	if deviceid == -1 or not connected_controllers.has(deviceid):
		return Vector2.ZERO
		
	var xAxies = JOY_AXIS_LEFT_X if leftstick else JOY_AXIS_RIGHT_X
	var yAxies = JOY_AXIS_LEFT_Y if leftstick else JOY_AXIS_RIGHT_Y
	
	var inputVector = Vector2(
		Input.get_joy_axis(deviceid, xAxies), 
		Input.get_joy_axis(deviceid, yAxies)
		)
	
	if inputVector.length() < analogDeadzone:
		print("ret0")
		return Vector2.ZERO
	
	print("retvec")
	return inputVector
	
func isControllerButtonPressed(button, deviceid):
	if deviceid == -1:
		deviceid = activeController
	if deviceid == -1 or not connected_controllers.has(deviceid):
		return false
	
	print("retbutton")
	return Input.is_joy_button_pressed(deviceid, button)

func RumbleController(intensity : float = 0.5, duration : float = 0.2, deviceid = -1):
	if deviceid == -1:
		deviceid = activeController
	if deviceid == -1 or not connected_controllers.has(deviceid):
		return 
	Input.start_joy_vibration(deviceid,intensity,intensity, duration)
