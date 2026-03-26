extends Control

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_run_splash()

func _build_ui() -> void:
	# Show the original splashscreen image
	var bg := TextureRect.new()
	bg.texture = load("res://assets/ui/splashscreen.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.name = "SplashImage"
	add_child(bg)

func _run_splash() -> void:
	var splash = get_node("SplashImage")
	splash.modulate.a = 0
	
	var t1 := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	t1.tween_property(splash, "modulate:a", 1.0, 1.0)
	await t1.finished
	
	await get_tree().create_timer(2.0).timeout
	
	var t2 := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	t2.tween_property(splash, "modulate:a", 0.0, 0.8)
	await t2.finished
	
	Global.go_to("res://scenes/Menu.tscn")
