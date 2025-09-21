extends Button

@export var action : String
@export var input_label : Label
var actiondict := {
	"Forward":  [InputEventKey.new()],
	"Right":     [InputEventKey.new()],
	"Left":     [InputEventKey.new()],
	"Back":    [InputEventKey.new()],
	"interact":     [InputEventKey.new()],
	"Phone":     [InputEventKey.new()],
	"jog":     [InputEventKey.new()],
}

func _init():
	toggle_mode = true
	
func _ready():
	set_process_unhandled_input(false)
	actiondict["Forward"][0].physical_keycode = KEY_W
	actiondict["Back"][0].physical_keycode    = KEY_S
	actiondict["Left"][0].physical_keycode    = KEY_A
	actiondict["Right"][0].physical_keycode   = KEY_D
	actiondict["Phone"][0].physical_keycode    = KEY_TAB
	actiondict["interact"][0].physical_keycode    = KEY_E
	actiondict["jog"][0].physical_keycode    = KEY_SHIFT
	
func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		input_label.text = "Awaiting Input"

func _unhandled_input(event):
	if event.pressed:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false
		release_focus()
		update_text()
		accept_event()
		
func update_text():
	input_label.text = InputMap.action_get_events(action)[0].as_text()

func update_text_reset():
	input_label.text = InputMap.action_get_events(action)[0].as_text().trim_suffix(" (Physical)")

func _on_reset_button_pressed() -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, actiondict[action][0])
	update_text_reset()
