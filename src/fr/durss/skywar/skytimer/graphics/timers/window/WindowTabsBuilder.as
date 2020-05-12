package fr.durss.skywar.skytimer.graphics.timers.window {	import com.nurun.components.vo.Margin;	import fr.durss.components.ui.tooltip.SimpleToolTip;	import fr.durss.components.ui.tooltip.ToolTipAlign;	import fr.durss.skywar.skytimer.data.SkinMetrics;	import com.nurun.components.form.FormComponentGroup;	import com.nurun.components.form.ToggleButton;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.utils.Dictionary;	/**	 * Displays the timer tabs on the window.	 * 	 * @author  François	 */	public class WindowTabsBuilder extends Sprite {				private var _items:Array;		private var _selectedIndex:int;		private var _toolTips:Dictionary;		private var _toolTip:SimpleToolTip;		private var _group:FormComponentGroup;		private var _indexes:Dictionary;						/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>TimerTab</code>		 */		public function WindowTabsBuilder() {			initialize();		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/**		 * Gets the currently selected index.		 */		public function get selectedIndex():int { return _selectedIndex; }				/**		 * Gets the visual height of the menu without taking consideration of the tooltip.		 */		override public function get height():Number { return ToggleButton(_items[0]).height; }		/**		 * Gets the currently selected index.		 */		public function set selectedIndex(value:int):void {			value = Math.min(Math.max(0, value), _items.length);			_selectedIndex = value;			ToggleButton(_items[value]).selected = true;		}						/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Adds a tab item to the builder.<p>		 * 		 * @param label		tab button's label.		 * @param tooltip	tooltip content to display at button's rollover.		 */		public function addTab(label:String, tooltip:String = ""):void{			var item:ToggleButton	= new ToggleButton(label, "windowTabLabel", "windowTabLabelSelected", SkinMetrics.getInstance().skinTabWindow, SkinMetrics.getInstance().skinTabWindowSelected);			item.y = -1;			item.height = 20;			item.contentMargin = new Margin(0, 0, 0, 0, 13, 5);			item.addEventListener(MouseEvent.CLICK,	clickItemHandler);			if(tooltip.length > 0) {				_toolTips[item] = tooltip;				item.addEventListener(MouseEvent.ROLL_OVER,	overItemHandler);				item.addEventListener(MouseEvent.ROLL_OUT,	outItemHandler);			}			_group.add(item);			_items.push(item);			addChildAt(item, 0);			computePositions();		}						/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initialize the class		 */		private function initialize():void {			_items			= [];			_toolTips		= new Dictionary();			_toolTip		= addChild(new SimpleToolTip()) as SimpleToolTip;			_toolTip.width	= 105;			_group			= new FormComponentGroup();			SkinMetrics.getInstance().addEventListener(Event.CHANGE, changeSkinHandler);		}				/**		 * Called when the skin is modified.		 */		private function changeSkinHandler(e:Event):void {			var i:int, len:int;			len = _items.length;			for (i = 0; i < len; ++i) {				ToggleButton(_items[i]).defaultBackground = SkinMetrics.getInstance().skinTabWindow;				ToggleButton(_items[i]).selectedBackground = SkinMetrics.getInstance().skinTabWindowSelected;			}		}		/**		 * Resize and replace the elements		 */		private function computePositions():void {			var i:int, px:int, len:int, item:ToggleButton;			len = _items.length;			px	= 0;			_indexes = new Dictionary();			for(i = 0; i < len; ++i) {				item		= _items[i] as ToggleButton;				item.x		= px;				px			+= item.width + 1;				_indexes[item] = i;			}		}				/**		 * Called when an item is clicked		 */		private function clickItemHandler(e:MouseEvent):void {			var index:int	= _indexes[_group.selectedItem];			if(index != _selectedIndex) {				_selectedIndex = index;				dispatchEvent(new Event(Event.CHANGE));			}		}				/**		 * Called when an item related to a tooltip is rolled over.		 */		private function overItemHandler(e:MouseEvent):void {			_toolTip.open(_toolTips[e.target] as String, "toolTipContent", ToolTipAlign.BOTTOM_RIGHT);		}		/**		 * Called when an item related to a tooltip is rolled out.		 */		private function outItemHandler(e:MouseEvent):void {			_toolTip.close();		}	}}