package fr.durss.skywar.skytimer.graphics.timers.window.combo {
	import fl.controls.listClasses.CellRenderer;

	import flash.display.Shape;

	/**
	 * Do the rendering of a color combobox's item.
	 * <p>
	 * To use it, define the <code>cellRenderer</code> style of the dropdown
	 * property of a combo box.
	 * <p>
	 * For example :
	 * <code>myCombo.dropdown.setStyle("cellRenderer", ColorItemCellRenderer);</code>
	 * 
	 * 
	 * @author Francois Dursus
	 */
	public class ColorItemCellRenderer extends CellRenderer {

		private var _rect:Shape;
						/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		public function ColorItemCellRenderer() {
			super();
			_rect = new Shape();
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

		override protected function draw():void {
			//Patch for combo bug.
			//If an item is selected and key up or down is pressed while the
			//component always has focus, this throws an error as if "super" was null...
			try {
				super.draw();
			}catch(e:Error) {}
			
			textField.x = 20;
			_rect.graphics.clear();			_rect.graphics.beginFill(data["data"] as Number, 1);
			_rect.graphics.drawRect(1, 1, 20, height - 2);
			addChildAt(_rect, getChildIndex(textField) - 1);
		}
		


	}
}