extends Node2D

### ALL CODE PERTAINING TO RELAY CONNECTION
signal JOIN_SUCCESS
signal JOIN_FAIL(error_message)
signal HOST_SUCCESS
signal HOST_FAIL(error_message)

@export var typed_room_code= ""
var ROOM_DATA = {}
var IS_HOST = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	var relay_connect = ENetMultiplayerPeer.new()
	var error = relay_connect.create_client("127.0.0.1",25566)
	#var error = relay_connect.create_client("127.0.0.1",25566)
	if error:
		return(error)
		
	multiplayer.multiplayer_peer = relay_connect
	multiplayer.peer_connected.connect(_on_player_connected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(multiplayer.multiplayer_peer.get_connection_status())
	pass

func _on_player_connected(id:int):
	_resgister_player.rpc_id(0)

	
func host():
	if multiplayer.multiplayer_peer.CONNECTION_CONNECTED:
		host_rpc.rpc_id(0)

func join():
	if multiplayer.multiplayer_peer.CONNECTION_CONNECTED:
		join_rpc.rpc_id(0,typed_room_code)

@rpc("any_peer","call_remote","reliable")
func host_rpc():
	pass

@rpc("authority","call_remote","reliable")
func host_success_rpc(room_code : String,room_info : Dictionary):
	print(room_info)
	IS_HOST = true
	HOST_SUCCESS.emit()

@rpc("any_peer","call_remote","reliable")
func join_rpc(room_code : String):
	pass

@rpc("authority","call_remote","reliable")
func join_success_rpc(room_code : String):
	JOIN_SUCCESS.emit()
	pass

@rpc("authority","call_remote","reliable")
func join_fail_rpc(room_code : String, error_message : String):
	JOIN_FAIL.emit(error_message)
	print(error_message)
	pass
	
@rpc("any_peer","call_remote","reliable")
func _resgister_player():
	pass

@rpc("authority","reliable")
func sync_room_data_rpc(room_data : Dictionary):
	ROOM_DATA = room_data
	print(ROOM_DATA)


func _on_line_edit_text_changed(new_text):
	typed_room_code = new_text
	pass # Replace with function body.

### END OF RELAY SERVER CONNECTION 

func call_rpc_room(rpc_function : Callable, args : Array, call_self : bool = true):
	for player_id in ROOM_DATA.players:
		
		if player_id == multiplayer.multiplayer_peer.get_unique_id() and !call_self:
			continue
			
		match args.size():
			0:
				rpc_function.rpc_id(player_id)
			1:
				rpc_function.rpc_id(player_id,args[0])
			2:
				rpc_function.rpc_id(player_id,args[0],args[1])
			3:
				rpc_function.rpc_id(player_id,args[0],args[1],args[2])
		
	
@rpc("any_peer","call_local","reliable")
func change_scene_rpc(scene_path : String):
	get_tree().change_scene_to_file(scene_path)
