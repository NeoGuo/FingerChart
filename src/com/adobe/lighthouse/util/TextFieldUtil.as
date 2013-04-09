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
import flash.text.TextField;
	
public class TextFieldUtil
{
	private static const ELLIPSES:String = "...";
	
	public static function truncate(textField:TextField, text:String):void
	{
		textField.text = text;
		// If the textHeight is greater than the height of the textField then truncate.
		if (textField.textHeight >= textField.height)
		{
			// Remove strings until the textHeight is shorter than the height.
			while (textField.textHeight >= textField.height)
			{
				text = text.substring(0, text.length - 1);
				textField.text = text;
			}
			
			// Get the metrics of the last line.
			var lastChar:String = text.substring(textField.text.length - 1);
			
			if (lastChar != ".")
			{
				var previousHeight:Number = textField.textHeight;
				textField.appendText(ELLIPSES);

				text = textField.text;
				if (textField.textHeight > textField.height)
				{
					// textField added a line with the ellipses so remove the ellipses
					// and the same amount of additional characters in order to add
					// the ellipses back in without a new line.
					text = text.substring(0, text.length - ELLIPSES.length * 2) + ELLIPSES;
				}
				
				var len:Number = text.length;
				// Loop backwards and look for the first space before the ellipses.
				for (var i:Number = len - ELLIPSES.length; i > 0; i--)
				{
					if (text.substring(i - 1, i) == " ")
					{
						// Remove the space.
						text = text.substring(0, i - 1);
						
						// Add the ellipses back if the last character is not a period.
						if (text.substring(text.length - 1) != ".")
							textField.text = text + (ELLIPSES);

						break;
					}
				}
			} 
			
			if (textField.text == ELLIPSES)
				textField.text = "";
		}
	}
}
}