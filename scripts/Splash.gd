extends Control

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()
	_run_splash()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.12, 0.64, 0.89, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	add_child(vbox)

	var paw := Label.new()
	paw.text                 = "🐾"
	paw.add_theme_font_size_override("font_size", 130)
	paw.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(paw)

	var title := Label.new()
	title.text                 = "Memory\nAnimais"
	title.add_theme_font_size_override("font_size", 60)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var sub := Label.new()
	sub.text                 = "Jogo de Memória para Crianças"
	sub.add_theme_font_size_override("font_size", 22)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.modulate             = Color(1, 1, 1, 0.80)
	vbox.add_child(sub)

func _run_splash() -> void:
	modulate = Color(1, 1, 1, 0)
	var t1 := create_tween()
	t1.tween_property(self, "modulate:a", 1.0, 0.8)
	await t1.finished
	await get_tree().create_timer(1.8).timeout
	var t2 := create_tween()
	t2.tween_property(self, "modulate:a", 0.0, 0.6)
	await t2.finished
	Global.go_to("res://scenes/Menu.tscn")
