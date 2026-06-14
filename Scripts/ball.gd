extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var initial_circle_radius: float
var initial_scale: Vector2

func _ready() -> void:
	# Duplicate the shape resource so changes only affect this specific instance
	initial_circle_radius = collision_shape_2d.shape.radius
	initial_scale = sprite_2d.scale
	connect("body_entered", _play_sound)

func _map_mass_to_scale(x: float) -> float:
	return 1.67 / (1.0 + 0.67 * exp(-0.5 * (x - 1.0)))

func _process(_delta: float) -> void:
	var target_scale: float = _map_mass_to_scale(mass)
	
	# 1. Scale the visual element only
	sprite_2d.scale = Vector2(initial_scale.x * target_scale, initial_scale.y * target_scale)
	
	# 2. Modify the underlying radius property of the unique shape resource
	if collision_shape_2d.shape is CircleShape2D:
		collision_shape_2d.shape.radius = initial_circle_radius * target_scale


func _play_sound(_body: Node) -> void:
	var audio_player: AudioStreamPlayer = $AudioStreamPlayer
	var velocity = linear_velocity.length()
	if not audio_player.playing:
		audio_player.play()
		audio_player.volume_db = 10 + 10 * (velocity / 200) # Adjust volume based on velocity, maxing out at 0 dB for velocity >= 200