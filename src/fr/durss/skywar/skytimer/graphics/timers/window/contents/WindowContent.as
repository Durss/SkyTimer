package fr.durss.skywar.skytimer.graphics.timers.window.contents {
	import fr.durss.skywar.skytimer.graphics.timers.item.TimerItem;

	/**
	 * @author Francois
	 */
	public interface WindowContent {
		
		function open(itemToEdit:TimerItem = null, duration:Number = 0):void;		function close():void;
		
	}
}
