extends Control

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_run_splash.call_deferred()

func _build_ui() -> void:
	var bg := TextureRect.new()
	bg.texture = load("res://assets/ui/splashscreen.png")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.name = "SplashImage"
	add_child(bg)

	# Sparkle particle trail (mimics legacy particle animation)
	var particles := CPUParticles2D.new()
	particles.name = "SplashParticles"
	particles.emitting = false
	particles.amount = 18
	particles.lifetime = 0.9
	particles.explosiveness = 0.0
	particles.spread = 28.0
	particles.direction = Vector2(1.0, -0.2)
	particles.initial_velocity_min = 80.0
	particles.initial_velocity_max = 160.0
	particles.gravity = Vector2(0, 40)
	particles.scale_amount_min = 3.0
	particles.scale_amount_max = 7.0
	particles.color = Color(1.0, 0.95, 0.25)
	var grad := Gradient.new()
	grad.colors = [Color(1.0, 0.95, 0.25, 1.0), Color(1.0, 0.95, 0.25, 0.0)]
	grad.offsets = [0.0, 1.0]
	particles.color_ramp = grad
	add_child(particles)

func _run_splash() -> void:
	var splash := get_node("SplashImage")
	var particles := get_node("SplashParticles") as CPUParticles2D
	var vp := get_viewport().get_visible_rect().size

	splash.modulate.a = 0.0

	# Start particles from left side, mid-screen height
	particles.position = Vector2(-40.0, vp.y * 0.52)
	particles.emitting = true

	# Move particle emitter across screen
	var tw_p := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw_p.tween_property(particles, "position:x", vp.x + 60.0, 2.8)

	# Fade splash in
	var t1 := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	t1.tween_property(splash, "modulate:a", 1.0, 1.0)
	await t1.finished

	await get_tree().create_timer(2.0).timeout

	# Fade splash out
	var t2 := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	t2.tween_property(splash, "modulate:a", 0.0, 0.8)
	await t2.finished

	Global.go_to("res://scenes/Menu.tscn")
