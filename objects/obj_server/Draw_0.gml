/// @description
var line_space = 16
var last_y = room_height - 48
var s = array_length(log)
var istop = s > round(room_height/line_space) ? round(room_height/line_space) : s
for(var i = 0; i < istop; i++) { //write on screen until we reach the top
	var t = log[i].text
	var c = log[i].color
	draw_text_color(0, last_y - i*line_space, t, c,c,c,c, 1)
}

draw_text(room_width - 64, 8, global.version)