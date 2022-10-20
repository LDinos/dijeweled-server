/// @function scr_received_buffer(buffer2, send_to)
/// @description Get network info
/// @param {real} buffer2 client buffer2
/// @param {real} send_to to whom do we send this info
function scr_received_buffer(buffer2, send_to, sock) {
	var sender = !send_to //who sent this info (player 1 (= 0), or player 2 (= 1)
	buffer_seek(buffer2,buffer_seek_start,0)
	var msg = buffer_read(buffer2,buffer_u8)
	var gamemode = 0
	with(obj_replay_control) gamemode = game_settings[$ "gamemode"]
	switch msg
	{
		case NN_MATCH_GEM_SWAP:
			var id1 = buffer_read(buffer2,buffer_u8)
			var id2 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8,buffer_u8], [id1,id2], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"swap" : [id1, id2]})}
			if (gamemode == 1) REPLAY replay_add_avalanche_turn()
			break;
		case NN_MATCH_TWIST_SWAP:
			var v1 = buffer_read(buffer2,buffer_u8)
			var v2 = buffer_read(buffer2,buffer_u8)
			var v3 = buffer_read(buffer2,buffer_u8)
			var v4 = buffer_read(buffer2,buffer_u8)
			var cc = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8,buffer_u8,buffer_u8,buffer_u8,buffer_u8],
			[v1,v2,v3,v4,cc], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"twist_swap" : [v1,v2,v3,v4,cc]})}
			if (gamemode == 1) REPLAY replay_add_avalanche_turn()
			break;
		case NN_MATCH_HYPE_SWAP:
			network_send(msg, [], [], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"hype_swap" : []})}
			break;
		case NN_MATCH_AMEXPLODE:
			var v1 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8], [v1], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"gem_amexplode" : [v1]})}
			break;
		case NN_MATCH_GEM_COMBO_SOUND:
			var c = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8], [c], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"combo" : [c]})}
			break;
		case NN_MATCH_AVALANCHE_GAMEOVER:
			network_send(msg, [], [], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"avalanche_gameover" : []})}
			REPLAY stop_timer()
			log_write("Replay saved.", c_aqua)
			break;
		case NN_POINTS_ADD:
			var c = buffer_read(buffer2,buffer_u16)
			network_send(msg, [buffer_u16], [c], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"points_add" : [c]})}
			break;
		case NN_STYLE_ADD:
			var c = buffer_read(buffer2,buffer_u16)
			network_send(msg, [buffer_u16], [c], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"style_add" : [c]})}
			break;
		case NN_MATCH_BLAZING_SPEED_ON:
			network_send(msg, [], [], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"blaze_on" : []})}
			break;
		case NN_MATCH_AVALANCHE_END_TURN:
			var c = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8], [c], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"avalanche_endturn" : [c]})}
			break;
		case NN_MATCH_BLAZING_SPEED_OFF:
			network_send(msg, [], [], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"blaze_off" : []})}
			break;
		case NN_MATCH_HYPE_OFF:
			network_send(msg, [], [], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"hype_off" : []})}
			break;
		case NN_MATCH_AHM_SETSKIN:
			var d = buffer_read(buffer2,buffer_u8)
			var sk = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8,buffer_u8], [d,sk], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"ahm_setskin" : [d,sk]})}
			break;
		case NN_MATCH_SEND_POINTS:
			v1 = buffer_read(buffer2,buffer_u32)
			v2 = buffer_read(buffer2,buffer_u32)
			network_send(msg, [buffer_u32,buffer_u32], [v1,v2], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"match_points" : [v1,v2]})}
			break;
		case NN_MATCH_AHM_SPAWN:
			var v1 = buffer_read(buffer2,buffer_s8)
			var v2 = buffer_read(buffer2,buffer_u8)
			var v3 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_s8, buffer_u8, buffer_u8], [v1,v2,v3], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"ahm_spawn" : [v1,v2,v3]})}
			break;
		case NN_MATCH_GEM_SPAWN:
			var v1 = buffer_read(buffer2,buffer_u8)
			var v2 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8, buffer_u8], [v1,v2], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"gem_spawn" : [v1,v2]})}
			break;
		case NN_MATCH_GEM_DEATH:
			show_debug_message(buffer_get_size(buffer2))
			var v1 = buffer_read(buffer2,buffer_u8)
			var v2 = buffer_read(buffer2,buffer_bool)
			if (buffer_get_size(buffer2) == 4) { //if it was a hypercube, it gave one more info
				var v3 = buffer_read(buffer2,buffer_u8) //the skin to hype
				network_send(msg, [buffer_u8, buffer_bool, buffer_u8], [v1,v2,v3], send_to)
				REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"gem_death" : [v1,v2,v3]})}
			}
			else {
				network_send(msg, [buffer_u8, buffer_bool], [v1,v2], send_to)
				REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"gem_death" : [v1,v2]})}
			}
			break;
		case NN_MATCH_GEM_POWER:
			var v1 = buffer_read(buffer2,buffer_u8)
			var v2 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8, buffer_u8], [v1,v2], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"gem_power" : [v1,v2]})}
			break;
		case NN_MATCH_AVALANCHE_HIDDENMINUS:
			network_send(msg, [], [], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"avalanche_hidden_minus" : []})}
			break;
		case NN_MATCH_GEM_POWER_NEW:
		    var v1 = buffer_read(buffer2,buffer_u8)
			var v2 = buffer_read(buffer2,buffer_u8)
			var v3 = buffer_read(buffer2,buffer_u8)
			var v4 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8, buffer_u8, buffer_u8, buffer_u8], [v1,v2,v3,v4], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"gem_power_new" : [v1,v2,v3,v4]})}
			break;
		case NN_MATCH_GEM_HYPER:
			var v1 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8], [v1], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"match_hyper" : [v1]})}
			break;
		case NN_MATCH_GEM_HYPER_NEW:
		    var v1 = buffer_read(buffer2,buffer_u8)
			var v2 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8, buffer_u8], [v1,v2], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"hyper_new" : [v1,v2]})}
			break;
		case NN_MATCH_BOARD_SPAWN:
			var seed = buffer_read(buffer2,buffer_u32)
			REPLAY replay_set_seed(seed)
			network_send(msg, [buffer_u32], [seed], send_to)
			break;
		case NN_MATCH_DUALHYPE_MAKE_HYPE:
			var v1 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8], [v1], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"dualhype_make" : [v1]})}
			break;
		case NN_LBY_CONNECTED: //server getting the info that someone joined
			var user = buffer_read(buffer2,buffer_string)
			if (array_length(spectators) > 0)  { //if this is a spectator joining
				log_write("Spectator username: " + user, c_white)
				global.spectator = user
				network_send(NN_SPECTATOR_JOINED, [buffer_string], [user], BOTH, true)
			} else {
				if (send_to == PLAYER_1) {
					log_write("Player 2 username: " + user, c_white)
					global.user2 = user
					network_send(msg, [buffer_string], [user], send_to)
				} else {
					log_write("Player 1 username: " + user, c_white)
					global.user1 = user
				}
			}
			break;
		case NN_CHAT:
			var text = buffer_read(buffer2,buffer_string)
			log_write(text, c_silver)
			network_send_all_except(sock, NN_CHAT, [buffer_string], [text])
			break;
		case NN_DISCONNECT: //client getting the message that server left
			network_send(msg, [], [], send_to)
			break;
		case NN_LBY_SEND_SETTINGS: //client getting info previously asked
			var spec_only = buffer_read(buffer2,buffer_bool)
			var s = spec_only ? SPECTATOR_ONLY : send_to //send to player or spectator?
			var v0 = buffer_read(buffer2,buffer_bool)
			var v1 = buffer_read(buffer2,buffer_bool)
			var v2 = buffer_read(buffer2,buffer_bool)
			var v3 = buffer_read(buffer2,buffer_bool)
			var v4 = buffer_read(buffer2,buffer_bool)
			var v5 = buffer_read(buffer2,buffer_bool)
			var v6 = buffer_read(buffer2,buffer_u8)
			var G = buffer_read(buffer2,buffer_u8)
			var c1 = buffer_read(buffer2,buffer_bool) 
			var c2 = buffer_read(buffer2,buffer_bool) 
			var u = buffer_read(buffer2,buffer_string)
			var ver = buffer_read(buffer2,buffer_string)
			var G2 = buffer_read(buffer2,buffer_u8)
			var type = buffer_u8
			network_send(msg, [buffer_bool, buffer_bool, buffer_bool,buffer_bool,buffer_bool,buffer_bool,buffer_bool,
			buffer_u8,buffer_u8,buffer_bool,buffer_bool,buffer_string,buffer_string, type], [spec_only,v0,v1,v2,v3,v4,v5,v6,G,c1,c2,u,ver,G2], s, !spec_only)
			break;
		case NN_LBY_PRESS_BEJ3: //client getting info that the host pressed BEJ3 preset
			network_send(msg, [], [], send_to)
			break;
		case NN_LBY_PRESS_CLASSIC: //client getting info that the host pressed CLASSIC preset
			network_send(msg, [], [], send_to)
			break;
		case NN_LBY_SKINS: //client getting infot
			v1 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8], [v1], send_to)
			break;
		case NN_LBY_ULTRANOVAS:
			v1 = buffer_read(buffer2,buffer_bool)
			network_send(msg, [buffer_bool], [v1], send_to)
			break;
		case NN_LBY_BLAZING:
			v1 = buffer_read(buffer2,buffer_bool)
			network_send(msg, [buffer_bool], [v1], send_to)
			break;
		case NN_LBY_TWIST: //client getting info
			v1 = buffer_read(buffer2,buffer_bool)
			network_send(msg, [buffer_bool], [v1], send_to)
			break;
		case NN_LBY_DEFENSE: //client getting info
			v1 = buffer_read(buffer2,buffer_bool)
			network_send(msg, [buffer_bool], [v1], send_to)
			break;
		case NN_LBY_MATCHLESS: //client getting info
			v1 = buffer_read(buffer2,buffer_bool)
			network_send(msg, [buffer_bool], [v1], send_to)
			break;
		case NN_LBY_HYPERCUBES: //client getting info
			v1 = buffer_read(buffer2,buffer_bool)
			network_send(msg, [buffer_bool], [v1], send_to)
			break;
		case NN_LBY_MULTISWAP: //client getting info
			v1 = buffer_read(buffer2,buffer_bool)
			network_send(msg, [buffer_bool], [v1], send_to)
			break;
		case NN_LBY_GAMEMODE: //client getting info
			v1 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8], [v1], send_to)
			break;
		case NN_LBY_GAMEMODE2: //client getting info
			v1 = buffer_read(buffer2,buffer_u8)
			network_send(msg, [buffer_u8], [v1], send_to)
			break;
		case NN_LBY_READY: //client or server getting ready info
			network_send(msg, [], [], send_to)
			break;
		case NN_BACK_TO_LOBBY:
			network_send(msg, [], [], send_to)
			allow_connections = true
			break;
		case NN_SERVER_REPLAY_STOP:
			REPLAY stop_timer()
			log_write("Replay saved.", c_aqua)
			break;
		case NN_MATCH_GO:
			network_send(msg, [], [], send_to)
			REPLAY start_timer()
			break;
		case NN_MATCH_TIMEUP:
			network_send(msg, [], [], send_to)
			break;
		case NN_MUSIC_DANGERON:
			network_send(msg, [], [], send_to)
			break;
		case NN_MUSIC_DANGEROFF:
			network_send(msg, [], [], send_to)
			break;
		case NN_MATCH_AVALANCHE_PASS:
			network_send(msg, [], [], send_to)
			REPLAY {var p = replay_get_player(sender); replay_add_info(p, {"avalanche_pass" : []}); replay_add_avalanche_turn()} 
			break;
		case NN_AMREADY:
			network_send(msg, [], [], send_to)
			break;
		case NN_DISSALLOW_SPECTATORS:
			log_write("Beginning game. No more connections allowed.", c_yellow)
			network_send(NN_SERVER_GAME_SETTINGS, [], [], PLAYER_1, true) //get all game settings for replay
			allow_connections = false
			break;
		case NN_SERVER_CHECK_VER:
			var ver = buffer_read(buffer2, buffer_string)
			if (ver != global.version) network_send_simple(sock, NN_SERVER_BYE, [buffer_string], ["Your version (" + ver + ") is not the same as server's ("+global.version+")"])
			break;
		case NN_SERVER_GAME_SETTINGS: //get all info requested
			obj_replay_control.game_settings[$ "blazing_allowed"] = buffer_read(buffer2, buffer_u8)
			obj_replay_control.game_settings[$ "ultranovas_allowed"] = buffer_read(buffer2, buffer_u8)
			obj_replay_control.game_settings[$ "multiswap_allowed"] = buffer_read(buffer2, buffer_u8)
			obj_replay_control.game_settings[$ "hypercubes_allowed"] = buffer_read(buffer2, buffer_u8)
			obj_replay_control.game_settings[$ "matchless_allowed"] = buffer_read(buffer2, buffer_u8)
			obj_replay_control.game_settings[$ "twist_allowed"] = buffer_read(buffer2, buffer_u8)
			obj_replay_control.game_settings[$ "skins"] = buffer_read(buffer2, buffer_u8)
			obj_replay_control.game_settings[$ "gamemode"] = buffer_read(buffer2, buffer_u8)
			obj_replay_control.game_settings[$ "gamemode_val"] = buffer_read(buffer2, buffer_u8)
			break;
	}


}