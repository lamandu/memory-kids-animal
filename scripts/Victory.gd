extends Control

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_animate_stars.call_deferred()

func _build_ui() -> void:
	# Background
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.52, 0.78, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# Main VBox
	var vbox := VBoxContainer.new()
	vbox.name = "VBox"
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.offset_left   =  50
	vbox.offset_right  = -50
	vbox.offset_top    =  80
	vbox.offset_bottom = -60
	vbox.add_theme_constant_override("separation", 30)
	add_child(vbox)

	# Title
	var title := Label.new()
	title.text                 = "🎉 Parabéns!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	vbox.add_child(title)

	# Stars row
	var stars_box := HBoxContainer.new()
	stars_box.name      = "StarsRow"
	stars_box.alignment = BoxContainer.ALIGNMENT_CENTER
	stars_box.add_theme_constant_override("separation", 24)
	vbox.add_child(stars_box)

	for i in 3:
		var star := Label.new()
		star.name                = "Star%d" % i
		star.text                = "⭐"
		star.modulate            = Color(0.35, 0.35, 0.35, 1.0)
		star.add_theme_font_size_override("font_size", 72)
		stars_box.add_child(star)

	# Attempts
	var att_lbl := Label.new()
	att_lbl.text                 = "Tentativas: %d" % Global.attempts
	att_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	att_lbl.add_theme_font_size_override("font_size", 28)
	vbox.add_child(att_lbl)

	# Flexible spacer
	var sp := Control.new()
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(sp)

	# Play again
	var play_btn := Button.new()
	play_btn.text                = "🔄  Jogar Novamente"
	play_btn.custom_minimum_size = Vector2(290, 80)
	play_btn.add_theme_font_size_override("font_size", 26)
	play_btn.pressed.connect(_on_play_again)
	vbox.add_child(play_btn)

	# Menu
	var menu_btn := Button.new()
	menu_btn.text                = "🏠  Menu Principal"
	menu_btn.custom_minimum_size = Vector2(290, 80)
	menu_btn.add_theme_font_size_override("font_size", 26)
	menu_btn.pressed.connect(_on_menu)
	vbox.add_child(menu_btn)

func _animate_stars() -> void:
	var stars_row := get_node_or_null("VBox/StarsRow")
	if not stars_row:
		return
	for i in Global.stars_earned:
		var star := stars_row.get_node_or_null("Star%d" % i)
		if not star:
			continue
		await get_tree().create_timer(0.35).timeout
		var t1 := create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
		t1.tween_property(star, "modulate", Color(1.0, 0.85, 0.0, 1.0), 0.25)
		t1.tween_property(star, "scale",    Vector2(1.35, 1.35),         0.20)
		await t1.finished
		var t2 := create_tween()
		t2.tween_property(star, "scale", Vector2(1.0, 1.0), 0.12)

func _on_play_again() -> void:
	Global.go_to("res://scenes/Game.tscn")

func _on_menu() -> void:
	Global.go_to("res://scenes/Menu.tscn")
