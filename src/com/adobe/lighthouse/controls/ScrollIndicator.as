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

package com.adobe.lighthouse.controls
{
import flash.display.DisplayObject;
import flash.display.Sprite;

public class ScrollIndicator extends Sprite
{
	public static const WIDTH:Number = 10;
	
	private static const TOP_SKIN_HEIGHT:Number = 3;
	private static const BOTTOM_SKIN_HEIGHT:Number = 3;
	
	[Embed(source="scroll_indicator_top.png")]
	private var topSkinClass:Class;
	
	[Embed(source="scroll_indicator_middle.png")]
	private var middleSkinClass:Class;
	
	[Embed(source="scroll_indicator_bottom.png")]
	private var bottomSkinClass:Class;
	
	private var topSkin:DisplayObject;
	private var middleSkin:DisplayObject;
	private var bottomSkin:DisplayObject;
	
	private var _height:Number;
	
	public function ScrollIndicator()
	{
		super();
		
		init();
	}
	
	private function init():void
	{
		topSkin = new topSkinClass();
		addChild(topSkin);
		
		middleSkin = new middleSkinClass();
		middleSkin.y = TOP_SKIN_HEIGHT;
		addChild(middleSkin);
		
		bottomSkin = new bottomSkinClass();
		addChild(bottomSkin);
	}
	
	override public function set height(value:Number):void
	{
		if (!isNaN(value) && value != _height)
		{
			middleSkin.height = Math.round(value - TOP_SKIN_HEIGHT - BOTTOM_SKIN_HEIGHT);
			bottomSkin.y = Math.round(middleSkin.height + TOP_SKIN_HEIGHT);
		}
		
		_height = value;
	}
}
}