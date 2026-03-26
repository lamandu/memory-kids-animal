extends Control

var _diff_buttons: Dictionary = {}
var _font: Font = preload("res://assets/fonts/WhaleITried.ttf")

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	AudioManager.play_music("res://assets/audio/bg-sound.mp3", 0.3)

func _build_ui() -> void:
	# Background
	var bg := TextureRect.new()
	bg.texture = load("res://assets/ui/bg_cloulds.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.set_anchor_and_offset(SIDE_LEFT,   0,  40)
	vbox.set_anchor_and_offset(SIDE_RIGHT,  1, -40)
	vbox.set_anchor_and_offset(SIDE_TOP,    0,  40)
	vbox.set_anchor_and_offset(SIDE_BOTTOM, 1, -40)
	vbox.add_theme_constant_override("separation", 20)
	add_child(vbox)

	# Logo
	var logo := TextureRect.new()
	if ResourceLoader.exists("res://assets/ui/memorykids.png"):
		logo.texture = load("res://assets/ui/memorykids.png")
	logo.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	logo.custom_minimum_size = Vector2(0, 180)
	vbox.add_child(logo)

	# Difficulty Grid
	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	grid.add_theme_constant_override("h_separation", 24)
	grid.add_theme_constant_override("v_separation", 24)
	vbox.add_child(grid)

	var lock_tex: Texture2D = null
	if ResourceLoader.exists("res://assets/ui/locker.png"):
		lock_tex = load("res://assets/ui/locker.png")

	for key in Global.DIFFICULTIES.keys():
		var unlocked := Global.is_level_unlocked(key)
		var num: String = key.split("_")[1]

		# ── Wrapper (fixed size so children can fill it) ──
		var wrapper := Control.new()
		wrapper.custom_minimum_size = Vector2(155, 155)
		grid.add_child(wrapper)

		# Level-number image
		var btn := TextureButton.new()
		var num_tex: Texture2D = null
		if ResourceLoader.exists("res://assets/ui/levels/number_%s.png" % num):
			num_tex = load("res://assets/ui/levels/number_%s.png" % num)
		if num_tex:
			btn.texture_normal = num_tex
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.set_anchors_preset(Control.PRESET_FULL_RECT)
		btn.disabled = not unlocked
		if unlocked:
			btn.pressed.connect(_on_diff_pressed.bind(key))
		wrapper.add_child(btn)
		_diff_buttons[key] = {"btn": btn, "wrapper": wrapper}

		# Selection glow
		var indicator := ColorRect.new()
		indicator.name = "Indicator"
		indicator.color = Color(1, 1, 0, 0.4)
		indicator.set_anchors_preset(Control.PRESET_FULL_RECT)
		indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
		indicator.visible = (key == Global.current_difficulty) and unlocked
		wrapper.add_child(indicator)

		if not unlocked:
			# Dark overlay  (full rect — works correctly)
			var dim := ColorRect.new()
			dim.color = Color(0, 0, 0, 0.65)
			dim.set_anchors_preset(Control.PRESET_FULL_RECT)
			dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
			wrapper.add_child(dim)

			# Lock icon  (full rect + aspect-centered = auto-centers the image)
			if lock_tex:
				var lock_img := TextureRect.new()
				lock_img.texture      = lock_tex
				lock_img.expand_mode  = TextureRect.EXPAND_IGNORE_SIZE
				lock_img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				lock_img.set_anchors_preset(Control.PRESET_FULL_RECT)
				lock_img.mouse_filter = Control.MOUSE_FILTER_IGNORE
				wrapper.add_child(lock_img)

	# Spacer
	var sp := Control.new()
	sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(sp)

	# Bottom row
	var btn_hbox := HBoxContainer.new()
	btn_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_hbox.add_theme_constant_override("separation", 30)
	vbox.add_child(btn_hbox)

	var play_btn := Button.new()
	play_btn.text = " START "
	play_btn.custom_minimum_size = Vector2(240, 90)
	play_btn.add_theme_font_override("font", _font)
	play_btn.add_theme_font_size_override("font_size", 44)
	play_btn.pressed.connect(_on_play_pressed)
	btn_hbox.add_child(play_btn)

	if Global.medals_unlocked > 0:
		var rewards_btn := Button.new()
		rewards_btn.text = " 🏆 "
		rewards_btn.custom_minimum_size = Vector2(90, 90)
		rewards_btn.add_theme_font_size_override("font_size", 40)
		rewards_btn.pressed.connect(_on_rewards_pressed)
		btn_hbox.add_child(rewards_btn)

func _on_rewards_pressed() -> void:
	AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.5)
	Global.go_to("res://scenes/Rewards.tscn")

func _on_diff_pressed(key: String) -> void:
	if not Global.is_level_unlocked(key):
		return
	AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.5)
	Global.current_difficulty = key
	for k in _diff_buttons:
		var ind = _diff_buttons[k]["wrapper"].get_node_or_null("Indicator")
		if ind:
			ind.visible = (k == key) and Global.is_level_unlocked(k)

func _on_play_pressed() -> void:
	AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.5)
	Global.go_to("res://scenes/Game.tscn")
