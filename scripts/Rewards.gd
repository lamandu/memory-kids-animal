extends Control

var _font: Font = preload("res://assets/fonts/WhaleITried.ttf")

# Exactly 6 reward animals — those with sound files in assets/audio/animals/
# Order matters: unlocked one per level beaten (1st level → cow, 2nd → dog, etc.)
const ANIMALS: Array = ["cow", "dog", "frog", "horse", "parrot", "pig"]

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()

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
	vbox.set_anchor_and_offset(SIDE_LEFT,   0,  30)
	vbox.set_anchor_and_offset(SIDE_RIGHT,  1, -30)
	vbox.set_anchor_and_offset(SIDE_TOP,    0,  40)
	vbox.set_anchor_and_offset(SIDE_BOTTOM, 1, -40)
	vbox.add_theme_constant_override("separation", 25)
	add_child(vbox)

	var title := Label.new()
	title.text = "🏆 RECOMPENSAS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", _font)
	title.add_theme_font_size_override("font_size", 52)
	vbox.add_child(title)

	# How many animals are unlocked:
	# medals_unlocked = how many levels have been beaten (0..6)
	# Each level beaten unlocks 2 animals (cumulative, shown via ANIMALS_PER_MEDAL in Global)
	var unlocked_count: int = Global.get_unlocked_animal_count()

	var lock_tex: Texture2D = null
	if ResourceLoader.exists("res://assets/ui/locker.png"):
		lock_tex = load("res://assets/ui/locker.png")

	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	grid.add_theme_constant_override("h_separation", 30)
	grid.add_theme_constant_override("v_separation", 30)
	vbox.add_child(grid)

	for i in range(ANIMALS.size()):
		var animal: String = ANIMALS[i]
		var unlocked: bool = (i < unlocked_count)

		# Wrapper
		var wrapper := Control.new()
		wrapper.custom_minimum_size = Vector2(160, 160)
		grid.add_child(wrapper)

		# Animal image
		var animal_path := "res://assets/animals/" + animal + ".png"
		var img := TextureRect.new()
		if ResourceLoader.exists(animal_path):
			img.texture = load(animal_path)
		img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		img.set_anchors_preset(Control.PRESET_FULL_RECT)
		img.mouse_filter = Control.MOUSE_FILTER_IGNORE
		wrapper.add_child(img)

		if unlocked:
			# Invisible button to catch clicks
			var btn := Button.new()
			btn.set_anchors_preset(Control.PRESET_FULL_RECT)
			btn.flat = true
			btn.pressed.connect(_on_animal_pressed.bind(animal))
			wrapper.add_child(btn)
		else:
			# Semi-transparent dark overlay
			var dim := ColorRect.new()
			dim.color = Color(0, 0, 0, 0.70)
			dim.set_anchors_preset(Control.PRESET_FULL_RECT)
			dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
			wrapper.add_child(dim)

			# Lock icon — PRESET_FULL_RECT + aspect-centered = fills wrapper but keeps ratio
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

	# Back button
	var back_btn := Button.new()
	back_btn.text = " ← VOLTAR "
	back_btn.custom_minimum_size = Vector2(250, 75)
	back_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back_btn.add_theme_font_override("font", _font)
	back_btn.add_theme_font_size_override("font_size", 30)
	back_btn.pressed.connect(_on_back_pressed)
	vbox.add_child(back_btn)

func _on_animal_pressed(animal_name: String) -> void:
	var path := "res://assets/audio/animals/" + animal_name + ".mp3"
	if ResourceLoader.exists(path):
		AudioManager.play_sfx(path)

func _on_back_pressed() -> void:
	AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.5)
	Global.go_to("res://scenes/Menu.tscn")
