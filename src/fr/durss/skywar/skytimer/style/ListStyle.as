package fr.durss.skywar.skytimer.style {
	import fl.controls.List;

	import fr.durss.skywar.skytimer.data.SkinMetrics;
	import fr.durss.skywar.skytimer.graphics.combo.CellDisableSelectedSkin;
	import fr.durss.skywar.skytimer.graphics.combo.CellDisableSkin;
	import fr.durss.skywar.skytimer.graphics.combo.CellDownSelectedSkin;
	import fr.durss.skywar.skytimer.graphics.combo.CellDownSkin;
	import fr.durss.skywar.skytimer.graphics.combo.CellOverSelectedSkin;
	import fr.durss.skywar.skytimer.graphics.combo.CellOverSkin;
	import fr.durss.skywar.skytimer.graphics.combo.CellUpSelectedSkin;
	import fr.durss.skywar.skytimer.graphics.combo.CellUpSkin;

	import com.nurun.utils.text.CssManager;

	/**
	 * Contains a static method to set the styles of a list
	 * 
	 * @author François
	 */
	public class ListStyle {

		//Vars declaration

		
		
		/* *********** *
		 * CONSTRUCTOR *
		 * *********** */
		public function ListStyle() { }

		
		
		/* ***************** *
		 * GETTERS / SETTERS *
		 * ***************** */



		/* ****** *
		 * PUBLIC *
		 * ****** */
		/**
		 * Sets the styles on a combobox.<p>
		 * 
		 * @param list				list on which apply the styles.
		 * @param itemCss			css style to use for item's labels.
		 * @param cellRenderer		cellrenderer to use for items.
		 */
		public static function setStyles(list:List, itemCss:String = "comboboxItem", cellRenderer:Class = null):void {
			list.setRendererStyle("embedFonts", true);
			list.rowHeight = 15;
			list.setRendererStyle("textFormat", CssManager.getInstance().getTextFormatOf(itemCss));
			if(cellRenderer != null) {
				list.setStyle("cellRenderer", cellRenderer);
			}
			setSkin(list);
		}
		
		/**
		 * Sets the list's skin.<br>
		 */
		public static function setSkin(list:List):void {
			if(SkinMetrics.getInstance().currentSkin == SkinMetrics.SKIN_DANGREN) {
				list.setRendererStyle("upSkin",					CellUpSkin);
				list.setRendererStyle("overSkin",				CellOverSkin);
				list.setRendererStyle("downSkin",				CellDownSkin);
				list.setRendererStyle("disabledSkin",			CellDisableSkin);
				list.setRendererStyle("selectedUpSkin",			CellUpSelectedSkin);
				list.setRendererStyle("selectedOverSkin",		CellOverSelectedSkin);
				list.setRendererStyle("selectedDownSkin",		CellDownSelectedSkin);
				list.setRendererStyle("selectedDisabledSkin",	CellDisableSelectedSkin);
			}else{
				list.setRendererStyle("upSkin",					CellRenderer_upSkin);
				list.setRendererStyle("overSkin",				CellRenderer_overSkin);
				list.setRendererStyle("downSkin",				CellRenderer_downSkin);
				list.setRendererStyle("disabledSkin",			CellRenderer_disabledSkin);
				list.setRendererStyle("selectedUpSkin",			CellRenderer_selectedUpSkin);
				list.setRendererStyle("selectedOverSkin",		CellRenderer_selectedOverSkin);
				list.setRendererStyle("selectedDownSkin",		CellRenderer_selectedDownSkin);
				list.setRendererStyle("selectedDisabledSkin",	CellRenderer_selectedDisabledSkin);
			}
		}


		
		
		/* ******* *
		 * PRIVATE *
		 * ******* */

	}
}