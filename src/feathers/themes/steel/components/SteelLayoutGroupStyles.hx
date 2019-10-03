/*
	Feathers UI
	Copyright 2019 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.themes.steel.components;

import feathers.layout.VerticalAlign;
import feathers.layout.HorizontalAlign;
import feathers.layout.HorizontalLayout;
import feathers.controls.LayoutGroup;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import feathers.themes.steel.BaseSteelTheme;

/**
	Initialize "steel" styles for the `LayoutGroup` component.

	@since 1.0.0
**/
@:access(feathers.themes.steel.BaseSteelTheme)
class SteelLayoutGroupStyles {
	public static function initialize(?theme:BaseSteelTheme):Void {
		if (theme == null) {
			theme = Std.downcast(Theme.fallbackTheme, BaseSteelTheme);
		}
		if (theme == null) {
			return;
		}

		var styleProvider = theme.styleProvider;
		if (styleProvider.getStyleFunction(LayoutGroup, null) != null) {
			return;
		}

		styleProvider.setStyleFunction(LayoutGroup, LayoutGroup.VARIANT_TOOL_BAR, function(group:LayoutGroup):Void {
			if (group.backgroundSkin == null) {
				var backgroundSkin = new RectangleSkin();
				backgroundSkin.fill = theme.getHeaderFill();
				backgroundSkin.width = 44.0;
				backgroundSkin.height = 44.0;
				backgroundSkin.minHeight = 44.0;
				group.backgroundSkin = backgroundSkin;
			}
			if (group.layout == null) {
				var layout = new HorizontalLayout();
				layout.horizontalAlign = HorizontalAlign.LEFT;
				layout.verticalAlign = VerticalAlign.MIDDLE;
				layout.paddingTop = 4.0;
				layout.paddingRight = 10.0;
				layout.paddingBottom = 4.0;
				layout.paddingLeft = 10.0;
				layout.gap = 4.0;
				group.layout = layout;
			}
		});
	}
}