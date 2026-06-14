extends Area2D

@export var increase_mass_by: float = 1;
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
var listening : bool = true;

func _ready():
	connect("body_entered", _on_body_entered)

func _process(_delta):
	if not listening:
		if not audio_player.playing:
			queue_free()

func _on_body_entered(body):
	if not listening:
		return
	listening = false
	body.mass += increase_mass_by
	visible = false
	_play_sound(body)

func _play_sound(_body: Node) -> void:
	if not audio_player.playing:
		audio_player.play()
