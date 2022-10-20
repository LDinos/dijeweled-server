/// @description
    var t = ds_map_find_value(async_load, "type");
    switch(t)
        {
        case network_type_connect:
			var sock = ds_map_find_value(async_load, "socket")
			log_write("Socket attempting connection...", c_yellow)
			if (!allow_connections) {
				log_write("...but failed due to game being in progress.", c_yellow)
				buffer_seek(buffer,buffer_seek_start,0)
				buffer_write(buffer,buffer_u8,NN_SERVER_BYE)
				buffer_write(buffer,buffer_string,"Game is in progress. No more connections allowed")
				network_send_packet(sock,buffer,buffer_tell(buffer)) 
				break;
			}
			else {
				buffer_seek(buffer,buffer_seek_start,0)
				buffer_write(buffer,buffer_u8,NN_SERVER_CHECK_VER)
				network_send_packet(sock,buffer,buffer_tell(buffer))
				check_after_connection(sock)
			}
            break;
        case network_type_disconnect:
			var sock = ds_map_find_value(async_load, "socket")
			var p = get_player(sock)
			var spectator_discconect = array_find_index(spectators, sock)
			if (spectator_discconect) != -1 {
				array_delete(spectators, spectator_discconect, 1)
				log_write("Spectator disconnected.", c_yellow)
				global.spectator = ""
				network_send(NN_SPECTATOR_DISCONNECT,[],[],BOTH)
			}
			else if (p != -1) {
				with(obj_replay_control) reset_replay()
				log_write("Player " + string(p+1) + " disconnected.", c_yellow)
				log_write("Replay terminated early.", c_gray)
				network_send(NN_DISCONNECT,[],[],BOTH)
				players[0] = noone
				players[1] = noone
				global.user1 = ""
				global.user2 = ""
				allow_connections = true
			}
			show_debug_message("Player socket" +string(p+1) + " left.")
            break;
        case network_type_data:
            //Data handling here...
			var buffer2 = ds_map_find_value(async_load, "buffer")
			var sock = ds_map_find_value(async_load, "id")
			var send_to = get_other_player(sock)
			scr_received_buffer(buffer2, send_to, sock)
            break;
        }
