extends Area2D

@export var increase_mass_by: float = 1;

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	body.mass += increase_mass_by
	_play_sound(body)
	# queue_free()

func _play_sound(_body: Node) -> void:
	var audio_player: AudioStreamPlayer = $AudioStreamPlayer
	if not audio_player.playing:
		audio_player.play()
