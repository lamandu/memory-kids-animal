extends Node

var _music_player: AudioStreamPlayer
var _sfx_player:   AudioStreamPlayer

var music_enabled: bool = true
var sfx_enabled:   bool = true

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)
	
	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.bus = "SFX"
	add_child(_sfx_player)

func play_music(stream_path: String, volume: float = 0.5) -> void:
	if _music_player.stream and _music_player.stream.resource_path == stream_path:
		if music_enabled and not _music_player.playing:
			_music_player.play()
		return
		
	var stream = load(stream_path)
	if stream:
		_music_player.stream = stream
		_music_player.volume_db = linear_to_db(volume)
		if music_enabled:
			_music_player.play()

func stop_music() -> void:
	_music_player.stop()

func play_sfx(stream_path: String, volume: float = 1.0) -> void:
	if not sfx_enabled: return
	var stream = load(stream_path)
	if stream:
		var p = AudioStreamPlayer.new()
		p.stream = stream
		p.volume_db = linear_to_db(volume)
		p.bus = "SFX"
		add_child(p)
		p.play()
		p.finished.connect(p.queue_free)

func set_music_enabled(enabled: bool) -> void:
	music_enabled = enabled
	if enabled:
		if _music_player.stream and not _music_player.playing:
			_music_player.play()
	else:
		_music_player.stop()

func set_sfx_enabled(enabled: bool) -> void:
	sfx_enabled = enabled

func linear_to_db(linear: float) -> float:
	if linear <= 0: return -80.0
	return 20.0 * log(linear) / log(10.0)
