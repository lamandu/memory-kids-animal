extends Control

# ─── SIGNALS ─────────────────────────────────────────────────────────────────
signal card_tapped(card)

# ─── STATE ───────────────────────────────────────────────────────────────────
var animal_name:  String = ""
var card_index:   int    = 0
var is_flipped:   bool   = false
var is_matched:   bool   = false
var is_animating: bool   = false

# ─── CHILD REFS (built in _ready) ────────────────────────────────────────────
var _back:   ColorRect
var _front:  ColorRect
var _sprite: TextureRect

# ─── COLORS ──────────────────────────────────────────────────────────────────
const COL_BACK    := Color(0.22, 0.53, 0.90, 1.0)
const COL_FRONT   := Color(0.98, 0.98, 0.98, 1.0)
const COL_MATCHED := Color(0.78, 1.00, 0.78, 1.0)

# ─── SETUP ───────────────────────────────────────────────────────────────────
func _ready() -> void:
	_build_card()
	mouse_filter = Control.MOUSE_FILTER_STOP

func _build_card() -> void:
	# Back face
	_back = ColorRect.new()
	_back.color = COL_BACK
	_back.set_anchors_preset(Control.PRESET_FULL_RECT)
	_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_back)

	var back_lbl := Label.new()
	back_lbl.text = "?"
	back_lbl.add_theme_font_size_override("font_size", 56)
	back_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	back_lbl.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	back_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	back_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_back.add_child(back_lbl)

	# Front face
	_front = ColorRect.new()
	_front.color   = COL_FRONT
	_front.visible = false
	_front.set_anchors_preset(Control.PRESET_FULL_RECT)
	_front.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_front)

	# Animal sprite
	_sprite = TextureRect.new()
	_sprite.set_anchors_preset(Control.PRESET_FULL_RECT)
	_sprite.expand_mode  = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_front.add_child(_sprite)

func setup(anim_name: String, idx: int) -> void:
	animal_name  = anim_name
	card_index   = idx
	is_flipped   = false
	is_matched   = false
	modulate     = Color.WHITE
	scale        = Vector2.ONE
	pivot_offset = custom_minimum_size / 2.0
	if _back:  _back.visible  = true
	if _front: _front.visible = false
	_load_texture()

func _load_texture() -> void:
	var tex := load("res://assets/animals/" + animal_name + ".png") as Texture2D
	if tex and _sprite:
		_sprite.texture = tex

# ─── INPUT ───────────────────────────────────────────────────────────────────
func _gui_input(event: InputEvent) -> void:
	if is_matched or is_flipped or is_animating:
		return
	var tapped := false
	if event is InputEventMouseButton:
		tapped = event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	elif event is InputEventScreenTouch:
		tapped = event.pressed
	if tapped:
		emit_signal("card_tapped", self)

# ─── ANIMATIONS ──────────────────────────────────────────────────────────────
func flip_open() -> void:
	if is_animating: return
	is_animating = true
	is_flipped   = true
	var tw := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale:x", 0.0, 0.10)
	tw.tween_callback(func(): _back.visible = false; _front.visible = true)
	tw.tween_property(self, "scale:x", 1.0, 0.10)
	await tw.finished
	is_animating = false

func flip_close() -> void:
	if is_animating: return
	is_animating = true
	is_flipped   = false
	var tw := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale:x", 0.0, 0.10)
	tw.tween_callback(func(): _back.visible = true; _front.visible = false)
	tw.tween_property(self, "scale:x", 1.0, 0.10)
	await tw.finished
	is_animating = false

func play_match_effect() -> void:
	is_matched = true
	modulate   = COL_MATCHED
	var tw := create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "scale", Vector2(1.18, 1.18), 0.18)
	await tw.finished
	var tw2 := create_tween().set_parallel(true)
	tw2.tween_property(self, "scale", Vector2(1.0, 1.0), 0.12)

func play_error_effect() -> void:
	var ox := position.x
	var tw := create_tween().set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "position:x", ox + 10, 0.05)
	tw.tween_property(self, "position:x", ox - 10, 0.05)
	tw.tween_property(self, "position:x", ox +  7, 0.05)
	tw.tween_property(self, "position:x", ox -  7, 0.05)
	tw.tween_property(self, "position:x", ox,      0.05)
	await tw.finished
