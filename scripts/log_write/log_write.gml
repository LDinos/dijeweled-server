/// @function log_write(text, [color])
/// @description Write in log
/// @param {string} text What to write in log
/// @param {real} color What color to use for the text
function log_write(text, color = c_yellow) {
	var time = date_datetime_string(date_current_datetime()) + ": ";
	array_insert(log, 0, {"text" : text, "color" : color, "time" : time})
}