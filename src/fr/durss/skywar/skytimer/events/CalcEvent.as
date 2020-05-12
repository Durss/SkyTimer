package fr.durss.skywar.skytimer.events {
	import flash.events.Event;

	/**
	 * 
	 * @author François
	 */
	public class CalcEvent extends Event {

		public static const CREATE_TIMER:String	= "createTimer";

		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		public function CalcEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */

	}
}