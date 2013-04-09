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

package com.adobe.lighthouse.util
{
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 * This is a utility class to delay a function call by a certain time period.
	 */ 
	public class FrameDelayedCall
	{
		private var curFrame : int = 0;
		private var numFrames : int = 0;
		private var func : Function;
		private var params : Array;
		private var thisObj : Object;
		
		/**
		 * Used to dispatch enterFrame events.
		 */
		private static const shape:Shape = new Shape();
		
		/**
		 * Constructor
		 * @param numFrames The number of frames to delay.
		 * @param func The function to execute.
		 * @param params The function parameters to pass.
		 * @param thisObject An optional 'this' that can be passed to the function, if needed.
		 */ 
		public function FrameDelayedCall( numFrames:int, func:Function, params:Array = null, thisObj:Object = null)
		{
			this.numFrames = numFrames;
			this.func = func;
			this.params = params;
			this.thisObj = thisObj;
		} 
		
		/**
		 * Convenience function to invoke a DelayedCall.
		 * @param delay The delay in milliseconds.
		 * @parma thisObj The object to invoke the function upon.
		 * @param func The function to execute.
		 * @param params The function parameters to pass.
		 * @param thisObject An optional 'this' that can be passed to the function, if needed.
		 */ 
		public static function invoke( numFrames:int, func:Function, params:Array = null, thisObj:Object = null ) : FrameDelayedCall
		{
			var dc : FrameDelayedCall = new FrameDelayedCall( numFrames, func, params, thisObj );
			dc.execute();
			return dc;
		}
		
		/**
		 * Execute the instantiated DelayedCall
		 */ 
		public function execute() : void
		{
			shape.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function cancel() : void
		{
			shape.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				
			func = null;
			params = null;
		}
		
		private function onEnterFrame( evt:Event ) : void
		{
			if ( ++curFrame >= numFrames )
			{
				func.apply( thisObj, params );
				cancel();
			}
		}
	}
}