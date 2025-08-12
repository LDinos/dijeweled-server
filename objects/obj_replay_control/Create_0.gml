/// @description
timer_started = false
timer = 0 //frames timer
replay_player1 = {}
replay_player2 = {}
game_seed = 0
game_replay = {}
gamemodes = [ "Time Attack", "Avalanche"]
time_attack_times = ["5:00", "3:00", "1:00"]
game_settings = {
	"blazing_allowed" : true,
	"ultranovas_allowed" : true,
	"multiswap_allowed" : true,
	"hypercubes_allowed" : false,
	"matchless_allowed" : false,
	"twist_allowed" : false,
	"skins" : 7,
	"gamemode" : 0,
	"gamemode_val" : 0,
	"avalanche_turns" : []
}
function replay_get_player(p_id) {return (p_id == 0) ? replay_player1 : replay_player2}

function replay_set_seed(seed) {
	game_seed = seed 
}

function start_timer() {
	with(obj_server) log_write("Replay recording started.", c_gray)
	timer_started = true
	}
	
function stop_timer() {	
	var struct_file = {
		"title" : global.user1 + " VS " + global.user2,
		"date" : string(date_get_day(date_current_datetime())) + "-" + string(date_get_month(date_current_datetime())) + "-" + string(date_get_year(date_current_datetime())),
		"gamemode" : gamemodes[game_settings[$ "gamemode"]],
		"time": game_settings[$ "gamemode"] == 0 ? time_attack_times[game_settings[$ "gamemode_val"]] : "-",
		"score" : 0,
		"author": global.user1 + " | " + global.user2,
		"is_twist": game_settings[$ "twist_allowed"],
		"replay_ver": 2,
		"geode_xplier": 1,
		"data": {
			"player1" : replay_player1,
			"player2" : replay_player2,
			"player1_name" : global.user1,
			"player2_name" : global.user2,
			"seed" : game_seed,
			"game_end" : timer+1,
			"blazing_allowed" : game_settings[$ "blazing_allowed"],
			"ultranovas_allowed" : game_settings[$ "ultranovas_allowed"],
			"multiswap_allowed" : game_settings[$ "multiswap_allowed"],
			"hypercubes_allowed" : game_settings[$ "hypercubes_allowed"],
			"matchless_allowed" : game_settings[$ "matchless_allowed"],
			"twist_allowed" : game_settings[$ "twist_allowed"],
			"skins" : game_settings[$ "skins"],
			"gamemode_value" : game_settings[$ "gamemode"],
			"gamemode_type" : game_settings[$ "gamemode_val"],
			"gamemode_name" : (game_settings[$ "gamemode"] == 0) ? "Time Attack" : "Avalanche",
			"avalanche_turns" : game_settings[$ "avalanche_turns"]	
		}
	}
	timer = 0
	timer_started = false
	var json = json_stringify(struct_file)
	var _buffer = buffer_create(string_byte_length(json)+1, buffer_fixed, 1)
	buffer_write(_buffer, buffer_string, json)
	with(obj_server) network_send(NN_SERVER_REPLAY_DATA, [buffer_string], [json], BOTH)
	buffer_save(_buffer, "replay.json")
	buffer_delete(_buffer)
}

function replay_add_info(player, strct) {
	var t = string(timer)
	var input_struct_key = variable_struct_get_names(strct)[0]
	var input_struct_val = variable_struct_get(strct, input_struct_key)
	if !variable_struct_exists(player, t) variable_struct_set(player, t, [])
	var frame_array = player[$ t]
	var s = array_length(frame_array)
	frame_array[s] = {}
	frame_array[s][$ input_struct_key] = input_struct_val;
	//show_debug_message(player)

}

function replay_add_avalanche_turn() { //keep avalanche turn frames so we can forward skip when replay watching
	array_push(game_settings[$ "avalanche_turns"], timer) 
}

function reset_replay() {
	timer_started = false
	timer = 0 //frames timer
	replay_player1 = {}
	replay_player2 = {}
	game_seed = 0
	game_replay = {}
}