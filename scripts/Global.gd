extends Node

# ─── ANIMAL THEMES ───────────────────────────────────────────────────────────
const THEMES: Dictionary = {
	"farm": {
		"label": "Fazenda",
		"animals": ["bear","chick","cow","dog","elephant","giraffe","penguin","pig","rabbit","snake","whale"]
	},
}

# ─── DIFFICULTY SETTINGS ─────────────────────────────────────────────────────
# pairs: number of unique animals; cols/rows: grid layout
const DIFFICULTIES: Dictionary = {
	"easy":   {"label": "Fácil",   "pairs": 6,  "cols": 3, "rows": 4},
	"medium": {"label": "Médio",   "pairs": 10, "cols": 4, "rows": 5},
	"hard":   {"label": "Difícil", "pairs": 11, "cols": 4, "rows": 6},
}

# Max attempts for 3/2/1 star (0 = failed)
const STAR_THRESHOLDS: Dictionary = {
	"easy":   [7,  12, 18],
	"medium": [12, 18, 28],
	"hard":   [13, 20, 30],
}

# ─── SESSION STATE ────────────────────────────────────────────────────────────
var current_difficulty: String = "easy"
var current_theme: String     = "farm"
var attempts: int             = 0
var matched_pairs: int        = 0
var stars_earned: int         = 0

# ─── PUBLIC API ───────────────────────────────────────────────────────────────
func prepare_deck() -> Array:
	var animals: Array = THEMES[current_theme]["animals"]
	var pairs: int     = DIFFICULTIES[current_difficulty]["pairs"]
	var deck: Array    = animals.slice(0, pairs) + animals.slice(0, pairs)
	deck.shuffle()
	attempts      = 0
	matched_pairs = 0
	return deck

func register_attempt() -> void:
	attempts += 1

func register_match() -> void:
	matched_pairs += 1

func calculate_stars() -> int:
	var t: Array = STAR_THRESHOLDS[current_difficulty]
	if   attempts <= t[0]: stars_earned = 3
	elif attempts <= t[1]: stars_earned = 2
	elif attempts <= t[2]: stars_earned = 1
	else:                  stars_earned = 0
	return stars_earned

func total_pairs() -> int:
	return DIFFICULTIES[current_difficulty]["pairs"]

func go_to(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
