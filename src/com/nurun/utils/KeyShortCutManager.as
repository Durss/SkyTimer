package com.nurun.utils {
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	/**
	* Manages keyboard shortcuts.
	* 
	* @author François Dursus
	*/
	public class KeyShortCutManager extends EventDispatcher
	{
		
		//Vars declaration
		public static const PREFIX				: String	= "onShortCut";
		public static const SEPARATOR			: String	= "_";
		private static var _instance			: KeyShortCutManager;
		
		private var _target				: Stage;
		private var _keyStack			: Array;
		private var _keysDown			: Dictionary;
		private var _lastShortCut		: String;
		private var _displayShortCuts	: Boolean = false;

		
		
		
		
		
		/*******************
		 *** CONSTRUCTOR ***
		 ******************/
		/**
		 * Creates an instance of <code>KeyShortCutManager</code>.<br>
		 */
		public function KeyShortCutManager(enforcer:SingletonEnforcer) {
			if(enforcer == null) {
				throw new IllegalOperationError("Do not instanciate this class! Use getInstance static method instead.");
			}
		}
		
		
		
		
		
		
		/*************************
		 *** GETTERS / SETTERS ***
		 ************************/
		/**
		 * Singleton instance getter
		 */
		public static function getInstance():KeyShortCutManager {
			if(_instance == null)_instance = new KeyShortCutManager(new SingletonEnforcer());
			return _instance;	
		}
		
		/**
		 * Get / set if the dispatched shortcuts should be traced
		 */
		public function get reportShortCuts():Boolean			{ return _displayShortCuts; }
		public function set reportShortCuts(value:Boolean):void	{ _displayShortCuts = value; }
		
		
		
		
		
		
		/**********************
		 *** PUBLIC METHODS ***
		 *********************/
		/**
		 * Start key detection
		 */
		public function start(target:Stage):void {
			if (_target == null) {
				_keyStack	= [];
				_keysDown	= new Dictionary();
				_target 	= target;
				_target.addEventListener(KeyboardEvent.KEY_DOWN,	onKeyDownHandler);
				_target.addEventListener(KeyboardEvent.KEY_UP,		onKeyUpHandler);
			}
		}
		
		
		
		
		
		
		/***********************
		 *** PRIVATE METHODS ***
		 **********************/
		/**
		 * Called on key down event
		 * @param	e : event object
		 */
		private function onKeyDownHandler(e:KeyboardEvent):void {
			if (_keysDown[e.keyCode] == null ) {
				_keysDown[e.keyCode] = e.keyCode;
				_keyStack.push(e.keyCode);
				dispatchShortCut();
			}
		}
		
		/**
		 * Called on key up event
		 * @param	e : event object
		 */
		private function onKeyUpHandler(e:KeyboardEvent):void {
			for (var i:int = 0; i < _keyStack.length; i++) {
				if (_keyStack[i] == e.keyCode) break;
			}
			_keyStack.splice(i, 1);
			_keysDown[e.keyCode] = null;
			dispatchShortCut();
		}
		
		/**
		 * Dispatch the current shortcut event
		 */
		private function dispatchShortCut():void {
			var shortCut:String = PREFIX + SEPARATOR + _keyStack.join(SEPARATOR);
			if (shortCut != _lastShortCut && _keyStack.length > 0 ) {
				if (_displayShortCuts)	trace("ShortCut :: \""+shortCut+"\"");
				_lastShortCut = shortCut;
				dispatchEvent(new Event(shortCut));
			}
		}
		
	}
	
}

internal class SingletonEnforcer{}