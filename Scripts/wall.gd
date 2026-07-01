@tool

extends StaticBody2D

func _process(_delta: float) -> void:
	var texture_rect = $TextureRect
	var collision_shape_2d = $CollisionShape2D
	collision_shape_2d.shape.extents = texture_rect.size/2
	collision_shape_2d.position = texture_rect.position + texture_rect.size/2
