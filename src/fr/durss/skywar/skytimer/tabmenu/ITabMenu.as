package fr.durss.skywar.skytimer.tabmenu {
	import flash.events.IEventDispatcher;

	/**
	 * @author François
	 */
	public interface ITabMenu extends IEventDispatcher {
		function openIndex(index:int):void;
		
		function set selectedIndex(value:int):void;		
		function get selectedIndex():int;		
	}
}
