extends Control

var _font: Font = preload("res://assets/fonts/WhaleITried.ttf")

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_animate_stars.call_deferred()

func _build_ui() -> void:
	# Reuse game background
	var bg := TextureRect.new()
	bg.texture = load("res://assets/ui/bg_game.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 40)
	add_child(vbox)

	var title := Label.new()
	title.text = "LEVEL COMPLETE!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", _font)
	title.add_theme_font_size_override("font_size", 80)
	title.add_theme_color_override("font_shadow_color", Color.BLACK)
	vbox.add_child(title)

	# Stars row container
	var stars_container := Control.new()
	stars_container.custom_minimum_size = Vector2(340, 120)
	stars_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(stars_container)
	
	# Background slots (the original 3-star image)
	var slots := TextureRect.new()
	slots.texture = load("res://assets/ui/hub_stars.png")
	slots.set_anchors_preset(Control.PRESET_FULL_RECT)
	slots.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	slots.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	slots.modulate = Color(1, 1, 1, 0.4) # Faded background
	stars_container.add_child(slots)

	var stars_hbox := HBoxContainer.new()
	stars_hbox.name      = "StarsRow"
	stars_hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	stars_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	stars_hbox.add_theme_constant_override("separation", 10)
	stars_container.add_child(stars_hbox)

	var full_star_tex = load("res://assets/ui/hub_stars.png")
	
	for i in 3:
		# Create a single star by cropping hub_stars.png
		# Image is 321x110, so each star is approx 107x110
		var atlas := AtlasTexture.new()
		atlas.atlas = full_star_tex
		atlas.region = Rect2(i * 107, 0, 107, 110)
		
		var star := TextureRect.new()
		star.name          = "Star%d" % i
		star.texture       = atlas
		star.expand_mode   = TextureRect.EXPAND_KEEP_SIZE
		star.stretch_mode  = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		star.modulate.a    = 0 # Start hidden
		star.scale         = Vector2.ZERO
		star.pivot_offset  = Vector2(53, 55) # Center pivot for scaling
		stars_hbox.add_child(star)

	var score_lbl := Label.new()
	score_lbl.text = "TENTATIVAS: %d\nPONTOS: %d" % [Global.attempts, Global.total_points]
	score_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_lbl.add_theme_font_override("font", _font)
	score_lbl.add_theme_font_size_override("font_size", 40)
	vbox.add_child(score_lbl)

	# Flexible spacer
	var sp := Control.new()
	sp.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(sp)

	var btn_hbox := HBoxContainer.new()
	btn_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_hbox.add_theme_constant_override("separation", 20)
	vbox.add_child(btn_hbox)

	var menu_btn := Button.new()
	menu_btn.text                = " MENU "
	menu_btn.custom_minimum_size = Vector2(160, 75)
	menu_btn.add_theme_font_override("font", _font)
	menu_btn.add_theme_font_size_override("font_size", 30)
	menu_btn.pressed.connect(_on_menu)
	btn_hbox.add_child(menu_btn)

	var again_btn := Button.new()
	again_btn.text                = " REPLAY "
	again_btn.custom_minimum_size = Vector2(160, 75)
	again_btn.add_theme_font_override("font", _font)
	again_btn.add_theme_font_size_override("font_size", 30)
	again_btn.pressed.connect(_on_play_again)
	btn_hbox.add_child(again_btn)

	# Show Next Level button if there's a next unlocked level
	var lvl_keys = Global.DIFFICULTIES.keys()
	var cur_idx = lvl_keys.find(Global.current_difficulty)
	if cur_idx >= 0 and cur_idx < lvl_keys.size() - 1:
		var next_key = lvl_keys[cur_idx + 1]
		if Global.is_level_unlocked(next_key):
			var next_btn := Button.new()
			next_btn.text                = " PRÓXIMO ▶ "
			next_btn.custom_minimum_size = Vector2(180, 75)
			next_btn.add_theme_font_override("font", _font)
			next_btn.add_theme_font_size_override("font_size", 30)
			next_btn.pressed.connect(_on_next_level.bind(next_key))
			btn_hbox.add_child(next_btn)

func _animate_stars() -> void:
	var stars_row := find_child("StarsRow")
	if not stars_row: return
	
	await get_tree().create_timer(0.5).timeout
	
	for i in Global.stars_earned:
		var star := stars_row.get_node("Star%d" % i)
		AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.7)
		
		var tw := create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tw.tween_property(star, "modulate:a", 1.0, 0.3)
		tw.tween_property(star, "scale", Vector2(1.2, 1.2), 0.4)
		await tw.finished
		
		create_tween().tween_property(star, "scale", Vector2(1.0, 1.0), 0.15)
		await get_tree().create_timer(0.2).timeout

func _on_play_again() -> void:
	AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.5)
	Global.go_to("res://scenes/Game.tscn")

func _on_next_level(next_key: String) -> void:
	AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.5)
	Global.current_difficulty = next_key
	Global.go_to("res://scenes/Game.tscn")

func _on_menu() -> void:
	AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.5)
	Global.go_to("res://scenes/Menu.tscn")
