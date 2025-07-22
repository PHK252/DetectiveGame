extends Control

@export var scroll_container : ScrollContainer
@export var line_edit : LineEdit
@export var messages : Control
@export var error : Control
@export var shift_key : TextureButton
@export var messages_arr : Array[Button]
@export var home : Control
@export var back_screen: Control

@onready var focus_index : int
@onready var shift = false
@onready var max_scroll = scroll_container.get_v_scroll_bar().max_value
@onready var allowed_characters: String = "[a-zA-Z0-9\\.\\?,]+"
@onready var caret_column = 0
var _reg_ex: RegEx = RegEx.new()
var _v_scroll: VScrollBar

func _ready():
	_reg_ex.compile(allowed_characters)
	line_edit.text_changed.connect(_on_text_changed)
	scroll_container.call_deferred("set_v_scroll", max_scroll)
	_v_scroll = scroll_container.get_node("_v_scroll")
	
func _button_press(key :String):
	if messages.visible == true:
		if caret_column < line_edit.text.length():
			line_edit.text = line_edit.text.insert(caret_column, key)
		else:
			line_edit.text = line_edit.text + key
		await get_tree().process_frame
		line_edit.grab_focus()
		if focus_index != 0:
			focus_index = 0
			line_edit.caret_force_displayed = true
		line_edit.set_caret_column(caret_column + 1)
		caret_column = line_edit.get_caret_column()
		line_edit.release_focus()
		
func _num_press(key :String):
	if shift == true:
		shift_key.button_pressed = false
		shift = false
		_button_press(key)
	else:
		_button_press(key)

func _letter_press(cap_key :String, key :String):
	if shift == true:
		_button_press(cap_key)
		shift_key.button_pressed = false
		shift = false
	else:
		_button_press(key)

func _on_shift_toggled(toggled_on):
	if messages.visible == true:
		if toggled_on == true:
			shift = true
		else:
			shift = false

func _on_text_changed(new_text: String) -> void:
	# Remember the position of the caret.
	var caret_position: int = caret_column
	
	# Filter the new text according to the regular expession.
	var filtered: String = ""
	for result: RegExMatch in _reg_ex.search_all(new_text):
		filtered += result.strings[0]
	
	# If anything was filtered, restore the caret position accordingly.
	if filtered != new_text:
		line_edit.text = filtered
		caret_column = caret_position - (new_text.length() - filtered.length())
		line_edit.set_caret_column(caret_column)

func _on_zero_pressed():
	_num_press("0")

func _on_one_pressed():
	_num_press("1")

func _on_two_pressed():
	_num_press("2")

func _on_three_pressed():
	_num_press("3")

func _on_four_pressed():
	_num_press("4")

func _on_five_pressed():
	_num_press("5")
	
func _on_six_pressed():
	_num_press("6")

func _on_seven_pressed():
	_num_press("7")

func _on_eight_pressed():
	_num_press("8")

func _on_nine_pressed():
	_num_press("9")

func _on_comma_pressed():
	_num_press(",")

func _on_question_pressed():
	_button_press("?")
	if Input.is_action_just_pressed("Question") == true and shift == true:
		shift_key.button_pressed = false
		shift = false

func _on_period_pressed():
	_num_press(".")

func _on_space_pressed():
	_num_press(" ")

func _on_q_pressed():
	_letter_press("Q", "q")

func _on_w_pressed():
	_letter_press("W", "w")

func _on_e_pressed():
	_letter_press("E", "e")

func _on_r_pressed():
	_letter_press("R", "r")

func _on_t_pressed():
	_letter_press("T", "t")

func _on_y_pressed():
	_letter_press("Y", "y")

func _on_u_pressed():
	_letter_press("U", "u")

func _on_i_pressed():
	_letter_press("I", "i")

func _on_o_pressed():
	_letter_press("O", "o")

func _on_p_pressed():
	_letter_press("P", "p")

func _on_a_pressed():
	_letter_press("A", "a")

func _on_s_pressed():
	_letter_press("S", "s")

func _on_d_pressed():
	_letter_press("D", "d")

func _on_f_pressed():
	_letter_press("F", "f")

func _on_g_pressed():
	_letter_press("G", "g")

func _on_h_pressed():
	_letter_press("H", "h")

func _on_j_pressed():
	_letter_press("J", "j")

func _on_k_pressed():
	_letter_press("K", "k")

func _on_l_pressed():
	_letter_press("L", "l")

func _on_z_pressed():
	_letter_press("Z", "z")

func _on_x_pressed():
	_letter_press("X", "x")

func _on_c_pressed():
	_letter_press("C", "c")

func _on_v_pressed():
	_letter_press("V", "v")

func _on_b_pressed():
	_letter_press("B", "b")

func _on_n_pressed():
	_letter_press("N", "n")

func _on_m_pressed():
	_letter_press("M", "m")

func _on_backspace_pressed():
	if messages.visible == true:
		if len(line_edit.text) > 0 and caret_column > 0:
			if focus_index != 0:
				messages_arr[focus_index - 1].release_focus()
				focus_index = 0
				line_edit.caret_force_displayed = true
				caret_column = line_edit.text.length()
				line_edit.set_caret_column(caret_column)
			line_edit.text = line_edit.text.erase(caret_column - 1, 1)
			line_edit.set_caret_column(caret_column - 1)
			caret_column = line_edit.get_caret_column()

func _on_right_pressed():
	if messages.visible == true:
		if caret_column < len(line_edit.text):
			caret_column += 1
			line_edit.set_caret_column(caret_column)
		elif caret_column == len(line_edit.text):
			caret_column = line_edit.get_caret_column()

func _on_left_pressed():
	if messages.visible == true:
		if caret_column > 0:
			caret_column -= 1
			line_edit.set_caret_column(caret_column)
		elif caret_column == 0:
			caret_column = line_edit.get_caret_column()

func _on_down_pressed():
	if messages.visible == true:
		if focus_index > 0:
			focus_index -= 1
		else:
			focus_index = 0 
		if focus_index == 0:
			line_edit.grab_focus()
			line_edit.caret_force_displayed = true
			caret_column = line_edit.text.length()
			line_edit.set_caret_column(caret_column)
			line_edit.release_focus()
		else:
			line_edit.caret_force_displayed = false
			messages_arr[focus_index - 1].grab_focus()

func _on_up_pressed():
	if messages.visible == true:
		if focus_index < 16:
			focus_index += 1
		if focus_index == 0:
			line_edit.grab_focus()
			line_edit.caret_force_displayed = true
			caret_column = line_edit.text.length()
			line_edit.set_caret_column(caret_column)
			line_edit.release_focus()
		else:
			line_edit.caret_force_displayed = false
			messages_arr[focus_index - 1].grab_focus()


func _on_check_pressed():
	if messages.visible == true:
		_error()

func _on_enter_pressed():
	if messages.visible == true:
		_error()

func _input(event: InputEvent) -> void:
	if messages.visible == true:
		if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_WHEEL_DOWN || event.button_index == MOUSE_BUTTON_WHEEL_UP):
			_v_scroll.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

func _error():
	if line_edit.text != "":
		messages.visible = false
		error.visible = true
		await get_tree().create_timer(2.5).timeout
		scroll_container.call_deferred("set_v_scroll", max_scroll)
		line_edit.text = ""
		caret_column = 0
		messages.visible = true
		error.visible = false

func _on_home_pressed():
	if messages.visible == true:
		messages.visible = false
		home.visible = true



func _on_back_pressed():
	if messages.visible == true:
		messages.visible = false
		back_screen.visible = true



func _on_pager_messages_default():
	scroll_container.call_deferred("set_v_scroll", max_scroll)
	line_edit.text = ""
	caret_column = 0
