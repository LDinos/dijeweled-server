/// @function network_send_all_except(net_indicator, type_array, value_array, send_to, [ignore_spectators])
/// @description Send data to any players that are connected in the server alltogether
/// @param {real} sock_exception Which socket we do NOT send data to
/// @param {real} net_indicator buffer_u8 data type indicator
/// @param {array} type_array An array of the types corresponding to the values
/// @param {array} value_array An array of the values themselves
function network_send_all_except(sock_exception, net_indicator, type_array = [], value_array = []){
	buffer_seek(buffer,buffer_seek_start,0)
	buffer_write(buffer,buffer_u8,net_indicator)	
	for(var i = 0; i < array_length(type_array); i++) {
		buffer_write(buffer,type_array[i],value_array[i])
	}
	for(var i = 0; i < array_length(players); i++) if players[i] != sock_exception network_send_packet(players[i], buffer, buffer_tell(buffer))
	for(var i = 0; i < array_length(spectators); i++) if spectators[i] != sock_exception network_send_packet(spectators[i], buffer, buffer_tell(buffer))	
}