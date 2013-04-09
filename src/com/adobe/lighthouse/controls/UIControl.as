/**
 * Copyright (c) 2010 Adobe Systems Incorporated.
 * All rights reserved.
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

 /**
 * Base component for ui controls which handles
 * simple invalidation for width/height changes.
 */

package com.adobe.lighthouse.controls
{
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.Dictionary;
	
public class UIControl extends Sprite
{
	/**
	 * Used to dispatch enterFrame events for next frame validation.
	 */
	private static const enterFrameDispatcher:Shape = new Shape();
	
	private static const invalidateDisplayListQueue:Array = new Array();
	
	private static const DEFAULT_WIDTH:Number = 100;
	private static const DEFAULT_HEIGHT:Number = 100;
	
	protected var _width:Number;
	protected var _height:Number;
	
	public function UIControl()
	{
		super();

		// Set a default width/height to trigger invalidation.		
		width = DEFAULT_WIDTH;
		height = DEFAULT_HEIGHT;
	}
	
	public static function invalidateDisplayList(uiControl:UIControl):void
	{
		if (invalidateDisplayListQueue.length == 0)
			enterFrameDispatcher.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
		if (invalidateDisplayListQueue.indexOf(uiControl) == -1)
			invalidateDisplayListQueue.push(uiControl);
	}
	
	/**
	 * Handler for next frame updates.
	 */
	private static function enterFrameHandler(e:Event):void
	{
		enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		
		for each (var uiControl:UIControl in invalidateDisplayListQueue)
		{
			uiControl.updateDisplayList(uiControl.width, uiControl.height);
		}
		
		invalidateDisplayListQueue.splice(0);
	}
	
	/**
	 * Triggers an immediate call to updateDisplayList()
	 */
	public function validateNow():void
	{
		if (invalidateDisplayListQueue.indexOf(this) != -1)
			invalidateDisplayListQueue.splice(invalidateDisplayListQueue.indexOf(this), 1);
		
		if (invalidateDisplayListQueue.length == 0)
			enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		
		updateDisplayList(width, height);
	}
	
	/**
	 * Layout based on width/height should be handled in this method.
	 * Children should override.
	 */
	protected function updateDisplayList(width:Number, height:Number):void
	{
		
	}
	
	override public function set width(value:Number):void
	{
		// Only trigger validation if the height changed.
		if (value != _width)
		{
			_width = value;
			invalidateDisplayList(this);
		}
	}
	
	override public function get width():Number
	{
		return _width;
	}
	
	override public function set height(value:Number):void
	{
		// Only trigger validation if the height changed.
		if (value != _height)
		{
			_height = value;
			invalidateDisplayList(this);
		}
	}
	
	override public function get height():Number
	{
		return _height;
	}
}
}