/// @description 

Game.init();
Debug.init();

done  = false;
timer = Game.newTimer("2s", function() {
	done = true;
});
