extends Control

var _font: Font = preload("res://assets/fonts/WhaleITried.ttf")
var _panel: Control

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_run_entrance.call_deferred()

func _build_ui() -> void:
	# Background
	var bg := TextureRect.new()
	bg.texture = load("res://assets/ui/bg_game.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# Animated panel (will slide in from below)
	_panel = Control.new()
	_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panel.modulate.a = 0.0
	add_child(_panel)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 40)
	_panel.add_child(vbox)

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

	# Background slots (faded)
	var slots := TextureRect.new()
	slots.texture = load("res://assets/ui/hub_stars.png")
	slots.set_anchors_preset(Control.PRESET_FULL_RECT)
	slots.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	slots.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	slots.modulate = Color(1, 1, 1, 0.4)
	stars_container.add_child(slots)

	var stars_hbox := HBoxContainer.new()
	stars_hbox.name = "StarsRow"
	stars_hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	stars_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	stars_hbox.add_theme_constant_override("separation", 10)
	stars_container.add_child(stars_hbox)

	var full_star_tex = load("res://assets/ui/hub_stars.png")
	for i in 3:
		var atlas := AtlasTexture.new()
		atlas.atlas = full_star_tex
		atlas.region = Rect2(i * 107, 0, 107, 110)
		var star := TextureRect.new()
		star.name = "Star%d" % i
		star.texture = atlas
		star.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		star.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		star.modulate.a = 0
		star.scale = Vector2.ZERO
		star.pivot_offset = Vector2(53, 55)
		stars_hbox.add_child(star)

	var score_lbl := Label.new()
	score_lbl.text = "TENTATIVAS: %d\nPONTOS: %d" % [Global.attempts, Global.total_points]
	score_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_lbl.add_theme_font_override("font", _font)
	score_lbl.add_theme_font_size_override("font_size", 40)
	vbox.add_child(score_lbl)

	var sp := Control.new()
	sp.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(sp)

	# Icon buttons row
	var btn_hbox := HBoxContainer.new()
	btn_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_hbox.add_theme_constant_override("separation", 24)
	vbox.add_child(btn_hbox)

	var menu_btn := Global.make_icon_btn("🏠", Color(0.88, 0.22, 0.18), 95.0)
	menu_btn.pressed.connect(_on_menu)
	btn_hbox.add_child(menu_btn)

	var again_btn := Global.make_icon_btn("🔄", Color(0.18, 0.52, 0.92), 95.0)
	again_btn.pressed.connect(_on_play_again)
	btn_hbox.add_child(again_btn)

	var lvl_keys = Global.DIFFICULTIES.keys()
	var cur_idx = lvl_keys.find(Global.current_difficulty)
	if cur_idx >= 0 and cur_idx < lvl_keys.size() - 1:
		var next_key = lvl_keys[cur_idx + 1]
		if Global.is_level_unlocked(next_key):
			var next_btn := Global.make_icon_btn("▶", Color(0.15, 0.78, 0.28), 95.0)
			next_btn.pressed.connect(_on_next_level.bind(next_key))
			btn_hbox.add_child(next_btn)

func _run_entrance() -> void:
	# Slide-in from below with fade
	var vp_h := get_viewport().get_visible_rect().size.y
	_panel.position.y = vp_h * 0.3
	_panel.modulate.a = 0.0

	var tw := create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tw.tween_property(_panel, "position:y", 0.0, 0.55)
	tw.tween_property(_panel, "modulate:a", 1.0, 0.35)
	await tw.finished

	await _animate_stars()
	_spawn_fireworks()

func _animate_stars() -> void:
	var stars_row := find_child("StarsRow")
	if not stars_row:
		return
	await get_tree().create_timer(0.3).timeout
	for i in Global.stars_earned:
		var star := stars_row.get_node("Star%d" % i)
		AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.7)
		var tw := create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tw.tween_property(star, "modulate:a", 1.0, 0.3)
		tw.tween_property(star, "scale", Vector2(1.2, 1.2), 0.4)
		await tw.finished
		create_tween().tween_property(star, "scale", Vector2(1.0, 1.0), 0.15)
		await get_tree().create_timer(0.2).timeout

func _spawn_fireworks() -> void:
	var vp := get_viewport().get_visible_rect().size
	var burst_data := [
		[Vector2(vp.x * 0.2, vp.y * 0.22), Color(1.0, 0.9, 0.05)],
		[Vector2(vp.x * 0.8, vp.y * 0.18), Color(0.2, 0.75, 1.0)],
		[Vector2(vp.x * 0.5, vp.y * 0.10), Color(1.0, 0.3, 0.85)],
		[Vector2(vp.x * 0.3, vp.y * 0.35), Color(0.3, 0.95, 0.3)],
		[Vector2(vp.x * 0.7, vp.y * 0.32), Color(1.0, 0.45, 0.1)],
	]
	for item in burst_data:
		_add_particle_burst(item[0], item[1])
		await get_tree().create_timer(0.18).timeout

func _add_particle_burst(pos: Vector2, color: Color) -> void:
	var p := CPUParticles2D.new()
	p.position = pos
	p.emitting = true
	p.amount = 22
	p.lifetime = 1.6
	p.one_shot = true
	p.explosiveness = 0.95
	p.spread = 180.0
	p.gravity = Vector2(0, 180)
	p.initial_velocity_min = 130.0
	p.initial_velocity_max = 310.0
	p.scale_amount_min = 4.0
	p.scale_amount_max = 9.0
	p.color = color
	var grad := Gradient.new()
	grad.colors = [color, Color(color.r, color.g, color.b, 0.0)]
	grad.offsets = [0.0, 1.0]
	p.color_ramp = grad
	add_child(p)
	get_tree().create_timer(3.0).timeout.connect(func():
		if is_instance_valid(p):
			p.queue_free()
	)

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
