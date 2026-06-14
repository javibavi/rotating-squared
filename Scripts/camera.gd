extends Camera2D

@onready var ball1 = %ball1;
@onready var ball2 = %ball2;


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = (ball1.position + ball2.position) / 2
	# Configuration variables (adjust these to fit your project)
	var screen_size = get_viewport_rect().size 
	var padding = Vector2(200, 200)       

	# 1. Update camera position to be exactly between both objects
	position = (ball1.position + ball2.position) / 2.0

	# 2. Calculate the absolute distance on each axis separately
	var diff = ball1.position - ball2.position
	var distance_x = abs(diff.x) + padding.x
	var distance_y = abs(diff.y) + padding.y

	# 3. Prevent division by zero if objects are at the exact same pixel
	distance_x = max(distance_x, 0.001)
	distance_y = max(distance_y, 0.001)

	# 4. Calculate required zoom for each axis to fit the screen
	var zoom_x = screen_size.x / distance_x
	var zoom_y = screen_size.y / distance_y

	# 5. Take the minimum of the two zooms so nothing gets cut off
	var target_zoom = min(zoom_x, zoom_y)

	# 6. Apply your hard limits (0.05 min, 0.33 max) and set the Vector2
	target_zoom = min(target_zoom, 0.33)
	# target_zoom = clamp(target_zoom, 0.05, 0.33)
	zoom = Vector2(target_zoom, target_zoom)
