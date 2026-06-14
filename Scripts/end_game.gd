extends Area2D

@onready var white_screen: TextureRect = %WhiteScreen
@export var fade_in_secs: float = 0.5
var end_game : bool = false
var timer : float = 0.0

func _ready():
	connect("body_entered", _on_body_entered)

func _process(_delta):
	if end_game:
		if white_screen.modulate.a < 1.0:
			white_screen.modulate.a += _delta * 1/fade_in_secs
		
		timer += _delta
		if timer >= fade_in_secs + 1.0: # Wait for fade-in to complete and an additional second before changing scene
			get_tree().change_scene_to_file("res://start.tscn")

func _on_body_entered(body):
	end_game = true
