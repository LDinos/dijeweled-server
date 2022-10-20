/// @description
log_write("Exiting...")
file_delete("LOG.txt")
var file = file_text_open_write("LOG.txt")
for(var i = array_length(log)-1; i >= 0; i--) {
	var txt = string(log[i][$ "time"]) + string(log[i][$ "text"])
	file_text_write_string(file, txt)
	file_text_writeln(file)
}
file_text_close(file)
network_send(NN_SERVER_BYE, [buffer_string], ["Server is closed"], BOTH)
network_destroy(server_socket)

