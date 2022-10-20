/// @function array_find_index(array, value)
/// @description Find the value in an array and return its index position
/// @param {array} array The array to search from
/// @param {any} value The value to search for
function array_find_index(array, value) {
	for(var i = 0; i < array_length(array); i++) {
		if (array[i] == value) return i;
	}
	return -1;
}