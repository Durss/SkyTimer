package fr.durss.skywar.skytimer.errors {

	/**
	 * Error thrown if a cross dependency is made.
	 * 
	 * @author Francois
	 */
	public class DependencyConflictError extends Error {
		private var _plugs:Array;

		public function DependencyConflictError(plugs:Array, message:* = "Cross dependencies founded.", id:* = "XDEP") {
			_plugs = plugs;
			super(message, id);
		}
		
		public function get plugs():Array {
			return _plugs;
		}
	}
}
