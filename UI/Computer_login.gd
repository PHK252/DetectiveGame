extends Control


@onready var enter = $Enter
@onready var password = $Pass
@onready var allowed_characters: String = "[a-zA-Z0-9\\.\\?,]+"
var _reg_ex: RegEx = RegEx.new()

func _ready():
	enter.disabled = true
	_reg_ex.compile(allowed_characters)
	password.text_changed.connect(_on_text_changed)
	#message.text_changed.connect(_on_message_text_changed)

func _input(event):
	if password.text != "":
		enter.disabled = false
		enter.mouse_default_cursor_shape = Control.CursorShape.CURSOR_POINTING_HAND
	else:
		enter.disabled = true
		enter.mouse_default_cursor_shape = Control.CursorShape.CURSOR_ARROW

func _on_text_changed(new_text: String) -> void:
	# Remember the position of the caret.
	var caret_column = password.get_caret_column()
	var caret_position = password.get_caret_column()
	
	# Filter the new text according to the regular expession.
	var filtered: String = ""
	for result: RegExMatch in _reg_ex.search_all(new_text):
		filtered += result.strings[0]
	
	# If anything was filtered, restore the caret position accordingly.
	if filtered != new_text:
		password.text = filtered
		caret_column = caret_position - (new_text.length() - filtered.length())
		password.set_caret_column(caret_column)


func _on_clear_text():
	password.text = "" 
