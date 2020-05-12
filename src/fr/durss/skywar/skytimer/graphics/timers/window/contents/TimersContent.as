package fr.durss.skywar.skytimer.graphics.timers.window.contents {	import fl.controls.ComboBox;	import fr.durss.components.ui.form.input.TextInput;	import fr.durss.skywar.skytimer.components.SubmitButton;	import fr.durss.skywar.skytimer.data.SharedObjectManager;	import fr.durss.skywar.skytimer.data.SkinMetrics;	import fr.durss.skywar.skytimer.events.WindowTimerEditionEvent;	import fr.durss.skywar.skytimer.graphics.common.TimeInput;	import fr.durss.skywar.skytimer.graphics.sessionselector.vo.Session;	import fr.durss.skywar.skytimer.graphics.timers.Timers;	import fr.durss.skywar.skytimer.graphics.timers.item.TimerItem;	import fr.durss.skywar.skytimer.graphics.timers.window.CustomAssetsSelector;	import fr.durss.skywar.skytimer.graphics.timers.window.contents.vo.Tag;	import fr.durss.skywar.skytimer.style.ComboStyle;	import com.nurun.components.text.CssTextField;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.ui.Keyboard;	/**	 * Displays the timer's  form window's content.	 * 	 * @author  François	 */	public class TimersContent extends Sprite implements WindowContent {		private var _labelName:CssTextField;		private var _labelTime:CssTextField;		private var _labelAssets:CssTextField;		private var _labelSession:CssTextField;		private var _timerName:TextInput;		private var _timeInput:TimeInput;		private var _submitButton:SubmitButton;		private var _skinSelector:CustomAssetsSelector;		private var _sessionSelector:ComboBox;				private var _width:Number;		private var _opened:Boolean;		private var _timers:Timers;		private var _itemToEdit:TimerItem;								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>TimersContent</code>		 */		public function TimersContent(timers:Timers) {			_timers = timers;			addEventListener(Event.ADDED_TO_STAGE, initialize);		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/**		 * Sets the width of the component without simply scaling it.		 */		override public function set width(value:Number):void { _width = value; computePositions(); }		/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Opens the content		 */		public function open(itemToEdit:TimerItem = null, duration:Number = 0):void {			_opened = true;			visible = true;			_itemToEdit = itemToEdit;			_timerName.tabIndex	= 0;			_timeInput.setTabIndexes(1, 2, 3);			_skinSelector.setTabIndexes(4, 5);			_sessionSelector.tabIndex = 6;			if(_itemToEdit != null) {				_timerName.textfield.text	= _itemToEdit.name;				_timeInput.timestamp		= _itemToEdit.clock.restingTime;				_submitButton.label			= "Modifier";				_skinSelector.preselect(_itemToEdit.sound, _itemToEdit.color);			} else{				_submitButton.label			= "Créer";			}			if(duration > 0) {				_timeInput.timestamp		= duration;			}						var i:int, len:int, sessions:Array, session:Session;			sessions = SharedObjectManager.getInstance().getSessions();			len = sessions.length;			_sessionSelector.removeAll();			_sessionSelector.addItem({label:"- session par défaut -", data:SharedObjectManager.DEFAULT_SESSION.id});			for(i = 0; i < len; ++i) {				session = new Session(sessions[i]);				if(session.id == SharedObjectManager.DEFAULT_SESSION.id) continue;				_sessionSelector.addItem({label:session.name, data:session.id});				if(session.id == SharedObjectManager.getInstance().currentSessionId) {					_sessionSelector.selectedIndex = i + 1;				}			}						_submitButton.enabled = true;			stage.focus	= _timerName;			computePositions();		}				/**		 * Called when window is closed to remove the tab indexes		 */		public function close():void {			_opened = false;			visible = false;			_timerName.tabIndex	= -1;			_timeInput.setTabIndexes(-1, -1, -1);			_skinSelector.setTabIndexes(-1, -1);			_sessionSelector.tabIndex = -1;			_submitButton.enabled = false;			_skinSelector.close();			_sessionSelector.close();		}								/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initialize the class		 */		private function initialize(e:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, initialize);			visible = false;						_timerName		= addChild(new TextInput("inputName")) as TextInput;			_timeInput		= addChild(new TimeInput()) as TimeInput;			_submitButton	= addChild(new SubmitButton()) as SubmitButton;			_labelName		= addChild(new CssTextField("windowLabel")) as CssTextField;			_labelTime		= addChild(new CssTextField("windowLabel")) as CssTextField;			_labelAssets	= addChild(new CssTextField("windowLabel")) as CssTextField;			_labelSession	= addChild(new CssTextField("windowLabel")) as CssTextField;						_labelName.setText("Nom du timer");			_labelTime.setText("Durée du timer");			_labelAssets.setText("Configurations");			_labelSession.setText("Session associée");						_skinSelector	= addChild(new CustomAssetsSelector()) as CustomAssetsSelector;			_sessionSelector= addChild(new ComboBox()) as ComboBox;						_timerName.addEventListener(Event.CHANGE,			changeNameHandler);			_timeInput.addEventListener(Event.RENDER,			computePositions);			_submitButton.addEventListener(MouseEvent.CLICK,	submitHandler);			stage.addEventListener(KeyboardEvent.KEY_UP,		keyUpHandler);			SkinMetrics.getInstance().addEventListener(Event.CHANGE, changeSkinHandler);						changeSkinHandler();		}		/**		 * Resize and replace the elements		 */		private function computePositions(e:Event = null):void {			_timerName.width		= _width;			_skinSelector.width		= _width;			_sessionSelector.width	= _width;						_timerName.y		= Math.round(_labelName.y + _labelName.height);			_labelTime.y		= Math.round(_timerName.y + _timerName.height) + 5;			_timeInput.y		= Math.round(_labelTime.y + _labelTime.height);			_labelAssets.y		= Math.round(_timeInput.y + _timeInput.height) + 5;			_skinSelector.y		= Math.round(_labelAssets.y + _labelAssets.height) + 2;			_labelSession.y		= Math.round(_skinSelector.y + _skinSelector.height) + 5;			_sessionSelector.y	= Math.round(_labelSession.y + _labelSession.height) + 2;						_submitButton.x		= Math.round((_width - _submitButton.width) * .5);			_submitButton.y		= Math.round(_sessionSelector.y + _sessionSelector.height) + 5;		}				/**		 * Called when the skin changes.<br>		 */		private function changeSkinHandler(e:Event = null):void {			ComboStyle.setStyles(_sessionSelector);			_submitButton.background = SkinMetrics.getInstance().skinSubmitButton;		}										//__________________________________________________________ KEYBOARD EVENTS		/**		 * Called when a key is released to submit the form on ENTER key.		 */		private function keyUpHandler(e:KeyboardEvent):void {			if(e.keyCode == Keyboard.ENTER && _opened) {				submitHandler();			}		}				/**		 * Called when timer's name is modified.<p>		 * <p>		 * Checks for tags and loads associated presets.		 */		private function changeNameHandler(e:Event):void {			var i:int, len:int, tag:Tag, tags:Array;						tags	= SharedObjectManager.getInstance().getTags();			len		= tags.length;			for(i = 0; i < len; ++i) {				tag	= new Tag(tags[i]);				if(_timerName.textfield.text.indexOf(tag.name) > -1) {					_timerName.textfield.text	= _timerName.textfield.text.replace(tag.name, "");					_skinSelector.preselect(tag.sound, tag.color);					break;				}			}		}								//__________________________________________________________ MOUSE EVENTS		/**		 * Called when submit button is clicked		 */		private function submitHandler(e:MouseEvent = null):void {			if(_itemToEdit != null) {				_itemToEdit.name	= _timerName.textfield.text;				_itemToEdit.sound	= _skinSelector.sound;				_itemToEdit.color	= _skinSelector.color;				_itemToEdit.sessionID = _sessionSelector.selectedItem.data;				_itemToEdit.clock.seekTo(_timeInput.timestamp);			} else{				var timer:TimerItem	= _timers.addTimer(_timerName.textfield.text, _timeInput.timestamp, _sessionSelector.selectedItem.data);				timer.sound			= _skinSelector.sound;				timer.color			= _skinSelector.color;			}			close();			dispatchEvent(new WindowTimerEditionEvent(WindowTimerEditionEvent.EDIT_TIMER, _itemToEdit));		}			}}