package com.riameeting.utils 
{
	import com.riameeting.finger.config.ChartGlobal;
	/**
	 * ...
	 * @author 黄龙
	 */
	public class LabelResetTool 
	{
		
		public function LabelResetTool() 
		{
			
		}
		
		public static function reset(labels0:Array,labels1:Array,radius:Number):void
		{
			var length0:int = labels0.length;
			var length1:int = labels1.length;
			var slots:Array = [],slots1:Array=[];
			var pos:Number,j:Number,slotsLength:Number,labelHeight:Number,slotIndex:Number;
			if (labels0.length == 0 && labels1.length == 0) { return; }
			//labelHeight = labels0.length > 0?labels0[0].height:labels1[0].height;
			labelHeight =24;
			labels0.sortOn("y",Array.NUMERIC);
			labels1.sortOn("y", Array.NUMERIC);
			//2013年1月7日 15:08:10 标签调整到下面
			//for (pos =-radius*0.5; pos < radius*0.5-labelHeight*0.5; pos += labelHeight)
			for (pos =-radius*0.5+8; pos < radius*0.5-labelHeight+8; pos += labelHeight)
			{
				slots.push(pos);
				slots1.push(pos);
			}
			slotsLength = slots.length;
			var closest:Number = 999999,distance:Number,slotI:Number;
			var labelPos:Number;
			for (j = 0; j < length0; j++) {
				closest = 999999;
				labelPos= labels0[j].y;
				//找到最近的位置索引
				for (slotI = 0; slotI < slotsLength; slotI++) {
					distance = Math.abs(slots[slotI] -labelPos);
					if (distance < closest) {
						closest = distance;
						slotIndex = slotI;
					}
				}
				if (slotIndex < j && slots[j] != null) 
				{
					slotIndex = j;
				} else if (slotsLength  < length0 - j + slotIndex && slots[j] != null) { // cluster at the bottom
					slotIndex = slotsLength - length0 + j;
					while (slots[slotIndex] == null) { // make sure it is not taken
							slotIndex++;
					}
				} else {
					// Slot is taken, find next free slot below. In the next run, the next slice will find the
					// slot above these, because it is the closest one
					while (slots[slotIndex] == null) { // make sure it is not taken
						slotIndex++;
					}
				}
				//usedSlots.push( { i: slotIndex, y: slots[slotIndex] } );
				labels0[j].y = slots[slotIndex];
				slots[slotIndex] = null; // mark as taken
			}
			slotIndex = 0;
			slots = slots1;
			for (j = 0; j < length1; j++) {
				closest = 999999;
				labelPos= labels1[j].y;
				//找到最近的位置索引
				for (slotI = 0; slotI < slotsLength; slotI++) {
					distance = Math.abs(slots[slotI] -labelPos);
					if (distance < closest) {
						closest = distance;
						slotIndex = slotI;
					}
				}
				if (slotIndex < j && slots[j] != null) 
				{
					slotIndex = j;
				} else if (slotsLength  < length1 - j + slotIndex && slots[j] != null) { // cluster at the bottom
					slotIndex = slotsLength - length1 + j;
					while (slots[slotIndex] == null) { // make sure it is not taken
							slotIndex++;
					}
				} else {
					// Slot is taken, find next free slot below. In the next run, the next slice will find the
					// slot above these, because it is the closest one
					while (slots[slotIndex] == null) { // make sure it is not taken
						slotIndex++;
					}
				}
				//usedSlots.push( { i: slotIndex, y: slots[slotIndex] } );
				labels1[j].y = slots[slotIndex];
				slots[slotIndex] = null; // mark as taken
			}
			//usedSlots.sortOn("y");
			ChartGlobal.drawOver = true;
		}
	}

}