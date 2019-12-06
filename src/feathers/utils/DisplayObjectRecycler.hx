/*
	Feathers UI
	Copyright 2019 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.utils;

import haxe.Constraints.Constructible;
import openfl.display.DisplayObject;

/**
	Manages display objects that may be used to render data, in a component like
	`ListBox` or `TabBar`.

	@since 1.0.0
**/
class DisplayObjectRecycler<T:B & DisplayObject & Constructible<() -> Void>, S, B> {
	/**
		Creates a new `DisplayObjectRecycler` object with the given arguments.

		@since 1.0.0
	**/
	public function new(create:ObjectFactory<T>, ?update:(target:T, state:S) -> Void, ?reset:(target:T, state:S) -> Void, ?destroy:(T) -> Void) {
		this.create = create;
		// these are all allowed to be null
		this.update = update;
		this.reset = reset;
		this.destroy = destroy;
	}

	/**
		Updates the properties an existing display object. It may be a display
		object that was used previously, but it will have been passed to
		`reset()` first, to ensure that it has been restored to its original
		state when it was returned from `create()`.

		@since 1.0.0
	**/
	public dynamic function update(target:T, state:S):Void {};

	/**
		Prepares a display object to be used again. This method should restore
		the display object to its original state from when it was returned by
		`create()`.

		@since 1.0.0
	**/
	public dynamic function reset(target:T, state:S):Void {}

	/**
		Creates a new display object.

		@since 1.0.0
	**/
	public dynamic function create():T {
		return null;
	}

	/**
		Destroys/disposes a display object when it will no longer be used.

		@since 1.0.0
	**/
	public dynamic function destroy(target:T):Void {}
}