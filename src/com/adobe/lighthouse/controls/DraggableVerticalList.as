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
 * Very simple vertical list control which supports
 * a flick gesture to scroll.
 */

package com.adobe.lighthouse.controls
{
import com.adobe.lighthouse.constant.HorizontalSwipeDirections;
import com.adobe.lighthouse.events.HorizontalSwipeEvent;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.utils.Dictionary;
import flash.utils.getTimer;

import mx.effects.easing.Quartic;

/**
 * Dispatched when an item has been clicked.
 */
[Event(name="change", type="flash.events.Event")]

/**
 * Dispatched when a user has swiped horizontally before vertically.
 */
[Event(name="horizontalSwipe", type="com.adobe.lighthouse.events.HorizontalSwipeEvent")]

public class DraggableVerticalList extends UIControl
{
	/**
	 * Seconds.
	 */
	private static const ANIMATION_DURATION:Number = 1.25;
	
	private static const MIN_SCROLL_INDICATOR_HEIGHT:Number = 10;
	private static const SCROLL_FADE_TWEEN_DURATION:Number = .3;
	
	/**
	 * Right edge padding.
	 */
	private static const SCROLL_INDICATOR_RIGHT_PADDING:Number = 10;
	
	/**
	 * The number of buffer items beyond the edges.
	 * Set this to a high number so the renderers do not have to
	 * update as frequently.
	 */
	private static const NUM_BUFFER_ITEMS:Number = 25;
	
	/**
	  *  The max number of pixels to move the list after a mouseUp event.
	  */
	private static const MAX_PIXEL_MOVE:Number = 300;
	
	/**
	 * The min number of pixels to move the list after a mouseUp event.
	 * If the amount to scroll is less than this value the list will
	 * not scroll. This is to prevent inadvertant flicks when a user
	 * slowly drags the list.
	 */
	private static const MIN_PIXEL_MOVE:Number = 50;
	
	/**
	 * The number of frames to wait to calculate speed when flicking.
	 */
	private static const NUM_FRAMES_TO_MEASURE_SPEED:Number = 2;
	
	/**
	 * The amount the mouse can move before dragging.
	 */
	private static const START_TO_DRAG_THRESHOLD:Number = 10;
	
	/**
	 * The amount the mouse must move horizontally to trigger a HorizontalSwipeEvent.
	 */
	private static const HORIZONTAL_DRAG_THRESHOLD:Number = 40;
	
	/**
	 * The class to use for each item in the list.
	 * Must implement IItemRenderer and subclass UIControl.
	 */
	private var itemRendererClass:Class;
	
	/**
	 *  The y offset in which to layout the first item.
	 */
	private var itemYOffsetTop:Number;
	
	/**
	 * The amount of top padding between scrollIndicator and the top edge.
	 */
	private var scrollIndicatorTopPadding:Number;
	
	/**
	 * The amount of top padding between scrollIndicator and the top edge.
	 */
	private var scrollIndicatorBottomPadding:Number = 24;
	
	/**
	 * The height of each item.
	 */
	private var itemHeight:Number;
	
	private var itemContainer:Sprite;
	
	private var _selectedItem:Object;
	
	/**
	 * The target scroll value when a user flicks.
	 */
	private var targetScrollY:Number;
	
	/**
	 * The start scroll value when a user flicks.
	 */
	private var startScrollY:Number;
	
	/**
	 * The total amount to scroll when a user flicks.
	 */
	private var totalScrollY:Number;
	
	/**
	 * The amount a user has dragged the mouse between frames.
	 */
	private var deltaMouseY:Number;
	
	/**
	 * Used to calculate the number of pixel per millisecond when a user flicks.
	 */
	private var previousDragTime:Number;
	
	/**
	 * The value of the last drag mouseY.
	 * Used to calculate the number of pixel per millisecond when a user flicks.
	 */
	private var previousDragMouseY:Number;
	
	/**
	 * The scrollY when a user first starts to drag.
	 */
	private var beginDragScrollY:Number;
	
	/**
	 * The mouseY when a user first starts to drag.
	 */
	private var mouseYDown:Number;
	
	/**
	 * Used to track the y coords when a user is dragging.
	 */
	private var mouseDragCoords:Array;
	
	/**
	 * Used to track a mouse coord every other frame for more
	 * accurate measurement of speed.
	 * 
	 */
	private var enterFrameIndex:Number = 0;
	
	private var isDragging:Boolean;
	
	private var _dataProvider:Array;
	
	/**
	 * Stores the dataProvider index of the renderer.
	 * <DisplayObject, Number>
	 */
	private var dataProviderIndexHash:Dictionary;
	
	private var backgroundColor:Number;
	private var backgroundAlpha:Number;
	
	private var scrollIndicator:ScrollIndicator;
	
	/**
	 * The height of the scrollIndicator when a user has not dragged
	 * the content below the top edge or above the bottom edge,
	 * ie: scrollDelta > 0 && scrollDelta < 1
	 */
	private var scrollIndicatorHeight:Number;
	
	/**
	 * The difference between the scrollIndicator.height and _height.
	 */
	private var totalScrollAmount:Number;
	
	private var maxVirtualScrollY:Number;
	private var _virtualScrollY:Number = 0;
	private var beginDragVirtualScrollY:Number = 0;
	
	private var dataProviderChanged:Boolean;
	
	/**
	 * Stores itemRenderers not on the displaylist.
	 */
	private var itemRendererPool:Array;
	
	/**
	 * The renderer which was pressed.
	 */
	private var downItemRenderer:IItemRenderer;
	
	private var dispatchHorizontalSwipeEvents:Boolean;
	
	/**
	 * Used for detecting horizontal swipes.
	 */
	private var mouseXDown:Number;
	
	/**
	 * Properties for tweening a user flick.
	 */
	private var tweenCurrentCount:Number;
	private var tweenTotalCount:Number;
	
	/**
	 * Flag for whether or not updateRows() should be calculated.
	 */
	private var bUpdateRows:Boolean;
	
	/**
	 * Flag for whether or not the flick tween is still playing.
	 */
	private var isTweening:Boolean;
	
	/**
	 * Allows for the initial creation of itemRenderers when itemContainer is empty
	 * to be deferred until explicitly called.
	 * This is necessary because a high number of buffer items are used to maximize
	 * scrolling performance but there might be too much of a lag if they
	 * are created all at once.
	 */
	public var deferItemRendererCreation:Boolean;
	private var deferredItemRendererIndex:Number;
	
	private var oldHeight:Number;
	
	/**
	 * The amount to decrement the alpha for each frame.
	 */
	private var scrollIndicatorAlphaDelta:Number;
	
	private var doesScroll:Boolean;
	
	/**
	 * For the sake of simplicity, params are passed into the
	 * constructor rather than responding to new values after
	 * instantiation.
	 */
	public function DraggableVerticalList(itemHeight:Number,
										  itemRendererClass:Class,
										  backgroundColor:Number=0x000000,
										  backgroundAlpha:Number=1,
										  dispatchHorizontalSwipeEvents:Boolean=false,
										  itemYOffsetTop:Number=0,
										  scrollIndicatorTopPadding:Number=0,
										  scrollIndicatorBottomPadding:Number=0)
	{
		super();
		
		this.itemHeight = itemHeight;
		this.itemRendererClass = itemRendererClass;
		this.backgroundColor = backgroundColor;
		this.backgroundAlpha = backgroundAlpha;
		this.dispatchHorizontalSwipeEvents = dispatchHorizontalSwipeEvents;
		this.itemYOffsetTop = itemYOffsetTop;
		this.scrollIndicatorTopPadding = scrollIndicatorTopPadding;
		this.scrollIndicatorBottomPadding = scrollIndicatorBottomPadding;
		
		init();
	}
	
	private function init():void
	{
		mouseChildren = false;
		
		itemContainer = new Sprite();
		itemContainer.mouseEnabled = false;
		itemContainer.mouseChildren = false;
		itemContainer.opaqueBackground = 0xffffff;
		addChild(itemContainer);
		
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		
		dataProviderIndexHash = new Dictionary();
		
		mouseDragCoords = new Array();
	}
	
	private function addedToStageHandler(e:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		
		// Calculate how much to decrement the alpha per frame when scrollIndicator fades out.
		scrollIndicatorAlphaDelta = 1 / (SCROLL_FADE_TWEEN_DURATION * stage.frameRate);
	}
	
	private function removedFromStageHandler(e:Event):void
	{
		stopTween();
		
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, drag_mouseUpHandler);
		removeEventListener(Event.ENTER_FRAME, drag_enterFrameHandler);
	}
	
	private function getRenderer():IItemRenderer
	{
		if (itemRendererPool && itemRendererPool.length > 0)
			return itemRendererPool.shift();
		else
			return new itemRendererClass();
	}
	
	public function createDeferredRenderers():void
	{
		var len:Number = Math.ceil(_height / itemHeight) + NUM_BUFFER_ITEMS;
		len = Math.min(len, _dataProvider.length);
		for (var i:Number = deferredItemRendererIndex; i < len; i++)
		{
			var item:IItemRenderer = getRenderer();
			item.data = _dataProvider[i];
			item.selected = _dataProvider[i] == selectedItem;
			UIControl(item).width = width;
			UIControl(item).height = itemHeight;
			UIControl(item).validateNow();
			UIControl(item).y = i * itemHeight + itemYOffsetTop;
			itemContainer.addChild(DisplayObject(item));
			dataProviderIndexHash[item] = i;
		}
		
		bUpdateRows = itemContainer.numChildren < _dataProvider.length;
	}
	
	/**
	 * Stops the flick tween.
	 */
	private function stopTween():void
	{
		if (isTweening)
		{
			_virtualScrollY += targetScrollY - itemContainerScrollY;
			itemContainerScrollY = targetScrollY;
			stopAndReset();
			
			scrollIndicatorVisible = false;
		}
	}
	
	override protected function updateDisplayList(width:Number, height:Number):void
	{
		super.updateDisplayList(width, height);
		
		stopTween();
		
		if (_dataProvider)
		{
			itemContainer.scrollRect = new Rectangle(0, 0, width, height);
			graphics.clear();
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.drawRect(0, 0, width, height);
			
			var i:Number;
			var len:Number;
			var index:Number;
			
			var numDataItems:Number = _dataProvider.length;
			var totalHeight:Number = numDataItems * itemHeight;
			var item:IItemRenderer;
			
			doesScroll = totalHeight > height;
			
			// dataProvider changed so remove and reset the renderers in the list.
			if (dataProviderChanged)
			{
				// Delete the items in the hash.
				for (var s:Object in dataProviderIndexHash)
				{
					delete dataProviderIndexHash[s];
					IItemRenderer(s).data = null;
					IItemRenderer(s).selected = false;
				}
				
				if (!itemRendererPool)
					itemRendererPool = new Array();
				
				var displayObject:DisplayObject;
				while (itemContainer.numChildren)
				{
					displayObject = itemContainer.removeChildAt(itemContainer.numChildren - 1);
					itemRendererPool.push(displayObject);
					IItemRenderer(displayObject).data = null;
				}
				
				dataProviderChanged = false;
			}
			
			if (itemContainer.numChildren == 0)
			{
				// itemContainer is empty so add children. 
				len = Math.ceil(_height / itemHeight) + NUM_BUFFER_ITEMS;
				len = Math.min(len, _dataProvider.length);
				
				if (deferItemRendererCreation)
				{
					var numVisibleItems:Number = Math.ceil(_height / itemHeight);
					if (len > numVisibleItems)
					{
						len = numVisibleItems;
						deferredItemRendererIndex = numVisibleItems;
					}
				}
				
				for (i = 0; i < len; i++)
				{
					item = getRenderer();
					item.data = _dataProvider[i];
					item.selected = _dataProvider[i] == selectedItem;
					UIControl(item).y = i * itemHeight + itemYOffsetTop;
					itemContainer.addChild(DisplayObject(item));
					dataProviderIndexHash[item] = i;
				}
			}
			else
			{
				if (height > oldHeight)
				{
					if (totalHeight > _height)
					{
						len = itemContainer.numChildren;
						var lastItem:DisplayObject = itemContainer.getChildAt(itemContainer.numChildren - 1);
						if (lastItem.y < height)
						{
							// If lastItem maps to the last object in _dataProvider
							// make sure it does not go above the bottom edge.
							if (dataProviderIndexHash[lastItem] == numDataItems - 1)
							{
								itemContainerScrollY = oldHeight - height;
								resetScrollY();
								
								var firstItem:DisplayObject = itemContainer.getChildAt(0);
								// Add renderers to the top until the number of buffer items is filled.
								index = dataProviderIndexHash[firstItem] - 1;
								while(len * itemHeight - (NUM_BUFFER_ITEMS * itemHeight) < height)
								{
									if (index >= 0)
									{
										item = getRenderer();
										DisplayObject(item).y = firstItem.y - itemHeight;
										IItemRenderer(item).data = _dataProvider[index];
										IItemRenderer(item).selected = _dataProvider[index] == selectedItem;
										dataProviderIndexHash[item] = index;
										firstItem = itemContainer.addChildAt(DisplayObject(item), 0);
									}
									else
									{
										break;
									}
									
									index--;
									len = itemContainer.numChildren;
								}
							}
							else
							{
								// Add renderers to the bottom until the number of buffer items is filled.
								index = dataProviderIndexHash[lastItem] + 1;
								while(len * itemHeight - (NUM_BUFFER_ITEMS * itemHeight) < height)
								{
									if (index < _dataProvider.length)
									{
										item = getRenderer();
										
										DisplayObject(item).y = lastItem.y + itemHeight;
										IItemRenderer(item).data = _dataProvider[index];
										IItemRenderer(item).selected = _dataProvider[index] == selectedItem;
										dataProviderIndexHash[item] = index;
										lastItem = itemContainer.addChild(DisplayObject(item));
									}
									else
									{
										break;
									}
									
									index++;
									len = itemContainer.numChildren;
								}
							}
						}
					}
					else if (itemContainer.getChildAt(0).y != 0) // The total number of data items can fit the height so reset the positions.
					{
						itemContainerScrollY = itemContainer.getChildAt(0).y - itemYOffsetTop;
						resetScrollY();
					}
				}
			}
			
			len = itemContainer.numChildren;
			
			// Resize all of the children with the new width
			// and validate immediately.
			var uiControl:UIControl;
			for (i = 0; i < len; i++)
			{
				uiControl = UIControl(itemContainer.getChildAt(i));
				uiControl.width = width;
				uiControl.height = itemHeight;
				uiControl.validateNow();
			}
			
			if (totalHeight > height)
			{
				if (!scrollIndicator)
				{
					scrollIndicator = new ScrollIndicator();
					scrollIndicator.y = scrollIndicatorTopPadding;
					scrollIndicator.alpha = 0;
				}
				else
				{
					updateScrollIndicator();
				}
				
				if (!contains(scrollIndicator))
				{
					addChild(scrollIndicator);
					scrollIndicator.mouseEnabled = false;
					scrollIndicator.mouseChildren = false;
				}
				
				// Calculate the values used for sizing scrollIndicator.
				var availableScrollHeight:Number = 	_height - scrollIndicatorTopPadding - scrollIndicatorBottomPadding;
				scrollIndicatorHeight = Math.max(Math.round((availableScrollHeight / totalHeight) * availableScrollHeight), MIN_SCROLL_INDICATOR_HEIGHT);
				scrollIndicator.height = scrollIndicatorHeight;
				totalScrollAmount = _height - scrollIndicatorHeight - scrollIndicatorTopPadding - scrollIndicatorBottomPadding;
				maxVirtualScrollY = totalHeight - _height + itemYOffsetTop;
				
				if (_virtualScrollY > maxVirtualScrollY)
					_virtualScrollY = maxVirtualScrollY;
			}
			else
			{
				_virtualScrollY = 0;
				if (scrollIndicator && contains(scrollIndicator))
					removeChild(scrollIndicator);
			}
			
			if (scrollIndicator)
				scrollIndicator.x = _width - ScrollIndicator.WIDTH - SCROLL_INDICATOR_RIGHT_PADDING;
			
			// If there are less children than items in the dataProvider 
			// then the rows have to update as a user scrolls.
			bUpdateRows = itemContainer.numChildren < _dataProvider.length;
		}
	}
	
	public function set dataProvider(value:Array):void
	{
		if (_dataProvider)
			dataProviderChanged = true;
			
		_dataProvider = value;
		
		itemContainer.y = 0;
		_virtualScrollY = 0;
		
		scrollIndicatorVisible = false;
		
		invalidateDisplayList(this);
	}
	
	private function set scrollIndicatorVisible(value:Boolean):void
	{
		if (scrollIndicator)
		{
			removeEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
			scrollIndicator.alpha = value ? 1 : 0;
		}
	}
	
	public function get selectedItem():Object
	{
		return _selectedItem;
	}
	
	/**
	 * Selects the list item based on the data property.
	 * Does not show the item if it is not in the viewable area.
	 */
	public function set selectedItem(value:Object):void
	{
		if (value != _selectedItem)
		{
			var len:Number = itemContainer.numChildren;
			var item:IItemRenderer;
			for (var i:Number = 0; i < len; i++)
			{
				item = IItemRenderer(itemContainer.getChildAt(i));
				if (item.data == _selectedItem)
					item.selected = false;
				else if (item.data == value)
					item.selected = true;
			}
		}
		
		_selectedItem = value;
	}
	
 	private function mouseDownHandler(e:MouseEvent):void
	{
		// Use hitTestPoint() rather than listening for mouseDown on itemContainer
		// so all clicks on itemContainer register otherwise if a user clicks
		// between items then mouseDown will not fire.
		if (itemContainer.hitTestPoint(root.mouseX, root.mouseY))
		{
			isDragging = false;
			
			var wasTweening:Boolean = isTweening;
			
			// Occurs when the list is tweening above or below the edge.
			if (scrollDelta < 0 || scrollDelta > 1)
			{
				stopTween();
				wasTweening = false;
			}
			
			stopAndReset();
			
			enterFrameIndex = 0;
					
			deltaMouseY = 0;
			previousDragTime = getTimer();
			
			beginDragScrollY = itemContainerScrollY;
			mouseYDown = previousDragMouseY = root.mouseY;
			mouseXDown = root.mouseX;
			beginDragVirtualScrollY = _virtualScrollY;
			
			// Listen for a mouseMove first to detect the initial direction.
			// The handler is also used to detect dragging.
			stage.addEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, drag_mouseUpHandler);
			
			if (!wasTweening) // The list is still tweening so don't select anything for the down state. This gives a user the chance to stop the tween.
			{
				var len:Number = itemContainer.numChildren;
				var rect:Rectangle = new Rectangle(itemContainer.scrollRect.x + mouseX, itemContainer.scrollRect.y + mouseY, 1, 1);
				for (var i:Number = 0; i < len; i++)
				{
					var child:DisplayObject = itemContainer.getChildAt(i);
					if (new Rectangle(child.x, child.y, child.width, child.height).intersects(rect))
					{
						downItemRenderer = IItemRenderer(child);
						downItemRenderer.state = TouchStates.DOWN;
						break;
					}
				}
			}
			else
			{
				// Set isDragging=true so a selection is not triggered if a user mouseUps without moving the cursor.
				isDragging = true;
			}
		}
	}
	
	private function detectDirection_mouseMoveHandler(e:Event):void
	{
		if (Math.abs(mouseYDown - root.mouseY) > START_TO_DRAG_THRESHOLD)
		{
			isDragging = true;
			
			scrollIndicatorVisible = true;
			
			setDownItemRendererToUp();

			stage.removeEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler);			
			addEventListener(Event.ENTER_FRAME, drag_enterFrameHandler);
		}
			
		if (dispatchHorizontalSwipeEvents)
		{
			var deltaX:Number = mouseXDown - root.mouseX;
			// To avoid inadvertant swipes make sure the user moved HORIZONTAL_DRAG_THRESHOLD.
			// Accidental swipes are more common when using fingers.
			if (Math.abs(deltaX) > HORIZONTAL_DRAG_THRESHOLD)
			{
				var deltaY:Number = mouseYDown - root.mouseY;
				
				// Make sure the user moved more along the x-axis more than the y-axis.
				if (Math.abs(deltaX) > Math.abs(deltaY))
					dispatchEvent(new HorizontalSwipeEvent(HorizontalSwipeEvent.HORIZONTAL_SWIPE, false, false, deltaX < 0 ? HorizontalSwipeDirections.RIGHT : HorizontalSwipeDirections.LEFT));
			}
		}
	}
	
	/**
	 * Can be used after dispatching a HorizontalSwipeEvent if
	 * a listener would like to stop the vertical scrolling.
	 */
	public function stopVerticalScrolling():void
	{
		scrollIndicatorVisible = false;
		
		setDownItemRendererToUp();
		
		removeEventListener(Event.ENTER_FRAME, drag_enterFrameHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, drag_mouseUpHandler);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler);
	}
	
	private function setDownItemRendererToUp():void
	{
		if (downItemRenderer)
		{
			downItemRenderer.state = TouchStates.UP;
			downItemRenderer = null;
		}
	}
	
	private function drag_enterFrameHandler(e:Event):void
	{
		enterFrameIndex += 1;
		
		var yDelta:Number = mouseYDown - root.mouseY;
		
		_virtualScrollY = beginDragVirtualScrollY + yDelta;
		itemContainerScrollY = Math.round(beginDragScrollY + yDelta);
		
		if (enterFrameIndex % NUM_FRAMES_TO_MEASURE_SPEED)
		{
			deltaMouseY = root.mouseY - previousDragMouseY;
			previousDragTime = getTimer();
			previousDragMouseY = root.mouseY;
		}
		
		if (deltaMouseY != 0)
			updateRows(deltaMouseY < 0);// if deltaMouseY < 0 then mouse is moving up.

		mouseDragCoords.push(root.mouseY);
		
		updateScrollIndicator();
	}
	
	/**
	 * Returns the relative position as a percent of scrollIndicator.
	 * <= 0        below the top edge.
	 * > 0 && < 1  between the top and bottom edge.
	 * >= 1        above the bottom edge.
	 */
	private function get scrollDelta():Number
	{
		return _virtualScrollY / maxVirtualScrollY;
	}
	
	private function updateScrollIndicator():void
	{
		if (scrollIndicator)
		{
			var delta:Number = scrollDelta;
			var newHeight:Number;
			if (delta < 0) // user dragged below the top edge.
			{
				scrollIndicator.y = scrollIndicatorTopPadding;
				
				// _virtualScrollY will be < 0.
				// Shrink scrollIndicator.height by the amount a user has scrolled below the top edge.
				newHeight = _virtualScrollY + scrollIndicatorHeight;
				newHeight = Math.max(MIN_SCROLL_INDICATOR_HEIGHT, newHeight);
				scrollIndicator.height = Math.round(newHeight);
			}
			else if (delta < 1)
			{
				if (scrollIndicator.height != scrollIndicatorHeight)
					scrollIndicator.height = Math.round(scrollIndicatorHeight);
					
				var newY:Number = Math.round(delta * totalScrollAmount);
				newY = Math.min(_height - scrollIndicatorHeight - scrollIndicatorBottomPadding, newY + scrollIndicatorTopPadding);
					
				scrollIndicator.y = Math.round(newY);
			}
			else	// User dragged above the bottom edge.
			{
				// Shrink scrollIndicator.height by the amount a user has scrolled above the bottom edge.
				newHeight = scrollIndicatorHeight - (_virtualScrollY - maxVirtualScrollY);
				newHeight = Math.max(MIN_SCROLL_INDICATOR_HEIGHT, newHeight);
				
				scrollIndicator.height = Math.round(newHeight);
				scrollIndicator.y = Math.round(_height - newHeight - scrollIndicatorBottomPadding);
			}
		}
	}
	
	private function updateRows(draggingUp:Boolean):void
	{
		if (bUpdateRows)
		{
			var i:Number;
			var len:Number = itemContainer.numChildren;
			var item:DisplayObject;
			var lastItem:DisplayObject;
			var dataProviderIndex:Number;
			if (draggingUp)
			{
				var numItems:Number = len;
				for (i = 0; i < numItems; i++)
				{
					item = itemContainer.getChildAt(0);
					// Item is above the top of the mask, ie: not visible, so move it to the bottom.
					if ((item.y + itemHeight) < itemContainer.scrollRect.y)
					{
						// Get dataProviderIndex of the last child.
						dataProviderIndex = dataProviderIndexHash[itemContainer.getChildAt(len - 1)] + 1;
						if (dataProviderIndex < _dataProvider.length)
						{
							IItemRenderer(item).data = _dataProvider[dataProviderIndex];
							IItemRenderer(item).selected = _dataProvider[dataProviderIndex] == selectedItem;
							dataProviderIndexHash[item] = dataProviderIndex;
							item.y = itemContainer.getChildAt(len - 1).y + itemHeight; // Move the item to the bottom.
							itemContainer.setChildIndex(item, len - 1);
							// Since item is moved to the end of the child indices we want to decrement
							// the lookup index since the subsequent children index have changed.
							numItems -= 1;
						}
						else
						{
							break;
						}
					}
					else
					{
						break;
					}
				}
			}
			else // dragging down
			{
				for (i = len - 1; i >= 0; i--)
				{
					item = itemContainer.getChildAt(itemContainer.numChildren - 1);
					// Item is below the bottom of the mask, ie: not visible, so move it to the top.
					if ((item.y - itemContainer.scrollRect.y) > _height)
					{
						dataProviderIndex = dataProviderIndexHash[itemContainer.getChildAt(0)] - 1;
						if (dataProviderIndex >= 0)
						{
							IItemRenderer(item).data = _dataProvider[dataProviderIndex];
							IItemRenderer(item).selected = _dataProvider[dataProviderIndex] == selectedItem;
							dataProviderIndexHash[item] = dataProviderIndex;
							item.y = itemContainer.getChildAt(0).y - itemHeight;
							itemContainer.setChildIndex(item, 0);
						}
						else
						{
							break;
						}
					}
					else
					{
						break;
					}
				}
			}
		}
	}
	
	private function get itemContainerScrollY():Number
	{
		return itemContainer.scrollRect.y;
	}
	
	private function set itemContainerScrollY(value:Number):void
	{
		var rect:Rectangle = itemContainer.scrollRect;
		rect.y = value;
		itemContainer.scrollRect = rect;
	}
	
	private function drag_mouseUpHandler(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, detectDirection_mouseMoveHandler);
		removeEventListener(Event.ENTER_FRAME, drag_enterFrameHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, drag_mouseUpHandler);
		
		var len:Number;
		if (!isDragging)
		{
			// Fade out scrollIndicator.
			if (scrollIndicator)
				addEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
			
			// Deselect the current selected item.
			len = itemContainer.numChildren;
			for (var i:Number = 0; i < len; i++)
			{
				if (IItemRenderer(itemContainer.getChildAt(i)).data == _selectedItem)
				{
					IItemRenderer(itemContainer.getChildAt(i)).selected = false;
					break;
				}
			}
			
			if (downItemRenderer)
			{
				_selectedItem = downItemRenderer.data;
				downItemRenderer.selected = true;
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			setDownItemRendererToUp();
			
			isTweening = false;
		}
		else
		{
			// Calculate the speed between the last mouse moves which
			// will determine the speed in which to scroll the items.
			var elapsedMiliseconds:Number = getTimer() - previousDragTime;
			var pixelsPerMillisecond:Number = deltaMouseY / elapsedMiliseconds;
			
			if (doesScroll)
			{
				targetScrollY = Math.round(-pixelsPerMillisecond * MAX_PIXEL_MOVE + itemContainerScrollY);
				
				var targetVirtualScrollY:Number = _virtualScrollY + (targetScrollY - itemContainerScrollY);
				if (targetVirtualScrollY > maxVirtualScrollY)	// target is above the bottom edge.
					targetScrollY = itemContainerScrollY + maxVirtualScrollY - _virtualScrollY;
				else if (targetVirtualScrollY < 0)				// target is below the top edge.
					targetScrollY = itemContainerScrollY - _virtualScrollY;
					
				targetScrollY = Math.round(targetScrollY);
			}
			else
			{
				targetScrollY = 0;
			}
			
			var delta:Number = scrollDelta;
			var isFlick:Boolean = true;
			if (delta > 0 && delta < 1) // If not then scrollIndicator is below or above the top edge.
			{
				len = mouseDragCoords.length;
				// Compare the last coord (len - 1) and the one two before it (len - 3).
				// This is to ensure a user flicked the list. If a user is dragging the
				// list slowly there could be an inadvertant flick, so to avoid it
				// compare the two y coords.
				if (len > 3)
				{
					if (mouseDragCoords[len - 1] == mouseDragCoords[len - 3])
						isFlick = false;
				}
				
				if (Math.abs(itemContainerScrollY - targetScrollY) < MIN_PIXEL_MOVE)
					isFlick = false;
			}
			
			// Remove all of the elements from the array.
			mouseDragCoords.splice(0, mouseDragCoords.length);
			
			if (targetScrollY != itemContainerScrollY && isFlick)
			{
				//tweenScrollYTo = targetScrollY;
				doTween(targetScrollY);
			}
			else
			{
				// No flick so fade out scrollIndicator immediately.
				if (scrollIndicator)
					addEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
			}
		}
	}
	
	/**
	 * The amount to tween is the amount itemContainer.scrollRect.y will change.
	 */
	private function doTween(value:Number):void
	{
		targetScrollY = Math.round(value);
		
		startScrollY = itemContainerScrollY;
		totalScrollY = targetScrollY - startScrollY;
		
		tweenCurrentCount = 0;
		tweenTotalCount = Math.round(ANIMATION_DURATION * stage.frameRate);
		addEventListener(Event.ENTER_FRAME, tween_enterFrameHandler);
		
		isTweening = true;
	}
	
	/**
	 * Tweens the list items to a scrollY value.
	 */
	public function tweenScrollYTo(value:Number):void
	{
		if (doesScroll)
		{
			// If a tween is still in process then take the amount of the 
			// remaining tween and add it to the value passed in.
			if (isTweening)
			{
				value += targetScrollY - itemContainerScrollY;
				stopAndReset();
			}
			
			// Make sure the list does not scroll below the top edge and above the bottom edge.
			if (value > maxVirtualScrollY)
				value = maxVirtualScrollY;
			else if (value < 0)
				value = 0;
	
			scrollIndicatorVisible = true;
			if (_virtualScrollY != value)
				doTween(value - _virtualScrollY);
			else  // At the top or bottom scroll limits so fade out scrollIndicator.
				addEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
		}
	}
	
	private function tween_enterFrameHandler(e:Event):void
	{
		var previousScrollY:Number = itemContainerScrollY;
		var newScrollY:Number = Math.round(Quartic.easeOut(tweenCurrentCount, startScrollY, totalScrollY, tweenTotalCount));
		_virtualScrollY += newScrollY - previousScrollY;
		itemContainerScrollY = newScrollY;
		tweenCurrentCount += 1;
		
		updateScrollIndicator();
		
		if (itemContainerScrollY != previousScrollY)
			updateRows(itemContainerScrollY > previousScrollY);
			
		if (itemContainerScrollY == targetScrollY)
		{
			if (scrollIndicator)// Fade out scrollIndicator.
				addEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
			
			stopAndReset();
		}
	}
	
	/**
	 * The handler for fading out the scrollIndicator.
	 */
	private function scrollIndicatorFade_enterFrameHandler(e:Event):void
	{
		scrollIndicator.alpha -= scrollIndicatorAlphaDelta;
		
		if (scrollIndicator.alpha <= 0)
			removeEventListener(Event.ENTER_FRAME, scrollIndicatorFade_enterFrameHandler);
	}
	
	/**
	 * Shifts the x and scrollX coordinates of itemContainer
	 * based on the amount scrolled.
	 */
	private function stopAndReset():void
	{
		if (doesScroll)
			resetScrollY();
		
		removeEventListener(Event.ENTER_FRAME, tween_enterFrameHandler);
		
		isTweening = false;
	}
	
	private function resetScrollY():void
	{
		var delta:Number = itemContainerScrollY;
		if (delta != 0)
		{
			// Reset scrollY back to zero.
			itemContainerScrollY -= itemContainerScrollY;
			// Shift the children.
			var len:Number = itemContainer.numChildren;
			for (var i:Number = 0; i < itemContainer.numChildren; i++)
			{
				var item:DisplayObject = itemContainer.getChildAt(i);
				item.y -= delta;
			}
		}
	}
	
	override public function set height(value:Number):void
	{
		// Keep track of the oldHeight so we know whether or not to add
		// more items in updateDisplayList().
		oldHeight = _height;
		
		super.height = value;
	}
	
	public function get scrollY():Number
	{
		return _virtualScrollY;
	}
}
}