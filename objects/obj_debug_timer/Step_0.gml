/// @description 

if(keyboard_check_pressed(vk_space) && !timer.done) {
	if(timer.running) {
		timer.pause();
		show_debug_message("Timer paused.");
	} else {
		timer.start();
		if(timer.full) show_debug_message("Timer started.");
		else show_debug_message("Timer resumed.");
	}
}