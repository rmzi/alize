class_name dj extends StaticBody2D

@export var dj_audio : AudioStream

@export_group("Pitch")
@export_range(0.5, 2.0) var pitch : float = 1.0

@export_group("Lo-fi Distortion")
@export_range(0.0, 1.0) var drive : float = 0.2
@export_range(500.0, 20000.0) var keep_hf : float = 5000.0
@export_range(0.0, 10.0) var pre_gain : float = 2.0
@export_range(-10.0, 10.0) var post_gain : float = 0.0

@export_group("Chorus")
@export_range(0.0, 1.0) var dry : float = 0.8
@export_range(0.0, 1.0) var wet : float = 0.2
@export_range(1, 4) var voice_count : int = 2
@export_range(1.0, 50.0) var delay_ms : float = 15.0
@export_range(0.0, 10.0) var depth_ms : float = 2.0
@export_range(0.1, 5.0) var rate_hz : float = 1.0

@export_group("")
@export var apply : bool = false : set = _apply_settings

#@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var audio : AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D

var bus_index : int
var distortion : AudioEffectDistortion
var chorus : AudioEffectChorus

func _ready():
	#animation_player.play("idle")
	audio.stream = dj_audio
	audio.bus = "DJ"
	audio.finished.connect(audio.play)
	
	bus_index = AudioServer.get_bus_index("DJ")
	distortion = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectDistortion
	chorus = AudioServer.get_bus_effect(bus_index, 1) as AudioEffectChorus
	
	_apply_settings(true)
	audio.play()

func _apply_settings(_value : bool):
	if not is_node_ready():
		return
	
	audio.pitch_scale = pitch
	
	distortion.mode = AudioEffectDistortion.MODE_LOFI
	distortion.drive = drive
	distortion.keep_hf_hz = keep_hf
	distortion.pre_gain = pre_gain
	distortion.post_gain = post_gain
	
	chorus.dry = dry
	chorus.wet = wet
	chorus.voice_count = voice_count
	chorus.set("voice/1/delay_ms", delay_ms)
	chorus.set("voice/1/depth_ms", depth_ms)
	chorus.set("voice/1/rate_hz", rate_hz)
	chorus.set("voice/2/delay_ms", delay_ms * 1.2)
	chorus.set("voice/2/depth_ms", depth_ms)
	chorus.set("voice/2/rate_hz", rate_hz * 0.8)
