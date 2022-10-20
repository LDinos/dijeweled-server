/// @function network_send_simple(sock, net_indicator, [type_array], [value_array])
/// @description Send data to a single socket
/// @param {any} sock The socket to send info to
/// @param {any} net_indicator The first buffer value that indicates what message to expect
/// @param {array} type_array An array that includes the buffer types of each value_array respectively
/// @param {array} value_array An array that includes the values / data that we will send to the socket
function network_send_simple(sock, net_indicator, type_array = [], value_array = []){
	buffer_seek(buffer,buffer_seek_start,0)
	buffer_write(buffer,buffer_u8,net_indicator)	
	for(var i = 0; i < array_length(type_array); i++) {
		buffer_write(buffer,type_array[i],value_array[i])
	}
	network_send_packet(sock,buffer,buffer_tell(buffer))
}