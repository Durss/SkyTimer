package fr.durss.skywar.skytimer.events {	import flash.events.Event;	/**	 * 	 * @author  François	 */	public class DragEvent extends Event {				public static const DRAG_START:String	= "startDrag";		public static const DRAG_COMPLETE:String	= "stopDrag";
		
		
		
		/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>DragEvent</code>		 */		public function DragEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {			super(type, bubbles, cancelable);		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		override public function clone():Event {			return new DragEvent(type, bubbles, cancelable);		}								/* ******* *		 * PRIVATE *		 * ******* */	}}