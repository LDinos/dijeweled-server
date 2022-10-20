/// @function network_send(net_indicator, type_array, value_array, send_to, [ignore_spectators])
/// @description Send data to any players that are connected in the server alltogether
/// @param {real} net_indicator buffer_u8 data type indicator
/// @param {array} type_array An array of the types corresponding to the values
/// @param {array} value_array An array of the values themselves
/// @param {real} send_to Send to which player? (0 = first, 1 = second, 2 = both)
/// @param {bool} ignore_spectators Send this info to spectators?
function network_send(net_indicator, type_array, value_array, send_to, ignore_spectators = false){
	buffer_seek(buffer,buffer_seek_start,0)
	buffer_write(buffer,buffer_u8,net_indicator)	
	for(var i = 0; i < array_length(type_array); i++) {
		buffer_write(buffer,type_array[i],value_array[i])
	}
	if (send_to == BOTH) {
		if (players[0] != noone) network_send_packet(players[0],buffer,buffer_tell(buffer))
		if (players[1] != noone) network_send_packet(players[1],buffer,buffer_tell(buffer))
	}
	else {
		if (send_to >= 0) {
			if (players[send_to] != noone) network_send_packet(players[send_to],buffer,buffer_tell(buffer))
			else show_debug_message("Noone to send to that info")
		}
	}
	
	//SPECTATORS ONLY
	if (!ignore_spectators) || (send_to == SPECTATOR_ONLY){
		buffer_seek(buffer,buffer_seek_start,0)
		buffer_write(buffer,buffer_u8,net_indicator)
		if array_length(spectators) != 0 {
			var sender = (send_to == 0) ? 1 : 0 //Who sent this message, player 1 (= 0) or player 2 (= 1)? (the inverse of who are we sending it to)
			buffer_write(buffer,buffer_u8,sender) //one more byte, only for the spectator side to know from whom the data came from
			for(var i = 0; i < array_length(type_array); i++) { //Redo the buffer structure, but with one more byte after the MSG
				buffer_write(buffer,type_array[i],value_array[i])
			}
		}
	 /**/
		for(var i = 0; i < array_length(spectators); i++) {
			network_send_packet(spectators[i],buffer,buffer_tell(buffer))
		}
	}
	
}