extends Control

@onready var send = $Send
@onready var delete = $Delete
@onready var subject = $Subject
@onready var message = $Message
@onready var allowed_characters: String = "[a-zA-Z0-9\\.\\?,]+"
var _reg_ex: RegEx = RegEx.new()

signal placeholder

func _on_visibility_changed():
	if visible == true:
		send.disabled = true
		delete.disabled = true
		_reg_ex.compile(allowed_characters)
		subject.text_changed.connect(_on_subject_text_changed)
		emit_signal("placeholder")
	else:
		subject.text_changed.disconnect(_on_subject_text_changed)
func _ready():
	pass
	

func _input(event):
	if subject.text != "" and message.text != "":
		send.disabled = false
		delete.disabled = false
		send.mouse_default_cursor_shape = Control.CursorShape.CURSOR_POINTING_HAND
		delete.mouse_default_cursor_shape = Control.CursorShape.CURSOR_POINTING_HAND
	else:
		send.disabled = true
		delete.disabled = true
		send.mouse_default_cursor_shape = Control.CursorShape.CURSOR_ARROW
		delete.mouse_default_cursor_shape = Control.CursorShape.CURSOR_ARROW

func _on_subject_text_changed(new_text: String) -> void:
	# Remember the position of the caret.
	var caret_column = subject.get_caret_column()
	var caret_position = subject.get_caret_column()
	
	# Filter the new text according to the regular expession.
	var filtered: String = ""
	for result: RegExMatch in _reg_ex.search_all(new_text):
		filtered += result.strings[0]
	
	# If anything was filtered, restore the caret position accordingly.
	if filtered != new_text:
		subject.text = filtered
		caret_column = caret_position - (new_text.length() - filtered.length())
		subject.set_caret_column(caret_column)

func _on_message_text_changed() -> void:
	# Remember the position of the caret.
	var caret_column = message.get_caret_column()
	var caret_position = message.get_caret_column()
	var new_text = message.text
	# Filter the new text according to the regular expession.
	var filtered: String = ""
	for result: RegExMatch in _reg_ex.search_all(new_text):
		filtered += result.strings[0]
	
	# If anything was filtered, restore the caret position accordingly.
	if filtered != new_text:
		message.text = filtered
		caret_column = caret_position - (new_text.length() - filtered.length())
		message.set_caret_column(caret_column)


func _on_clear_text():
	subject.text = "" 
	message.text = ""
	subject.release_focus()
	message.release_focus()
