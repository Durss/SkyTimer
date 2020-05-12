package fr.durss.skywar.skytimer.events {	import fr.durss.skywar.skytimer.graphics.timers.item.TimerItemPlugger;	import flash.events.Event;	/**	 * Event fired by the <code>DependencyManager</code> singleton.	 * 	 * @author  Francois	 */	public class DependencyManagerEvent extends Event {				public static const START_PLUG:String	= "startPlug";		public static const STOP_PLUG:String	= "stopPlug";		public static const UPDATE:String		= "update";				private var _stopTarget:TimerItemPlugger;		private var _startTarget:TimerItemPlugger;				/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>DependencyManagerEvent</code>.<br>		 */		public function DependencyManagerEvent(type:String, startTarget:TimerItemPlugger = null, stopTarget:TimerItemPlugger = null, bubbles:Boolean = false, cancelable:Boolean = false) {			_stopTarget		= stopTarget;			_startTarget	= startTarget;			super(type, bubbles, cancelable);		}				/**		 * Gets the target over wich the drag stopped.		 */		public function get stopTarget():TimerItemPlugger	{ return _stopTarget; }				/**		 * Gets the target where the drag started from.		 */		public function get startTarget():TimerItemPlugger	{ return _startTarget; }						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */						/* ******* *		 * PRIVATE *		 * ******* */			}}