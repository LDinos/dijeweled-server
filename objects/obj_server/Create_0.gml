/// @description
#macro PLAYER_1 0
#macro PLAYER_2 1
#macro BOTH 2
#macro SPECTATOR_ONLY -1
global.version = "1.16"
log = []
log_write("Opening Server...", c_yellow)

function get_player(sock) {
	if players[0] == sock return 0;
	else if players[1] == sock return 1;
	return -1;
}

function get_other_player(sock) {
	if players[0] == sock return 1;
	else if players[1] == sock return 0;
	return -1;
}

function check_after_connection(sock) { //after seeing that version is correct and player can join the server, do these
	var amhost = false
	var amspectator = false
    if (players[0] == noone) {
		players[0] = sock
		amhost = true
		log_write("Player 1 connected and is hosting.")
		network_send(NN_YOUARE_HOST,[],[],PLAYER_1)
	}
	else if (players[1] == noone) {
		log_write("Player 2 connected.")
		players[1] = sock
	}
	else {
		amspectator = true
		log_write("Spectator connected.")
		array_push(spectators, sock)
		buffer_seek(buffer,buffer_seek_start,0)
		buffer_write(buffer,buffer_u8,NN_YOUARE_SPECTATOR)
		buffer_write(buffer,buffer_string,global.user1)
		buffer_write(buffer,buffer_string,global.user2)
		network_send_packet(sock,buffer,buffer_tell(buffer)) 
	}
	if (!amhost) network_send_simple(players[0], NN_LBY_REQUEST_SETTINGS,[buffer_bool],[amspectator])
	show_debug_message("Player " + string(sock) + "joined.")
}

players = [noone, noone] //socket arrays
spectators = [] //

global.user1 = "" //the user names
global.user2 = "" //
global.spectator = "" //

allow_connections = true
server_socket = network_create_server(network_socket_tcp, 6969, 3);
if (server_socket < 0) log_write("Error on opening server.", c_red)
else log_write("Server is open and listening. Ver " + global.version, c_lime)
buffer = buffer_create(1,buffer_grow,1)
network_set_config(network_config_connect_timeout, 8000);

global.replay = true //maybe do config file later
if (global.replay) instance_create_depth(0,0,depth,obj_replay_control)

