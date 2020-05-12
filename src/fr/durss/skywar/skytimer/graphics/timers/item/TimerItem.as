package fr.durss.skywar.skytimer.graphics.timers.item {	import fr.durss.skywar.skytimer.components.STGraphicButton;	import fr.durss.skywar.skytimer.data.SharedObjectManager;	import fr.durss.skywar.skytimer.data.SkinMetrics;	import fr.durss.skywar.skytimer.events.CustomTimerEvent;	import fr.durss.skywar.skytimer.events.DragEvent;	import fr.durss.skywar.skytimer.events.TimerItemEvent;	import fr.durss.skywar.skytimer.graphics.TimerItemGraphics;	import fr.durss.skywar.skytimer.sounds.Buzzer;	import fr.durss.skywar.skytimer.time.CustomTimer;	import gs.TweenLite;	import com.nurun.components.text.CssTextField;	import flash.display.BitmapData;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.filters.DropShadowFilter;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;	import flash.text.TextFieldAutoSize;	import flash.utils.getTimer;	/**	 * Displays a timer item.	 * 	 * @author François	 */	public class TimerItem extends Sprite {		private var _name:String;		private var _labelTxt:CssTextField;		private var _scrollH:Number;		private var _inc:Number;		private var _lastDirectionChange:Number;		private var _dragging:Boolean;		private var _sound:Sound;		private var _background:TimerItemGraphics;		private var _close:STGraphicButton;		private var _timer:CustomTimer;		private var _timerBar:TimerBar;		private var _controlBar:ControlBar;		private var _soundBar:SoundBar;		private var _maskBar:Sprite;		private var _sessionID:String;		private var _plugger:TimerItemPlugger;		private var _parentTimer:TimerItem;						/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>TimerItem</code> class.<p>		 * <p>		 * The second parameter is optional. But if this parameter isn't		 * specified, the <code>clock</code> setter SHOULD be called or the		 * timer will not have any clock.		 * 		 * @param name		name of the timer.		 * @param duration	duration of the timer in milliseconds.		 */		public function TimerItem(name:String, duration:Number = -1) {			_name		= name;			initialize();			if(duration != -1) {				clock	= new CustomTimer(duration);				clock.start();			}			_sound = new Buzzer();			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/**		 * Gets the timer's height.		 */		override public function get height():Number { return _background.height; }
		/**		 * Gets the timer's name.		 */		override public function get name():String { return _name; }				/**		 * Sets the timer's name.		 */		override public function set name(value:String):void {			_name = value;			_labelTxt.setText(value);			computePositions();		}				/**		 * Gets a bitmapdata clone of the item.		 */		public function get bitmapData():BitmapData {			var bmpd:BitmapData = new BitmapData(width, height, true, 0);			bmpd.draw(this);			return bmpd;		}				/**		 * Gets the inner clock of the timer item.		 */		public function get clock():CustomTimer	{ return _timer; }				/**		 * Sets the timer's clock		 */		public function set clock(value:CustomTimer):void {			if(_timer != null) {				_timer.removeEventListener(CustomTimerEvent.COMPLETE,	timerCompleteHandler);				_timer.stop();			}			_timer = value;			_timer.addEventListener(CustomTimerEvent.COMPLETE,	timerCompleteHandler);			_timerBar.timer		= _timer;			_controlBar.timer	= _timer;			_maskBar.alpha		= _timer.paused? .7 : 0;		}				/**		 * Sets the sound to play once timer completes.		 */		public function set sound(value:Sound):void		{ if(value != null) _sound = value; }				/**		 * Gets the volume percent of the sound.		 * 		 * @return sound's volume in percent. Between 0 and 1.		 */		public function get volume():Number				{ return _soundBar.percent; }				/**		 * Sets the volume percent of the sound.		 * 		 * @param value	sound's volume in percent. Between 0 and 1.		 */		public function set volume(value:Number):void	{ _soundBar.percent = value; }		/**		 * Sets the progress bar color.		 */		public function set color(value:Number):void	{			if(!isNaN(value)){				_timerBar.color = value;				_soundBar.color = value;			}		}				/**		 * Gets the sound's reference.		 */		public function get sound():Sound { return _sound; }				/**		 * Gets the progress bar color.		 */		public function get color():Number { return _timerBar.color; }						/**		 * Sets the session ID on which the item is registered.		 */		public function set sessionID(value:String):void { _sessionID = value; }				/**		 * Gets the session ID on which the item is registered.		 */		public function get sessionID():String { return _sessionID; }				/**		 * Gets the plugger reference.		 */		public function get plugger():TimerItemPlugger { return _plugger; }						/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Traces the class		 */		override public function toString():String {			return "[TimerItem :: name=\"" + name + "\", duration=\"" + ((_timer != null)? _timer.duration : null) + "\", sessionID=\"" + _sessionID + "\"]";		}				/**		 * Makes the item garbage collectable		 */		public function dispose():void {			removeChild(_background);			removeChild(_labelTxt);			removeChild(_timerBar);			removeChild(_maskBar);			removeChild(_close);			removeChild(_soundBar);			removeChild(_controlBar);						_controlBar.removeEventListener(MouseEvent.ROLL_OVER,	controlbarOverHandler);			_controlBar.removeEventListener(MouseEvent.ROLL_OUT,	controlbarOutHandler);			_controlBar.removeEventListener(TimerItemEvent.EDIT,	dispatchEvent);			_controlBar.removeEventListener(TimerItemEvent.LOOP,	dispatchEvent);			_controlBar.removeEventListener(TimerItemEvent.PAUSE,	dispatchEvent);			_soundBar.removeEventListener(TimerItemEvent.CHANGE_SOUND,dispatchEvent);			_close.removeEventListener(MouseEvent.CLICK,			closeHandler);			_timer.removeEventListener(CustomTimerEvent.COMPLETE,	timerCompleteHandler);			removeEventListener(MouseEvent.MOUSE_DOWN,				mouseEventHandler);			removeEventListener(MouseEvent.MOUSE_UP,				mouseEventHandler);			removeEventListener(MouseEvent.MOUSE_OVER,				mouseOverHandler);			removeEventListener(MouseEvent.MOUSE_OUT,				mouseOutHandler);			SkinMetrics.getInstance().removeEventListener(Event.CHANGE, changeSkinHandler);						_timer.dispose();			_close.dispose();			_timerBar.dispose();			_plugger.dispose();		}				/**		 * Sets the parent timer to wait the complete for.<br>		 * <br>		 * Used by the DependencyManager when a new depencendy is created or deleted.		 * 		 * @param value		<code>TimerItem</code> to wait the complete for before starting. Set to null to remove the dependency.		 */		public function setParentTimer(value:TimerItem):void {			if(_parentTimer != null) {				_parentTimer.removeEventListener(TimerItemEvent.COMPLETE, parentTimerCompleteHandler);			}			_parentTimer = value;			if(value != null && !value.clock.complete) {				_timer.pause();			}else if(!_timer.complete) {				_timer.start();			}			if(_parentTimer != null) {				_parentTimer.addEventListener(TimerItemEvent.COMPLETE, parentTimerCompleteHandler);			}			_controlBar.timer	= _timer;			_maskBar.visible	= true;			_maskBar.alpha		= _timer.paused? .7 : 0;		}				/**		 * Gets the parent timer to wait the complete for to start.		 */		public function getParentTimer():TimerItem {			return _parentTimer;		}								/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initialize the component		 */		private function initialize():void {			_inc		= 1;			_scrollH	= 0;			_lastDirectionChange= getTimer();						_background			= addChild(new TimerItemGraphics()) as TimerItemGraphics;			_labelTxt			= addChild(new CssTextField()) as CssTextField;			_timerBar			= addChild(new TimerBar()) as TimerBar;			_maskBar			= addChild(SkinMetrics.getInstance().skinTimerBarMask) as Sprite;			_close				= addChild(new STGraphicButton(SkinMetrics.getInstance().skinCloseButton)) as STGraphicButton;			_soundBar			= addChild(new SoundBar()) as SoundBar;			_controlBar			= addChild(new ControlBar()) as ControlBar;			_plugger			= addChild(new TimerItemPlugger(this)) as TimerItemPlugger;						_labelTxt.height	= 17;			_labelTxt.autoSize	= TextFieldAutoSize.NONE;			_labelTxt.setText(_name, "timerName");						_maskBar.alpha			= 0;			_soundBar.percent		= .5;			_timerBar.mouseChildren	= false;			_timerBar.mouseEnabled	= false;			_labelTxt.mouseEnabled	= false;			_maskBar.mouseEnabled	= false;			_timerBar.filters		= [new DropShadowFilter(3,90,0,.8,5,5,1,3,true)];			_background.gotoAndStop(SkinMetrics.getInstance().frame);						_controlBar.addEventListener(MouseEvent.ROLL_OVER,	controlbarOverHandler);			_controlBar.addEventListener(MouseEvent.ROLL_OUT,	controlbarOutHandler);			_controlBar.addEventListener(TimerItemEvent.EDIT,	dispatchEvent);			_controlBar.addEventListener(TimerItemEvent.LOOP,	dispatchEvent);			_controlBar.addEventListener(TimerItemEvent.PAUSE,	dispatchEvent);			_soundBar.addEventListener(TimerItemEvent.CHANGE_SOUND,dispatchEvent);			_close.addEventListener(MouseEvent.CLICK,			closeHandler);			addEventListener(MouseEvent.MOUSE_DOWN,				mouseEventHandler);			addEventListener(MouseEvent.MOUSE_UP,				mouseEventHandler);			addEventListener(MouseEvent.MOUSE_OVER,				mouseOverHandler);			addEventListener(MouseEvent.MOUSE_OUT,				mouseOutHandler);			SkinMetrics.getInstance().addEventListener(Event.CHANGE, changeSkinHandler);						computePositions();		}		/**		 * Called when the component is added to the stage		 */		private function addedToStageHandler(e:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, initialize);			stage.addEventListener(MouseEvent.MOUSE_UP,	mouseEventHandler);		}		/**		 * Resize / replace the elements		 */		private function computePositions():void {			_close.x			= SkinMetrics.getInstance().closeButtonPos.x;			_close.y			= SkinMetrics.getInstance().closeButtonPos.y;						_timerBar.x			= SkinMetrics.getInstance().timerBarRect.x;			_timerBar.y			= SkinMetrics.getInstance().timerBarRect.y;			_timerBar.width		= SkinMetrics.getInstance().timerBarRect.width;			_timerBar.height	= SkinMetrics.getInstance().timerBarRect.height;						_controlBar.x		= SkinMetrics.getInstance().controlBarPos.x;			_controlBar.y		= SkinMetrics.getInstance().controlBarPos.y;			_controlBar.width	= SkinMetrics.getInstance().timerBarRect.width;			_soundBar.x			= SkinMetrics.getInstance().soundButtonPos.x;			_soundBar.y			= SkinMetrics.getInstance().soundButtonPos.y;						_maskBar.x			=  SkinMetrics.getInstance().timerBarMaskPos.x;			_maskBar.y			=  SkinMetrics.getInstance().timerBarMaskPos.y;						_labelTxt.x			= 20;			_labelTxt.y			= 5;			_labelTxt.width		= 165;						if(_labelTxt.textWidth > _labelTxt.width) {				if(!hasEventListener(Event.ENTER_FRAME)) {					addEventListener(Event.ENTER_FRAME,	enterFrameHandler);				}			}else{				removeEventListener(Event.ENTER_FRAME,	enterFrameHandler);			}		}				/**		 * Called when the skin is modified.		 */		private function changeSkinHandler(e:Event = null):void {			removeChild(_maskBar);			_maskBar			= addChildAt(SkinMetrics.getInstance().skinTimerBarMask, getChildIndex(_timerBar)+1) as Sprite;			_maskBar.alpha		= _timer.paused? .7 : 0;			_close.background	= SkinMetrics.getInstance().skinCloseButton;			_background.gotoAndStop(SkinMetrics.getInstance().frame);			computePositions();		}		/**		 * Called on mouse down / up of the item		 */		private function mouseEventHandler(e:MouseEvent):void {			if(e.type == MouseEvent.MOUSE_DOWN) {				if(e.target == _background) {					_dragging = true;					dispatchEvent(new DragEvent(DragEvent.DRAG_START));				}			}else if(e.type == MouseEvent.MOUSE_UP) {				if((e.currentTarget == stage && _dragging) || e.target == _background) {					_dragging = false;					dispatchEvent(new DragEvent(DragEvent.DRAG_COMPLETE));				}			}		}				/**		 * Called on roll over		 */		private function controlbarOverHandler(e:MouseEvent):void {			TweenLite.to(_maskBar, .5, {alpha:.7});			TweenLite.to(_controlBar, .5, {alpha:1});		}		/**		 * Called on roll out		 */		private function controlbarOutHandler(e:MouseEvent):void {			if(!_timer.paused) {				TweenLite.to(_maskBar, .5, {alpha:0});			}			TweenLite.to(_controlBar, .5, {alpha:0});		}				/**		 * Called on timer's roll over.		 */		private function mouseOverHandler(e:MouseEvent):void {			if(e.target == _background) {				dispatchEvent(new TimerItemEvent(TimerItemEvent.SHOW_TOOLTIP));			}			if(e.target == _plugger.outputRef) {				dispatchEvent(new TimerItemEvent(TimerItemEvent.SHOW_PLUG_IN));			}			if(e.target == _plugger.inputRef) {				dispatchEvent(new TimerItemEvent(TimerItemEvent.SHOW_PLUG_OUT));			}		}				/**		 * Called on timer's roll out.		 */		private function mouseOutHandler(e:MouseEvent):void {			if(e.target == _background) {				dispatchEvent(new TimerItemEvent(TimerItemEvent.HIDE_TOOLTIP));			}			if(e.target == _plugger.inputRef || e.target == _plugger.outputRef) {				dispatchEvent(new TimerItemEvent(TimerItemEvent.HIDE_PLUG));			}		}		/**		 * Called when close button is clicked		 */		private function closeHandler(e:MouseEvent):void {			stage.focus = null;			dispatchEvent(new TimerItemEvent(TimerItemEvent.CLOSE));		}		/**		 * Called when the timer completes		 */		private function timerCompleteHandler(e:CustomTimerEvent):void {			if(!SharedObjectManager.getInstance().soundMuted && _sound != null) {				var channel:SoundChannel = _sound.play();				if(channel != null) {					channel.soundTransform = new SoundTransform(_soundBar.percent * 2);				}			}			dispatchEvent(new TimerItemEvent(TimerItemEvent.COMPLETE));		}				/**		 * Called when parent timer completes.<br>		 * <br>		 * Used when the timer has a dependency to another one.		 */		private function parentTimerCompleteHandler(e:TimerItemEvent):void {			_timer.start();			_controlBar.timer	= _timer;			_maskBar.visible	= true;			_maskBar.alpha		= _timer.paused? .7 : 0;		}		/**		 * Called on ENTER_FRAME event to scroll the textfield if necessary and		 * update the timer bar.		 */		private function enterFrameHandler(e:Event):void {			if(getTimer() - _lastDirectionChange > 1500) {				_scrollH += _inc;				_labelTxt.scrollH = Math.max(0, Math.min(_labelTxt.maxScrollH, _scrollH));			}			if((_labelTxt.scrollH == _labelTxt.maxScrollH && _inc > 0) || (_labelTxt.scrollH == 0 && _inc < 0)) {				_lastDirectionChange = getTimer();				_inc = -_inc;			}
		}	}}