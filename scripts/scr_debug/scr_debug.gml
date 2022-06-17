#macro Debug (__get_static_debug())

#macro STATUS_RED 0
#macro STATUS_YELLOW 1
#macro STATUS_BLUE 2


// TODO : Add feature on console's scrollbar that brings view to bottom.

function __get_static_debug() {
	static debug = undefined;
	
	if(debug == undefined) debug = {
		
		
		
		#region // DEFINITIONS ================================================
		
		surface : undefined,
		
		#endregion DEFINITIONS ================================================
		
		#region // FUNCTIONS ==================================================
		
		///@desc	Creates the debug surface, stored in "debug_surface".
		createSurface : function()
		{ Debug.surface = surface_create(window_get_width(), window_get_height()); },
		
		setSurface : function() {
			if(!surface_exists(Debug.surface)) {
				Debug.createSurface();
			}
			
			surface_set_target(Debug.surface);
		},
		
		displaySurface : function() {
			
		},
		
		///@func	init()
		init : function() {
			Debug.surface.create();
		},
		
		///@func
		update : function() {},
		
		///@func	cleanup()
		cleanup : function() {
			ds_list_destroy(Debug.console.logs);
			surface_free(Debug.debug_surface);
		},
		
		#endregion FUNCTIONS ==================================================
		
		#region // CLASSES ====================================================
		
		console : {
			
			logs : ds_list_create(),
			
			///@desc	
			///@arg		{string}		Text to send to console.
			log : function( text ) {
			},
			
			///@desc	
			init : function() {},
			
			///@desc	
			display : function() {},
			
			///@desc	
			update : function() {
			},
			
		},
		
		surface : {
			
			///@desc	Creates the debug surface, stored in "debug_surface".
			create : function()
			{
				Debug.debug_surface = surface_create(window_get_width(), window_get_height());
				show_debug_message(Debug.debug_surface);
			},
			
			///@desc
			draw : function( draw_code ) {
				var prev_target = surface_get_target();
				show_debug_message(prev_target);
				
				surface_set_target(Debug.debug_surface);
				draw_code();
				
				if(prev_target < 0) return surface_reset_target();
				surface_set_target(prev_target);
			},
			
			///@func	display()
			display : function() {
				// Checking surface exists.
				if(!surface_exists(Debug.debug_surface)) surface.create();
				
				#region // Resising the surface.
				var tw = window_get_width();  // Target width.
				var th = window_get_height(); // Target height.
				if((surface_get_width(Debug.debug_surface) != tw) || (surface_get_height(Debug.debug_surface) != th))
					surface_resize(Debug.debug_surface, tw, th);
				#endregion Resizing the surface.
				
				draw_surface(Debug.debug_surface, 0, 0);
			}
		}
		
		#endregion CLASSES ====================================================
		
		
		
	};
	
	return debug;
}