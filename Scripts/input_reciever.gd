extends Node


signal gesture_received(gesture: String)

## UDP ports — must match the UDP_PORT values in your arduino_bridge.py scripts.
@export var port_p1 := 6789


var udp_p1: PacketPeerUDP


func _ready() -> void:
	udp_p1 = PacketPeerUDP.new()


	var err1 = udp_p1.bind(port_p1, "127.0.0.1")
	if err1 != OK:
		push_warning("InputReceiver: Failed to bind P1 UDP on port %d" % port_p1)
	else:
		print("InputReceiver: P1 listening on UDP port %d" % port_p1)

	
func _process(_delta: float) -> void:
	_read_controller(udp_p1, 1)


func _read_controller(udp: PacketPeerUDP, player_id: int) -> void:
	while udp.get_available_packet_count() > 0:
		var msg = udp.get_packet().get_string_from_utf8().strip_edges()
		if msg != "":
			gesture_received.emit(player_id, msg)

func _exit_tree() -> void:
	if udp_p1:
		udp_p1.close()
