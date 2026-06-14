@tool

extends StaticBody2D
@onready var area2DCollision : CollisionShape2D = $Area2D/CollisionShape2D
@export var massNeeded : float = 10.0
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var timer1 : Timer = $Timer1
@onready var timer2 : Timer = $Timer2
@onready var textureRect : TextureRect = $TextureRect

@export var crackShader : ShaderMaterial

func _ready() -> void:
	var area2D = $Area2D
	area2D.body_entered.connect(_on_body_entered)
	particles.emitting = false
	timer1.connect("timeout", _on_Timer1_timeout)
	timer2.connect("timeout", _on_Timer2_timeout)

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("Player"):
		if body.mass >= massNeeded:
			call_deferred("_break_wall")
			textureRect.material = crackShader
			timer1.start()
			_play_sound(body)

func _break_wall() -> void:
	$CollisionShape2D.disabled = true
	area2DCollision.disabled = true

func _on_Timer1_timeout() -> void:
	textureRect.visible = false
	particles.emitting = true
	timer1.stop()
	timer2.start()

func _on_Timer2_timeout() -> void:
	queue_free()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint:
		var texture_rect = $TextureRect
		var collision_shape_2d = $CollisionShape2D
		var particleRect = $CPUParticles2D
		collision_shape_2d.shape.extents = texture_rect.size/2
		collision_shape_2d.position = texture_rect.position + texture_rect.size/2
		area2DCollision.shape.extents = texture_rect.size/2 + Vector2(20, 20)
		area2DCollision.position = texture_rect.position + texture_rect.size/2
		particleRect.set_emission_rect_extents(texture_rect.size/2)
		particleRect.position = texture_rect.position + texture_rect.size/2

func _play_sound(_body: Node) -> void:
	var audio_player: AudioStreamPlayer = $AudioStreamPlayer
	if not audio_player.playing:
		audio_player.play()

	
