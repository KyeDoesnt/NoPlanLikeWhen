enum UNIT {
	NANOSECONDS,
	MICROSECONDS,
	MILLISECONDS,
	SECONDS,
	MINUTES,
	HOURS,
	DAYS
};

///@func	parseTime(time, [to="MS"], [from="S"])
///@desc	Gets time and converts it to another time.
///@arg		{real|string}	time		- Value we're converting.
///@arg		{string}		[to="MS"]	- Unit that we're converting to.
///@arg		{string}		[from="S"]	- Unit that we're converting from.
///@return	{real}			Converted time.
function parseTime() {
	var time = argument0;
	var parsed_time = real(string_digits(time));
	var parsed_to   = "MS"; if(argument_count > 1) parsed_to = simplifyUnit(argument1);
	var parsed_from = undefined;
	
	// Gets only the units the time is measured in.
	if(parsed_from == undefined) if(string_letters(time) != "") parsed_from = simplifyUnit(time);
	if(argument_count > 2) parsed_from = simplifyUnit(argument2);
	if(parsed_from == undefined) {
		// TODO : Print that the units was unknown, so it just assumed it was seconds.
		parsed_from = UNIT.SECONDS; }
	
	var conversion_keys = [
		UNIT.NANOSECONDS,
		UNIT.MICROSECONDS,
		UNIT.MILLISECONDS,
		UNIT.SECONDS,
		UNIT.MINUTES,
		UNIT.HOURS,
		UNIT.DAYS,
	];
	
	// Conversion steps towards each duration, nanoseconds to days.
	// We just multiply or divide in a given direction!
	var conversion_array = [
		1000, // NANOSECONDS
		1000, // MICROSECONDS
		1000, // MILLISECONDS
		60,   // SECONDS
		60,   // MINUTES
		24,   // HOURS
		1,    // DAYS
	];
	
	var from_key = array_find(conversion_keys, parsed_from);
	var to_key   = array_find(conversion_keys, parsed_to);
	
	// Doing the conversion. Find the difference in units and multiply or divide up or down.
	for(var i = from_key; i != to_key;) {
		// 0, NS
		// 1, US    <-+ i = 1 == 1
		// 2, MS      | i = 2 != 1, multiply 1 (1000)
		// 3, SECONDS | i = 3 != 1, multiply 2 (1000)
		// 4, MINUTES | i = 4 != 1, multiply 3 (60)
		// 5, HOURS
		// 6, DAYS
		
		// MULTIPLY
		if(from_key > to_key) {
			parsed_time *= conversion_array[@i-1];
			i--;
			continue; }
		
		// DIVIDE
		parsed_time /= conversion_array[@i];
		i++;
	}
	
	return parsed_time;
}

///@func	simplifyUnit( unit )
///@desc	Simplifies unit value to value used by code.
///@arg		{string}	Unit to simplify.
function simplifyUnit( unit ) {
	var simplified_unit;
	
	switch(string_upper(string_letters(unit))) {
		case "NS": // NANOSECONDS
			simplified_unit = UNIT.NANOSECONDS;
			break;
		case "US": // MICROSECONDS
			simplified_unit = UNIT.MICROSECONDS;
			break;
		case "MS": // MILLISECONDS
			simplified_unit = UNIT.MILLISECONDS;
			break;
		case "S": // SECONDS
		case "SEC":
		case "SECS":
			simplified_unit = UNIT.SECONDS;
			break;
		case "M": // MINUTES
		case "MIN":
		case "MINS":
			simplified_unit = UNIT.MINUTES;
			break;
		case "H": // HOURS
		case "HR":
		case "HRS":
			simplified_unit = UNIT.HOURS;
			break;
		case "D": // DAYS
		case "DY":
		case "DYS":
			simplified_unit = UNIT.DAYS;
			break;
		default:
			simplified_unit = undefined;
	}
	
	return simplified_unit;
}

///@func	ds_list_fill(id, value)
///@desc	Adds item to ds list at first empty position and returns the index.
///@arg		{real}		id			- DS List ID.
///@arg		{any}		value		- Value to insert into DS List.
///@return	{real}		The index of the value that's just been inserted.
function ds_list_fill( _id, value ) {
	var list_size = ds_list_size(_id);
	for(var i = 0; i < list_size; i++)
		if(_id[|i] == undefined) {
			_id[|i] = value;
			return i; }
	ds_list_add(_id, value);
	return list_size;
}

///@func	array_find(array, value)
///@desc	Finds the index of the first item to match the given value.
///@arg		{array}		array		- Array to look for item in.
///@arg		{any}		value		- Value to search for.
///@return	{any}		The index of first matching item.
function array_find(array, value) {
	for(var i = 0; i < array_length(array); i++) if(array[@i] == value) return i;
	return noone;
}