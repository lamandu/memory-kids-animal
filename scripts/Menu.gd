extends Control

var _diff_buttons: Dictionary = {}

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()

func _build_ui() -> void:
	# Background
	var bg := ColorRect.new()
	bg.color = Color(0.12, 0.64, 0.89, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# Centered VBox
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.offset_left   =  60
	vbox.offset_right  = -60
	vbox.offset_top    =  60
	vbox.offset_bottom = -60
	vbox.add_theme_constant_override("separation", 28)
	add_child(vbox)

	# Title icon + text
	var icon_lbl := Label.new()
	icon_lbl.text                   = "🐾"
	icon_lbl.horizontal_alignment   = HORIZONTAL_ALIGNMENT_CENTER
	icon_lbl.add_theme_font_size_override("font_size", 90)
	vbox.add_child(icon_lbl)

	var title := Label.new()
	title.text                 = "Memory Animais"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 40)
	vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text                 = "Encontre os pares!"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 22)
	subtitle.modulate             = Color(1, 1, 1, 0.80)
	vbox.add_child(subtitle)

	# Spacer
	var sp1 := Control.new()
	sp1.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(sp1)

	# Difficulty label
	var diff_lbl := Label.new()
	diff_lbl.text                 = "Dificuldade:"
	diff_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	diff_lbl.add_theme_font_size_override("font_size", 22)
	vbox.add_child(diff_lbl)

	# Difficulty row
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 18)
	vbox.add_child(hbox)

	for key in ["easy", "medium", "hard"]:
		var btn := Button.new()
		btn.text                = Global.DIFFICULTIES[key]["label"]
		btn.custom_minimum_size = Vector2(130, 64)
		btn.toggle_mode         = true
		btn.button_pressed      = (key == Global.current_difficulty)
		btn.add_theme_font_size_override("font_size", 20)
		btn.pressed.connect(_on_diff_pressed.bind(key))
		hbox.add_child(btn)
		_diff_buttons[key] = btn

	# Spacer
	var sp2 := Control.new()
	sp2.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(sp2)

	# Play button
	var play_btn := Button.new()
	play_btn.text                = "▶   JOGAR!"
	play_btn.custom_minimum_size = Vector2(270, 85)
	play_btn.add_theme_font_size_override("font_size", 30)
	play_btn.pressed.connect(_on_play_pressed)
	vbox.add_child(play_btn)

func _on_diff_pressed(key: String) -> void:
	Global.current_difficulty = key
	for k in _diff_buttons:
		_diff_buttons[k].button_pressed = (k == key)

func _on_play_pressed() -> void:
	Global.go_to("res://scenes/Game.tscn")
