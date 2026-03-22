extends Control

const CARD_SCENE   := preload("res://scenes/components/Card.tscn")
const HEADER_H     := 90.0
const MARGIN       := 14.0

var _attempts_lbl: Label
var _pairs_lbl:    Label
var _grid:         GridContainer
var _flipped:      Array = []
var _can_flip:     bool  = true

# ─── LIFECYCLE ───────────────────────────────────────────────────────────────
func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_spawn_cards()
	_update_hud()

func _build_ui() -> void:
	# Sky-blue background
	var bg := ColorRect.new()
	bg.color = Color(0.12, 0.64, 0.89, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# Root VBox fills screen
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 0)
	add_child(vbox)

	# Header
	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, HEADER_H)
	header.add_theme_constant_override("separation", 12)
	vbox.add_child(header)

	var back_btn := Button.new()
	back_btn.text = "  ⬅  "
	back_btn.custom_minimum_size = Vector2(70, 0)
	back_btn.pressed.connect(_on_back_pressed)
	header.add_child(back_btn)

	_attempts_lbl = Label.new()
	_attempts_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_attempts_lbl.vertical_alignment    = VERTICAL_ALIGNMENT_CENTER
	_attempts_lbl.add_theme_font_size_override("font_size", 20)
	header.add_child(_attempts_lbl)

	_pairs_lbl = Label.new()
	_pairs_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_pairs_lbl.horizontal_alignment  = HORIZONTAL_ALIGNMENT_RIGHT
	_pairs_lbl.vertical_alignment    = VERTICAL_ALIGNMENT_CENTER
	_pairs_lbl.add_theme_font_size_override("font_size", 20)
	header.add_child(_pairs_lbl)

	# Card area (fills remaining space), centered
	var center := CenterContainer.new()
	center.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(center)

	var diff: Dictionary = Global.DIFFICULTIES[Global.current_difficulty]
	_grid = GridContainer.new()
	_grid.columns = diff["cols"]
	_grid.add_theme_constant_override("h_separation", int(MARGIN))
	_grid.add_theme_constant_override("v_separation", int(MARGIN))
	center.add_child(_grid)

func _spawn_cards() -> void:
	var deck := Global.prepare_deck()
	var diff: Dictionary = Global.DIFFICULTIES[Global.current_difficulty]
	var cols: int = diff["cols"]
	var rows: int = diff["rows"]

	var vp  := get_viewport().get_visible_rect().size
	if vp == Vector2.ZERO:
		vp = Vector2(720, 1280)

	var avail_w := vp.x      - MARGIN * (cols + 1)
	var avail_h := vp.y - HEADER_H - MARGIN * (rows + 1) - 10.0
	var card_sz := floorf(min(avail_w / cols, avail_h / rows))

	for i in deck.size():
		var card = CARD_SCENE.instantiate()
		card.custom_minimum_size = Vector2(card_sz, card_sz)
		_grid.add_child(card)
		card.setup(deck[i], i)
		card.card_tapped.connect(_on_card_tapped)

# ─── GAME LOGIC ──────────────────────────────────────────────────────────────
func _on_card_tapped(card: Control) -> void:
	if not _can_flip or card.is_matched or card.is_flipped:
		return
	card.flip_open()
	_flipped.append(card)

	if _flipped.size() == 2:
		_can_flip = false
		Global.register_attempt()
		_update_hud()
		await get_tree().create_timer(0.7).timeout
		await _resolve_match()

func _resolve_match() -> void:
	if _flipped.size() < 2:
		return
	var c1: Control = _flipped[0]
	var c2: Control = _flipped[1]
	_flipped.clear()

	if c1.animal_name == c2.animal_name:
		c1.play_match_effect()
		c2.play_match_effect()
		Global.register_match()
		_update_hud()
		_can_flip = true
		if Global.matched_pairs >= Global.total_pairs():
			Global.calculate_stars()
			await get_tree().create_timer(0.7).timeout
			Global.go_to("res://scenes/Victory.tscn")
	else:
		c1.play_error_effect()
		c2.play_error_effect()
		await get_tree().create_timer(0.35).timeout
		await c1.flip_close()
		await c2.flip_close()
		_can_flip = true

func _update_hud() -> void:
	if _attempts_lbl:
		_attempts_lbl.text = "Tentativas: %d" % Global.attempts
	if _pairs_lbl:
		_pairs_lbl.text = "Pares: %d/%d" % [Global.matched_pairs, Global.total_pairs()]

func _on_back_pressed() -> void:
	Global.go_to("res://scenes/Menu.tscn")
