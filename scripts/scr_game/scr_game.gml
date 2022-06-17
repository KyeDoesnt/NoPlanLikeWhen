#macro Game (__get_static_game())



function __get_static_game() {
	static inst = undefined;
	
	if(inst == undefined) inst = {
		
		
		
		#region // DEFINITIONS ================================================
		
		paused : false,
		binds  : {}, // Keybinds.
		
		tapes  : ds_map_create(),
		timers : ds_list_create(),
		
		tape  : undefined, // The tape that gets fed through and is a list of actions.
		cycle : undefined, // The cycle function - happens every tick.
		
		#endregion DEFINITIONS ================================================
		
		#region // FUNCTIONS ==================================================
		
		///@func	setTape(tape_id)
		///@desc	
		setTape : function( tape_id ) {
			tape = tapes[?tape_id];
		},
		
		///@func	setFPS(target_frames)
		setFPS : function( target_frames ) {
			game_set_speed( target_frames, gamespeed_fps );
		},
		
		createTimer : function() {},
		
		///@func	pause()
		///@desc	
		pause : function() {
			paused = true;
		},
		
		///@func	unpause()
		unpause : function() {
			paused = false;
		},
		
		///@func	
		init : function() {},
		
		///@func	update()
		update : function() {
			// Updating all the timers.
			for(var i = 0; i < ds_list_size(timers); i++) {
				var timer = timers[|i];
				if(timer == undefined) continue;
				timer.update();
				if(timer.done) {
					delete timers[|i];
					timers[|i] = undefined;
				}
			}
		},
		
		///@func	cleanup()
		cleanup : function() {
			delete binds;
			
			ds_map_destroy(tapes);
			ds_list_destroy(timers);
		},
		
		#endregion FUNCTIONS ==================================================
		
		#region // CLASSES ====================================================
		
		// 
		newTape : function() constructor {
			var t = { // Definitions.
				
				// Variables.
				actions    : [],
				is_playing : false,
				
				// Functions.
				play      : undefined,
				pause     : undefined,
				addAction : undefined,
				
				
			};
			
			// 
			play = function() {
				
			};
			
			// 
			pause = function() {};
			
			// 
			// Timer, where tape continues after the duration.
			addAction = function() {};
		},
		
		///@desc	Timer that calls a function at the end of it.
		///@arg		{string}	Duration of the time. ( Formatted like "5s", "2.3min", or "10ms" )
		///@arg		{function}	Callback. Function that is called at the end of the timer.
		///@return	{real}		Timer 
		newTimer : function( time, callback, game_pausable = true ) {
			var t = { // Definitions.
				
				// Variables.
				full           : true,
				last_time      : undefined,
				remaining_time : parseTime(time, "US"), // Time remaining in microseconds. ( 1000th of a millisecond )
				running        : false,
				pausable       : game_pausable,
				done           : false,
				callback       : callback,
				
				#region // Functions. /////////////////////////////////////////
				
				///@desc	Starts the timer, sets last time to current (microseconds since start of game).
				start : function() {
					if(self.done) return noone;
					self.running   = true;
					self.last_time = get_timer();
				},
				
				///@desc	Pauses timer, sets last time to undefined - to be set once started again.
				pause : function() {
					if(self.done) return noone;
					self.running   = false;
					self.last_time = undefined;
				},
				
				///@desc	Stops the timer without calling the callback.
				stop : function() {
					if(self.done) return noone;
					self.running = false;
					self.done    = true;
				},
				
				///@desc	Stops the timer and calls the callback.
				collapse : function() {
					if(self.done) return noone;
					self.stop();
					callback();
				},
				
				///@desc	
				update : function() {
					// Stops the timer if the timer is paused or the game itself is.
					if(!self.running || (self.pausable && Game.paused)) return;
					
					// If the timer is done, collapse the timer - call the callback.
					if(self.remaining_time < 0) return collapse();
					
					// Subtracting the difference in time between now and the last time, then updating the last time.
					self.remaining_time -= get_timer() - self.last_time;
					self.last_time = get_timer();
					
					self.full = false;
				},
				
				#endregion Functions. /////////////////////////////////////////
			};
			
			var index = ds_list_fill(Game.timers, t);
			return Game.timers[|index];
		}
		
		#endregion CLASSES ====================================================
		
		
		
	};
	
	return inst;
}