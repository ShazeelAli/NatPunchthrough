extends Node2D

@export var JOIN_BUTTON : Button
@export var HOST_BUTTON : Button
@export var MessageLabel : RichTextLabel


func _ready():
	Relayconnect.JOIN_SUCCESS.connect(_on_join_success)
	Relayconnect.JOIN_FAIL.connect(_on_join_fail)
	Relayconnect.HOST_SUCCESS.connect(_on_host_success)
	Relayconnect.HOST_FAIL.connect(_on_host_fail)
	Relayconnect.ON_RELAY_SERVER_FAIL.connect(_on_relay_server_fail)
	Relayconnect.ON_RELAY_SERVER_CONNECT.connect(_on_relay_server_connect)
	if Relayconnect.connected:
		_on_relay_server_connect()


	
func _on_host_success():
	GameManager.host_started = true
	Relayconnect.call_rpc_room(GameManager.change_scene_rpc,["res://SCENES/LOBBY/Multiplayer_Lobby.tscn",true])

func _on_host_fail():
	MessageLabel.text = "HOST FAILED"
	print("HOST FAIL")

func _on_join_success():
	GameManager.host_started = true
	print("JOIN SUCCESS")

func _on_join_fail(error_message):
	MessageLabel.text = "JOIN FAILED : %s" %error_message
	print("JOIN FAIL")

func _on_relay_server_connect():
	MessageLabel.text = ""
	JOIN_BUTTON.disabled = false
	HOST_BUTTON.disabled = false

func _on_relay_server_fail():
	MessageLabel.text = "CONNECTION TO RELAY SERVER FAILED"

func _on_host_button_down():
	Relayconnect.host()

func _on_join_button_down():
	Relayconnect.join()
	
func _on_line_edit_text_changed(new_text):
	Relayconnect.typed_room_code = new_text



	
