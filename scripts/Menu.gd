extends Control

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

		var wrapper := Control.new()
		wrapper.custom_minimum_size = Vector2(155, 155)
		grid.add_child(wrapper)

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
			btn.pressed.connect(_on_level_pressed.bind(key))
		wrapper.add_child(btn)

		if not unlocked:
			var dim := ColorRect.new()
			dim.color = Color(0, 0, 0, 0.65)
			dim.set_anchors_preset(Control.PRESET_FULL_RECT)
			dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
			wrapper.add_child(dim)

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

	# Rewards icon button (only if medals unlocked)
	if Global.medals_unlocked > 0:
		var rewards_btn := Global.make_icon_btn("🏆", Color(0.95, 0.72, 0.05), 90.0)
		rewards_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		rewards_btn.pressed.connect(_on_rewards_pressed)
		vbox.add_child(rewards_btn)

func _on_rewards_pressed() -> void:
	AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.5)
	Global.go_to("res://scenes/Rewards.tscn")

func _on_level_pressed(key: String) -> void:
	if not Global.is_level_unlocked(key):
		return
	AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.5)
	Global.current_difficulty = key
	Global.go_to("res://scenes/Game.tscn")
