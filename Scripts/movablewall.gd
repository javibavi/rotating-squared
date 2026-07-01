@tool

extends StaticBody2D

@export var pressure_plates: Array[PressurePlate] = []
@export var all_plates_needed: bool = true
@export var stays_successful: bool = false
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
var pressed : int
var isSuccess : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for plate in pressure_plates:
		plate.pressed.connect(_on_PressurePlate_pressed)
		plate.released.connect(_on_PressurePlate_released)
	
	pressed = 0


func _on_success() -> void:
	if not isSuccess:
		isSuccess = true
		_play_sound(null)
		animationPlayer.play("on_success")

func _on_failure() -> void:
	isSuccess = false
	_play_sound(null)
	animationPlayer.play("on_failure")

func _on_PressurePlate_pressed() -> void:
	pressed += 1
	if all_plates_needed:
		if pressed == pressure_plates.size():
			_on_success()
	
	else:
		if pressed == 1:
			_on_success()


func _on_PressurePlate_released() -> void:
	pressed -= 1
	if not stays_successful:
		if all_plates_needed:
			if pressed != pressure_plates.size():
				_on_failure()
		else:
			if pressed == 0:
				_on_failure()

func _process(_delta: float) -> void:
	var texture_rect = $TextureRect
	var collision_shape_2d = $CollisionShape2D
	collision_shape_2d.shape.extents = texture_rect.size/2
	collision_shape_2d.position = texture_rect.position + texture_rect.size/2
	if not animationPlayer.is_playing():
		var audio_player: AudioStreamPlayer = $AudioStreamPlayer
		if audio_player.playing:
			audio_player.stop()



func _play_sound(_body: Node) -> void:
	var audio_player: AudioStreamPlayer = $AudioStreamPlayer
	if not audio_player.playing:
		audio_player.play()
