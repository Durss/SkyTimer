package fr.durss.skywar.skytimer.components {	import com.nurun.components.button.TextAlign;	import fr.durss.skywar.skytimer.data.SkinMetrics;	import com.nurun.components.form.ToggleButton;	import com.nurun.components.vo.Margin;	import flash.display.DisplayObject;	import flash.display.MovieClip;	/**	 * Creates a submit button.	 * 	 * @author  Francois	 */	public class SubmitButton extends ToggleButton {		private var _toggle:Boolean;								/* *********** *		 * CONSTRUCTOR *		 * *********** */		/**		 * Creates an instance of <code>SubmitButton</code>.<br>		 */		public function SubmitButton(label:String = "", defaultIcon:DisplayObject = null, selectedIcon:DisplayObject = null) {			super(label, "submitButton", "submitButtonSelected", SkinMetrics.getInstance().skinSubmitButton, SkinMetrics.getInstance().skinSubmitSelectedButton, defaultIcon as MovieClip, selectedIcon as MovieClip);			super.icon = icon;			textAlign = TextAlign.CENTER;		}						/* ***************** *		 * GETTERS / SETTERS *		 * ***************** */		/**		 * Sets if the button can be toggled or not.		 */		public function set toggle(value:Boolean):void {			_toggle = value;		}						/* ****** *		 * PUBLIC *		 * ****** */		/**		 * Updates the skin.		 */		public function changeSkin():void {			defaultBackground	= SkinMetrics.getInstance().skinSubmitButton;			selectedBackground	= SkinMetrics.getInstance().skinSubmitSelectedButton;		}						/* ******* *		 * PRIVATE *		 * ******* */		/**		 * Initialize the class.<br>		 */		override protected function initialize():void {			super.initialize();			height = 23;			contentMargin = new Margin(0, 0, 0, 0, 30, 6);			super.updateSkin();		}				/**		 * Updates the skin.		 */		override protected function updateSkin():void {			if(!_toggle) {				_selected = false;			}			super.updateSkin();		}	}}