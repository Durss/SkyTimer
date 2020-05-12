package fr.durss.skywar.skytimer.time {	import flash.errors.IllegalOperationError;	/**	 * Formats a timestamp to a string.<p>	 * 	 * @author  François	 */	public class TimeFormater {								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>TimeFormater</code>		 */		public function TimeFormater() {			throw new IllegalOperationError("DO not instanciate! Use static members instead.");		}
		
		
		/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Formats a timestamp onto a string.<p>		 * 		 * @param time		timestamp to format in milliseconds.		 * @param digitsH	number of digits for hours.		 * @param digitsM	number of digits for minutes.		 * @param digitsS	number of digits for seconds.		 */		public static function format(time:Number, digitsH:int = 1, digitsM:int = 2, digitsS:int = 2, convertDaysTohours:Boolean = true):String {			var offset:int = (new Date(0).timezoneOffset) * 60 * 1000;			var date:Date = new Date(time + offset);			var add:int = convertDaysTohours? (date.date - 1) * 24 : 0;			return toDigits(date.hours + add, digitsH)+"h "+toDigits(date.minutes, digitsM)+"m "+toDigits(date.seconds, digitsS)+"s";		}						/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Sets a number to N digits.<p>		 * <p>		 * Adds zeros before the number to have the right number of digits.		 * 		 * @param number	number to format.		 * @param digits	number of digits to format the number to.		 * 		 * @return a string representing the number at X digits.		 */		private static function toDigits(number:int, digits:int):String {			var str:String = number.toString();			while(str.length < digits) str = "0"+str;			return str;		}			}}