extends Area2D
class_name PressurePlate

signal pressed
signal released
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		emit_signal("pressed")
		animationPlayer.play("compress")
		_play_sound(body)
	
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		emit_signal("released")
		animationPlayer.play("uncompress")
		_play_sound(body)

func _play_sound(_body: Node) -> void:
	var audio_player: AudioStreamPlayer = $AudioStreamPlayer
	if not audio_player.playing:
		audio_player.play()
		
