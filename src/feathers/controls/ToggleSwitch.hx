/*
	Feathers
	Copyright 2019 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.controls;

import feathers.style.IStyleObject;
import feathers.core.IValidating;
import openfl.display.DisplayObject;
import feathers.core.InvalidationFlag;
import feathers.layout.Measurements;
import feathers.core.IUIControl;
import openfl.display.InteractiveObject;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.events.Event;
import feathers.events.FeathersEvent;
import feathers.core.FeathersControl;

/**
	@since 1.0.0
**/
class ToggleSwitch extends FeathersControl implements IToggle {
	public function new() {
		super();
		this.addEventListener(MouseEvent.CLICK, toggleSwitch_clickHandler);
	}

	override private function get_styleContext():Class<IStyleObject> {
		return ToggleSwitch;
	}

	public var selected(default, set):Bool = false;

	private function set_selected(value:Bool):Bool {
		if (this.selected == value) {
			return this.selected;
		}
		this.selected = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		this.setInvalid(InvalidationFlag.SELECTION);
		return this.selected;
	}

	private var thumbContainer:Sprite;
	private var _thumbSkinMeasurements:Measurements = null;

	/**
		@see `ToggleSwitch.trackSkin`
	**/
	@style
	public var thumbSkin(default, set):DisplayObject = null;

	private function set_thumbSkin(value:DisplayObject):DisplayObject {
		if (!this.setStyle("thumbSkin")) {
			return this.thumbSkin;
		}
		if (this.thumbSkin == value) {
			return this.thumbSkin;
		}
		if (this.thumbSkin != null) {
			if (this.thumbContainer != null) {
				this.thumbContainer.removeEventListener(MouseEvent.MOUSE_DOWN, thumbSkin_mouseDownHandler);
				this.thumbContainer.removeChild(this.thumbSkin);
				this.removeChild(this.thumbContainer);
				this.thumbContainer = null;
			} else {
				this.thumbSkin.removeEventListener(MouseEvent.MOUSE_DOWN, thumbSkin_mouseDownHandler);
				this.removeChild(this.thumbSkin);
			}
		}
		this.thumbSkin = value;
		if (this.thumbSkin != null) {
			if (Std.is(this.thumbSkin, IUIControl)) {
				cast(this.thumbSkin, IUIControl).initializeNow();
			}
			if (this._thumbSkinMeasurements == null) {
				this._thumbSkinMeasurements = new Measurements(this.thumbSkin);
			} else {
				this._thumbSkinMeasurements.save(this.thumbSkin);
			}
			if (!Std.is(this.thumbSkin, InteractiveObject)) {
				// if the skin isn't interactive, we need to add it to something
				// that is interactive
				this.thumbContainer = new Sprite();
				this.thumbContainer.addChild(this.thumbSkin);
				this.addChild(this.thumbContainer);
				this.thumbContainer.addEventListener(MouseEvent.MOUSE_DOWN, thumbSkin_mouseDownHandler);
			} else {
				// add it above the trackSkin and secondaryTrackSkin
				this.addChild(this.thumbSkin);
				this.thumbSkin.addEventListener(MouseEvent.MOUSE_DOWN, thumbSkin_mouseDownHandler);
			}
		} else {
			this._thumbSkinMeasurements = null;
		}
		this.setInvalid(InvalidationFlag.STYLES);
		return this.thumbSkin;
	}

	private var _trackSkinMeasurements:Measurements = null;

	/**
		@see `ToggleSwitch.secondaryTrackSkin`
		@see `ToggleSwitch.thumbSkin`
	**/
	@style
	public var trackSkin(default, set):DisplayObject = null;

	private function set_trackSkin(value:DisplayObject):DisplayObject {
		if (!this.setStyle("trackSkin")) {
			return this.trackSkin;
		}
		if (this.trackSkin == value) {
			return this.trackSkin;
		}
		if (this.trackSkin != null && this.trackSkin.parent == this) {
			this.removeChild(this.trackSkin);
		}
		this.trackSkin = value;
		if (this.trackSkin != null) {
			if (Std.is(this.trackSkin, IUIControl)) {
				cast(this.trackSkin, IUIControl).initializeNow();
			}
			if (this._trackSkinMeasurements == null) {
				this._trackSkinMeasurements = new Measurements(this.trackSkin);
			} else {
				this._trackSkinMeasurements.save(this.trackSkin);
			}
			// always on the bottom
			this.addChildAt(this.trackSkin, 0);
		} else {
			this._trackSkinMeasurements = null;
		}
		this.setInvalid(InvalidationFlag.STYLES);
		return this.trackSkin;
	}

	private var _secondaryTrackSkinMeasurements:Measurements = null;

	/**
		@see `ToggleSwitch.trackSkin`
	**/
	@style
	public var secondaryTrackSkin(default, set):DisplayObject = null;

	private function set_secondaryTrackSkin(value:DisplayObject):DisplayObject {
		if (!this.setStyle("secondaryTrackSkin")) {
			return this.secondaryTrackSkin;
		}
		if (this.secondaryTrackSkin == value) {
			return this.secondaryTrackSkin;
		}
		if (this.secondaryTrackSkin != null && this.secondaryTrackSkin.parent == this) {
			this.removeChild(this.secondaryTrackSkin);
		}
		this.secondaryTrackSkin = value;
		if (this.secondaryTrackSkin != null) {
			if (Std.is(this.secondaryTrackSkin, IUIControl)) {
				cast(this.secondaryTrackSkin, IUIControl).initializeNow();
			}
			if (this._secondaryTrackSkinMeasurements == null) {
				this._secondaryTrackSkinMeasurements = new Measurements(this.secondaryTrackSkin);
			} else {
				this._secondaryTrackSkinMeasurements.save(this.secondaryTrackSkin);
			}

			// on the bottom or above the trackSkin
			var index = this.trackSkin != null ? 1 : 0;
			this.addChildAt(this.secondaryTrackSkin, index);
		} else {
			this._secondaryTrackSkinMeasurements = null;
		}
		this.setInvalid(InvalidationFlag.STYLES);
		return this.secondaryTrackSkin;
	}

	/**
		The minimum space, in pixels, between the toggle switch's right edge and
		the right edge of the thumb.

		In the following example, the toggle switch's right padding is set to 20
		pixels:

		```hx
		toggle.paddingRight = 20;</listing>
		```

		@default 0

		@since 1.0.0
	**/
	@style
	public var paddingRight(default, set):Null<Float> = null;

	private function set_paddingRight(value:Null<Float>):Null<Float> {
		if (!this.setStyle("paddingRight")) {
			return this.paddingRight;
		}
		if (this.paddingRight == value) {
			return this.paddingRight;
		}
		this.paddingRight = value;
		this.setInvalid(InvalidationFlag.STYLES);
		return this.paddingRight;
	}

	/**
		The minimum space, in pixels, between the toggle switch's left edge and
		the left edge of the thumb.

		In the following example, the toggle switch's left padding is set to 20
		pixels:

		```hx
		toggle.paddingLeft = 20;</listing>
		```

		@default 0

		@since 1.0.0
	**/
	@style
	public var paddingLeft(default, set):Null<Float> = null;

	private function set_paddingLeft(value:Null<Float>):Null<Float> {
		if (!this.setStyle("paddingLeft")) {
			return this.paddingLeft;
		}
		if (this.paddingLeft == value) {
			return this.paddingLeft;
		}
		this.paddingLeft = value;
		this.setInvalid(InvalidationFlag.STYLES);
		return this.paddingLeft;
	}

	override private function update():Void {
		var selectionInvalid = this.isInvalid(InvalidationFlag.SELECTION);
		var sizeInvalid = this.isInvalid(InvalidationFlag.SIZE);
		var stateInvalid = this.isInvalid(InvalidationFlag.STATE);
		var stylesInvalid = this.isInvalid(InvalidationFlag.STYLES);

		if (selectionInvalid) {
			this.refreshSelection();
		}

		if (stateInvalid) {
			this.refreshEnabled();
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		this.layoutContent();
	}

	private function autoSizeIfNeeded():Bool {
		var needsWidth = this.explicitWidth == null;
		var needsHeight = this.explicitHeight == null;
		var needsMinWidth = this.explicitMinWidth == null;
		var needsMinHeight = this.explicitMinHeight == null;
		var needsMaxWidth = this.explicitMaxWidth == null;
		var needsMaxHeight = this.explicitMaxHeight == null;
		if (!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight && !needsMaxWidth && !needsMaxHeight) {
			return false;
		}

		if (this.thumbSkin != null) {
			this._thumbSkinMeasurements.restore(this.thumbSkin);
			if (Std.is(this.thumbSkin, IValidating)) {
				cast(this.thumbSkin, IValidating).validateNow();
			}
		}
		if (this.trackSkin != null) {
			this._trackSkinMeasurements.restore(this.trackSkin);
			if (Std.is(this.trackSkin, IValidating)) {
				cast(this.trackSkin, IValidating).validateNow();
			}
		}
		if (this.secondaryTrackSkin != null) {
			this._secondaryTrackSkinMeasurements.restore(this.secondaryTrackSkin);
			if (Std.is(this.secondaryTrackSkin, IValidating)) {
				cast(this.secondaryTrackSkin, IValidating).validateNow();
			}
		}

		var newWidth = this.explicitWidth;
		if (needsWidth) {
			newWidth = this.trackSkin.width;
			if (this.secondaryTrackSkin != null) {
				newWidth += this.secondaryTrackSkin.width;
			}
		}

		var newHeight = this.explicitHeight;
		if (needsHeight) {
			newHeight = this.thumbSkin.height;
			if (newHeight < this.trackSkin.height) {
				newHeight = this.trackSkin.height;
			}
			if (this.secondaryTrackSkin != null && newHeight < this.secondaryTrackSkin.height) {
				newHeight = this.secondaryTrackSkin.height;
			}
		}

		// TODO: calculate min and max
		var newMinWidth = newWidth;
		var newMinHeight = newHeight;
		var newMaxWidth = newWidth;
		var newMaxHeight = newHeight;

		return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight, newMaxWidth, newMaxHeight);
	}

	private function refreshSelection():Void {
		if (Std.is(this.thumbSkin, IToggle)) {
			cast(this.thumbSkin, IToggle).selected = this.selected;
		}
		if (Std.is(this.trackSkin, IToggle)) {
			cast(this.trackSkin, IToggle).selected = this.selected;
		}
		if (Std.is(this.secondaryTrackSkin, IToggle)) {
			cast(this.secondaryTrackSkin, IToggle).selected = this.selected;
		}
	}

	private function refreshEnabled():Void {
		if (Std.is(this.thumbSkin, IUIControl)) {
			cast(this.thumbSkin, IUIControl).enabled = this.enabled;
		}
		if (Std.is(this.trackSkin, IUIControl)) {
			cast(this.trackSkin, IUIControl).enabled = this.enabled;
		}
		if (Std.is(this.secondaryTrackSkin, IUIControl)) {
			cast(this.secondaryTrackSkin, IUIControl).enabled = this.enabled;
		}
	}

	private function layoutContent():Void {
		this.layoutThumb();
		if (this.trackSkin != null && this.secondaryTrackSkin != null) {
			this.layoutSplitTrack();
		} else {
			this.layoutSingleTrack();
		}
	}

	private function layoutThumb():Void {
		if (Std.is(this.thumbSkin, IValidating)) {
			cast(this.thumbSkin, IValidating);
		}

		// uninitialized styles need some defaults
		var paddingRight = this.paddingRight != null ? this.paddingRight : 0.0;
		var paddingLeft = this.paddingLeft != null ? this.paddingLeft : 0.0;

		if (this.selected) {
			this.thumbSkin.x = this.actualWidth - this.thumbSkin.width - paddingRight;
		} else {
			this.thumbSkin.x = paddingLeft;
		}
		this.thumbSkin.y = Math.round((this.actualHeight - this.thumbSkin.height) / 2);
	}

	private function layoutSplitTrack():Void {
		var location = this.thumbSkin.x + this.thumbSkin.width / 2.0;

		this.trackSkin.x = 0;
		this.trackSkin.width = location;

		this.secondaryTrackSkin.x = location;
		this.secondaryTrackSkin.width = this.actualWidth - location;

		if (Std.is(this.trackSkin, IValidating)) {
			cast(this.trackSkin, IValidating).validateNow();
		}
		if (Std.is(this.secondaryTrackSkin, IValidating)) {
			cast(this.secondaryTrackSkin, IValidating).validateNow();
		}

		this.trackSkin.y = (this.actualHeight - this.trackSkin.height) / 2;
		this.secondaryTrackSkin.y = (this.actualHeight - this.secondaryTrackSkin.height) / 2;
	}

	private function layoutSingleTrack():Void {
		if (this.trackSkin == null) {
			return;
		}
		this.trackSkin.x = 0;
		this.trackSkin.width = this.actualWidth;

		if (Std.is(this.trackSkin, IValidating)) {
			cast(this.trackSkin, IValidating).validateNow();
		}

		this.trackSkin.y = (this.actualHeight - this.trackSkin.height) / 2;
	}

	private function thumbSkin_mouseDownHandler(event:MouseEvent):Void {}

	private function toggleSwitch_clickHandler(event:MouseEvent):Void {
		this.selected = !this.selected;
	}
}