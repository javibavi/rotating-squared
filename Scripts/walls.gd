extends Node2D

@export var ROTSPEED : float = PI
@onready var main_camera: Camera2D = %MainCamera
var udp_p1: PacketPeerUDP
var msg: String
## UDP ports — must match the UDP_PORT values in your arduino_bridge.py scripts.
@export var port_p1 := 6789
func _rotate_world_around_pivot(pivot: Vector2, angle: float) -> void:
	for child in get_children():
		if child is Node2D:
			var node = child as Node2D
			var offset = node.global_position - pivot
			var rotated_offset = offset.rotated(angle)
			node.global_position = pivot + rotated_offset
			node.rotation += angle

func _physics_process(delta: float) -> void:
	var middle = main_camera.get_screen_center_position()
	
	_read_controller(udp_p1, 1)
	
	if msg == "None":
		return
	
	if Input.is_action_pressed("rotateL") or msg == "left":
		_rotate_world_around_pivot(middle, -delta * ROTSPEED)

		
	elif Input.is_action_pressed("rotateR") or msg == "right":
		_rotate_world_around_pivot(middle, delta * ROTSPEED)
	
	
	


func _ready() -> void:
	udp_p1 = PacketPeerUDP.new()


	var err1 = udp_p1.bind(port_p1, "127.0.0.1")
	if err1 != OK:
		push_warning("InputReceiver: Failed to bind P1 UDP on port %d" % port_p1)
	else:
		print("InputReceiver: P1 listening on UDP port %d" % port_p1)

	


func _read_controller(udp: PacketPeerUDP, player_id: int) -> void:
	while udp.get_available_packet_count() > 0:
		msg = udp.get_packet().get_string_from_utf8().strip_edges()

func _exit_tree() -> void:
	if udp_p1:
		udp_p1.close()
