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
var _back:   TextureRect
var _front:  TextureRect
var _sprite: TextureRect

# ─── COLORS / ASSETS ─────────────────────────────────────────────────────────
const TEX_BACK    := preload("res://assets/ui/card_back.png")
const COL_FRONT   := Color(1.0, 1.0, 1.0, 1.0)
const COL_MATCHED := Color(0.9, 1.0, 0.9, 1.0) # Subtle green glow

# ─── SETUP ───────────────────────────────────────────────────────────────────
func _ready() -> void:
	_build_card()
	mouse_filter = Control.MOUSE_FILTER_STOP

func _build_card() -> void:
	# Back face
	_back = TextureRect.new()
	_back.texture = TEX_BACK
	_back.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_back.stretch_mode = TextureRect.STRETCH_SCALE
	_back.set_anchors_preset(Control.PRESET_FULL_RECT)
	_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_back)

	# Front face
	_front = TextureRect.new()
	_front.texture = TEX_BACK # Using wood texture as base for front too if wanted, or plain white
	_front.modulate = COL_FRONT
	_front.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_front.stretch_mode = TextureRect.STRETCH_SCALE
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
	_sprite.offset_bottom = -10
	_sprite.offset_top = 10
	_sprite.offset_left = 10
	_sprite.offset_right = -10
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
	
	AudioManager.play_sfx("res://assets/audio/match-cards.mp3", 0.3) # Reuse for tap if needed or new tap sound

	var tw := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale:x", 0.0, 0.12)
	tw.tween_callback(func(): _back.visible = false; _front.visible = true)
	tw.tween_property(self, "scale:x", 1.0, 0.12)
	await tw.finished
	is_animating = false

func flip_close() -> void:
	if is_animating: return
	is_animating = true
	is_flipped   = false
	var tw := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale:x", 0.0, 0.12)
	tw.tween_callback(func(): _back.visible = true; _front.visible = false)
	tw.tween_property(self, "scale:x", 1.0, 0.12)
	await tw.finished
	is_animating = false

func play_match_effect() -> void:
	is_matched = true
	var tw := create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "scale", Vector2(1.25, 1.25), 0.2)
	tw.tween_property(self, "modulate", COL_MATCHED, 0.2)
	await tw.finished
	var tw2 := create_tween().set_parallel(true)
	tw2.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15)

func play_error_effect() -> void:
	var tw := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "rotation", TAU, 0.55)
	await tw.finished
	rotation = 0.0
