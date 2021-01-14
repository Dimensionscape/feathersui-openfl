/*
	Feathers UI
	Copyright 2021 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.controls;

import feathers.skins.RectangleSkin;
import feathers.layout.VerticalLayout;
import massive.munit.Assert;
import openfl.display.Shape;

@:keep
class LayoutGroupTest {
	private var _group:LayoutGroup;

	@Before
	public function prepare():Void {
		this._group = new LayoutGroup();
		TestMain.openfl_root.addChild(this._group);
	}

	@After
	public function cleanup():Void {
		if (this._group.parent != null) {
			this._group.parent.removeChild(this._group);
		}
		this._group = null;
		Assert.areEqual(0, TestMain.openfl_root.numChildren, "Test cleanup failed to remove all children from the root");
	}

	@Test
	public function testMeasureSkinWidthAndHeight():Void {
		var backgroundSkin = new RectangleSkin();
		backgroundSkin.width = 100.0;
		backgroundSkin.height = 150.0;
		this._group.backgroundSkin = backgroundSkin;
		this._group.validateNow();
		Assert.areEqual(backgroundSkin.width, this._group.width);
		Assert.areEqual(backgroundSkin.height, this._group.height);
	}

	@Test
	public function testMeasureSkinMinWidthAndMinHeight():Void {
		var backgroundSkin = new RectangleSkin();
		backgroundSkin.minWidth = 100.0;
		backgroundSkin.minHeight = 150.0;
		this._group.backgroundSkin = backgroundSkin;
		this._group.validateNow();
		Assert.areEqual(backgroundSkin.minWidth, this._group.width);
		Assert.areEqual(backgroundSkin.minHeight, this._group.height);
	}

	@Test
	public function testRemoveSkinAfterSetToNewValue():Void {
		var skin1 = new Shape();
		var skin2 = new Shape();
		Assert.isNull(skin1.parent);
		Assert.isNull(skin2.parent);
		this._group.backgroundSkin = skin1;
		this._group.validateNow();
		Assert.areEqual(this._group, skin1.parent);
		Assert.isNull(skin2.parent);
		this._group.backgroundSkin = skin2;
		this._group.validateNow();
		Assert.isNull(skin1.parent);
		Assert.areEqual(this._group, skin2.parent);
	}

	@Test
	public function testRemoveSkinAfterSetToNull():Void {
		var skin = new Shape();
		Assert.isNull(skin.parent);
		this._group.backgroundSkin = skin;
		this._group.validateNow();
		Assert.areEqual(this._group, skin.parent);
		this._group.backgroundSkin = null;
		this._group.validateNow();
		Assert.isNull(skin.parent);
	}

	@Test
	public function testRemoveSkinAfterDisable():Void {
		var skin1 = new Shape();
		var skin2 = new Shape();
		Assert.isNull(skin1.parent);
		Assert.isNull(skin2.parent);
		this._group.backgroundSkin = skin1;
		this._group.disabledBackgroundSkin = skin2;
		this._group.validateNow();
		Assert.areEqual(this._group, skin1.parent);
		Assert.isNull(skin2.parent);
		this._group.enabled = false;
		this._group.validateNow();
		Assert.isNull(skin1.parent);
		Assert.areEqual(this._group, skin2.parent);
	}

	@Test
	public function testInvalidateAfterLayoutChange():Void {
		var layout = new VerticalLayout();
		this._group.layout = layout;
		this._group.validateNow();
		Assert.isFalse(this._group.isInvalid());
		layout.gap = 1234.5;
		Assert.isTrue(this._group.isInvalid());
	}
}
