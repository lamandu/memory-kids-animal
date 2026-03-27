extends Node

const SAVE_PATH = "user://save_game.dat"

# ─── ANIMAL THEMES ───────────────────────────────────────────────────────────
const THEMES: Dictionary = {
	"farm": {
		"label": "Animais",
		"animals": [
			"chick", "cow", "dog", "elephant", "giraffe", "penguin", 
			"pig", "rabbit", "snake", "whale", "parrot", "gorilla"
		]
	},
}

# ─── DIFFICULTY SETTINGS ─────────────────────────────────────────────────────
const DIFFICULTIES: Dictionary = {
	"lvl_6":  {"label": "6 Cartas",  "pairs": 3,  "cols": 3, "rows": 2},
	"lvl_8":  {"label": "8 Cartas",  "pairs": 4,  "cols": 4, "rows": 2},
	"lvl_12": {"label": "12 Cartas", "pairs": 6,  "cols": 4, "rows": 3},
	"lvl_16": {"label": "16 Cartas", "pairs": 8,  "cols": 4, "rows": 4},
	"lvl_20": {"label": "20 Cartas", "pairs": 10, "cols": 4, "rows": 5},
	"lvl_24": {"label": "24 Cartas", "pairs": 12, "cols": 4, "rows": 6},
}

# [3-star max, 2-star max, 1-star max] attempts — 0 stars if above 1-star max
# Based on pairs count: minimum attempts = pairs (if perfectly lucky)
const STAR_THRESHOLDS: Dictionary = {
	"lvl_6":  [5,  9,  15],   # 3 pairs
	"lvl_8":  [7,  12, 20],   # 4 pairs
	"lvl_12": [10, 17, 28],   # 6 pairs
	"lvl_16": [14, 23, 37],   # 8 pairs
	"lvl_20": [18, 30, 48],   # 10 pairs
	"lvl_24": [22, 36, 58],   # 12 pairs
}

# Exactly 6 reward animals (those with sounds), one unlocked per level beaten
# medals_unlocked 1 -> 1 animal, 2 -> 2, ... 6 -> 6
const ANIMALS_PER_MEDAL: Array = [1, 2, 3, 4, 5, 6]

# ─── SESSION STATE ────────────────────────────────────────────────────────────
var current_difficulty: String = "lvl_6"
var current_theme: String     = "farm"
var attempts: int             = 0
var matched_pairs: int        = 0
var stars_earned: int         = 0
var total_points: int         = 0
var medals_unlocked: int      = 0   # Number of medals (levels beaten)
var max_level_unlocked: int   = 0   # 0 = only first level unlocked

func _ready() -> void:
	load_game()

# ─── SAVE SYSTEM ──────────────────────────────────────────────────────────────
func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var data = {
			"total_points": total_points,
			"medals_unlocked": medals_unlocked,
			"max_level_unlocked": max_level_unlocked
		}
		file.store_string(JSON.stringify(data))

func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json = JSON.parse_string(file.get_as_text())
			if json:
				total_points       = json.get("total_points", 0)
				medals_unlocked    = clampi(json.get("medals_unlocked", 0), 0, DIFFICULTIES.size())
				max_level_unlocked = clampi(json.get("max_level_unlocked", 0), 0, DIFFICULTIES.size() - 1)
				# Migration: if old save had no max_level_unlocked, derive it from medals
				if not json.has("max_level_unlocked"):
					max_level_unlocked = clampi(medals_unlocked - 1, 0, DIFFICULTIES.size() - 1) if medals_unlocked > 0 else 0

func reset_save() -> void:
	total_points       = 0
	medals_unlocked    = 0
	max_level_unlocked = 0
	stars_earned       = 0
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

# ─── PUBLIC API ───────────────────────────────────────────────────────────────
func is_level_unlocked(key: String) -> bool:
	var idx = DIFFICULTIES.keys().find(key)
	return idx <= max_level_unlocked

func get_unlocked_animal_count() -> int:
	if medals_unlocked <= 0:
		return 0
	return ANIMALS_PER_MEDAL[min(medals_unlocked - 1, ANIMALS_PER_MEDAL.size() - 1)]

func prepare_deck() -> Array:
	var all_animals: Array = THEMES[current_theme]["animals"]
	var pairs_wanted: int  = DIFFICULTIES[current_difficulty]["pairs"]
	var selected_animals: Array = all_animals.slice(0, pairs_wanted)
	var deck: Array = []
	for animal in selected_animals:
		deck.append(animal)
		deck.append(animal)
	deck.shuffle()
	attempts      = 0
	matched_pairs = 0
	return deck

func register_attempt() -> void:
	attempts += 1

func register_match() -> void:
	matched_pairs += 1
	total_points += 10
	save_game()

func calculate_stars() -> int:
	var t: Array = STAR_THRESHOLDS[current_difficulty]
	if   attempts <= t[0]: stars_earned = 3
	elif attempts <= t[1]: stars_earned = 2
	elif attempts <= t[2]: stars_earned = 1
	else:                  stars_earned = 0
	
	# Unlock next level
	var lvl_idx = DIFFICULTIES.keys().find(current_difficulty)
	if lvl_idx >= max_level_unlocked:
		max_level_unlocked = min(lvl_idx + 1, DIFFICULTIES.size() - 1)
	
	# Track medals (how many levels beaten, up to 6)
	if medals_unlocked < DIFFICULTIES.size():
		medals_unlocked = max(medals_unlocked, lvl_idx + 1)
	
	save_game()
	return stars_earned

func total_pairs() -> int:
	return DIFFICULTIES[current_difficulty]["pairs"]

func go_to(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)

static func make_icon_btn(icon: String, color: Color, size: float) -> Button:
	var btn := Button.new()
	btn.text = icon
	btn.custom_minimum_size = Vector2(size, size)
	btn.add_theme_font_size_override("font_size", int(size * 0.52))

	var r := int(size * 0.45)
	var sn := StyleBoxFlat.new()
	sn.bg_color = color
	sn.set_corner_radius_all(r)
	sn.border_width_bottom = 5
	sn.border_width_top = 2
	sn.border_width_left = 2
	sn.border_width_right = 2
	sn.border_color = color.darkened(0.35)
	sn.shadow_color = Color(0, 0, 0, 0.3)
	sn.shadow_size = 4
	sn.shadow_offset = Vector2(0, 3)
	btn.add_theme_stylebox_override("normal", sn)

	var sh := sn.duplicate()
	sh.bg_color = color.lightened(0.12)
	btn.add_theme_stylebox_override("hover", sh)

	var sp := sn.duplicate()
	sp.bg_color = color.darkened(0.18)
	sp.shadow_size = 1
	sp.shadow_offset = Vector2(0, 1)
	btn.add_theme_stylebox_override("pressed", sp)
	btn.add_theme_stylebox_override("focus", sn)

	return btn
