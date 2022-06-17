/// @description Insert description here
// You can write your code in this editor

if(timer.done)         image_index = STATUS_BLUE;
else if(timer.running) image_index = STATUS_YELLOW;
else                   image_index = STATUS_RED;

draw_self();
var text;
if(timer.done) text = "Timer is done. ";
else {
	text = string(parseTime(timer.remaining_time, "S", "US")) + "s";
	if(!timer.running) text += "\nTimer is paused.";
}
draw_text(x + 5, y, text);

var timer_count = ds_list_size(Game.timers);
var text = string(timer_count) + " timers.";
if(text == 1) text = "1 timer.";
draw_text(0, 0, text);