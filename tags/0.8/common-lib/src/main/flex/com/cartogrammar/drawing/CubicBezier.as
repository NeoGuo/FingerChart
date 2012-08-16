/* Cubic Bézier curve tools
*	@author:		Andy Woodruff (http://cartogrammar.com/blog || awoodruff@gmail.com)
*	@date:			May 2008, updated January 2009
*	@description:	Contains methods for drawing a single cubic Bézier curve and for drawing
*					a continuous series of curves through specified points.
*					Updates in January 2009:
*						- moveTo argument in curveThroughPoints (used on line 200)
*						- some math corrections in lines 152-163, which I hope fix problems caused by 0 angles and such
*						- introduced an option (though not from outside this class) to use lineTo on straight segments rather than curving (affects lines 208-224)
*					Previous version is at http://cartogrammar.com/source/CubicBezier_May08.as in case I screwed something up. Sorry about the lack of proper versioning!
*/

package com.cartogrammar.drawing{
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import fl.motion.BezierSegment;
	
	public class CubicBezier{
		
		/** pubic static function drawCurve
		 *	Draws a single cubic Bézier curve
		 *	@param:
		 *		g:Graphics			-Graphics on which to draw the curve
		 *		p1:Point			-First point in the curve
		 *		p2:Point			-Second point (control point) in the curve
		 *		p3:Point			-Third point (control point) in the curve
		 *		p4:Point			-Fourth point in the curve
		 *	@return:
		 */	
		public static function drawCurve(g:Graphics, p1:Point, p2:Point, p3:Point, p4:Point):void{
			var bezier:BezierSegment = new BezierSegment(p1,p2,p3,p4);	// BezierSegment using the four points
			g.moveTo(p1.x,p1.y);
			// Construct the curve out of 100 segments (adjust number for less/more detail)
			for (var t:Number=.01;t<1.01;t+=.01){
				var val:Object = bezier.getValue(t);	// x,y on the curve for a given t
				g.lineTo(val.x,val.y);
			}
		}
		
		/** public static function curveThroughPoints
		 *	Draws a smooth curve through a series of points. For a closed curve, make the first and last points the same.
		 *	@param:
		 *		g:Graphics			-Graphics on which to draw the curve
		 *		p:Array				-Array of Point instances
		 *		z:Number			-A factor (between 0 and 1) to reduce the size of curves by limiting the distance of control points from anchor points.
		 *							 For example, z=.5 limits control points to half the distance of the closer adjacent anchor point.
		 *							 I put the option here, but I recommend sticking with .5
		 *		angleFactor:Number	-Adjusts the size of curves depending on how acute the angle between points is. Curves are reduced as acuteness
		 *							 increases, and this factor controls by how much.
		 *							 1 = curves are reduced in direct proportion to acuteness
		 *							 0 = curves are not reduced at all based on acuteness
		 *							 in between = the reduction is basically a percentage of the full reduction
		 *		moveTo:Bollean		-Specifies whether to move to the first point in the curve rather than continuing drawing
		 * 							 from wherever drawing left off.
		 *	@return:
		 */	
		public static function curveThroughPoints(g:Graphics, points:Array/*of Points*/, z:Number = .5, angleFactor:Number = .75, moveTo:Boolean = true):void{
			try {
				var p:Array = points.slice();	// Local copy of points array
				var duplicates:Array = new Array();	// Array to hold indices of duplicate points
				// Check to make sure array contains only Points
				for (var i:Number=0; i<p.length; i++){
					if (!(p[i] is Point)){
						throw new Error("Array must contain Point objects");
					}
					// Check for the same point twice in a row
					if (i > 0){
						if (p[i].x == p[i-1].x && p[i].y == p[i-1].y){
							duplicates.push(i);	// add index of duplicate to duplicates array
						}
					}
				}
				// Loop through duplicates array and remove points from the points array
				for (i=duplicates.length-1; i>=0; i--){
					p.splice(duplicates[i],1);
				}
				
				// Make sure z is between 0 and 1 (too messy otherwise)
				if (z <= 0){
					z = .5;
				} else if (z > 1){
					z = 1;
				}
				// Make sure angleFactor is between 0 and 1
				if (angleFactor < 0){
					angleFactor = 0;
				} else if (angleFactor > 1){
					angleFactor = 1;
				}
				
				//
				// First calculate all the curve control points
				//
				
				// None of this junk will do any good if there are only two points
				if (p.length > 2){
					// Ordinarily, curve calculations will start with the second point and go through the second-to-last point
					var firstPt:Number = 1;
					var lastPt:Number = p.length-1;
					// Check if this is a closed line (the first and last points are the same)
					if (p[0].x == p[p.length-1].x && p[0].y == p[p.length-1].y){
						// Include first and last points in curve calculations
						firstPt = 0;
						lastPt = p.length;
					}
					
					var controlPts:Array = new Array();	// An array to store the two control points (of a cubic Bézier curve) for each point
					// Loop through all the points (except the first and last if not a closed line) to get curve control points for each.
					for (i=firstPt; i<lastPt; i++) {
						// The previous, current, and next points
						var p0:Point = (i-1 < 0) ? p[p.length-2] : p[i-1];	// If the first point (of a closed line), use the second-to-last point as the previous point
						var p1:Point = p[i];
						var p2:Point = (i+1 == p.length) ? p[1] : p[i+1];		// If the last point (of a closed line), use the second point as the next point
						var a:Number = Point.distance(p0,p1);	// Distance from previous point to current point
						if (a < 0.001) a = .001;		// Correct for near-zero distances, a cheap way to prevent division by zero
						var b:Number = Point.distance(p1,p2);	// Distance from current point to next point
						if (b < 0.001) b = .001;
						var c:Number = Point.distance(p0,p2);	// Distance from previous point to next point
						if (c < 0.001) c = .001;
						var cos:Number = (b*b+a*a-c*c)/(2*b*a);
						// Make sure above value is between -1 and 1 so that Math.acos will work
						if (cos < -1) cos = -1;
						else if (cos > 1) cos = 1;
						var C:Number = Math.acos(cos);	// Angle formed by the two sides of the triangle (described by the three points above) adjacent to the current point
						// Duplicate set of points. Start by giving previous and next points values RELATIVE to the current point.
						var aPt:Point = new Point(p0.x-p1.x,p0.y-p1.y);
						var bPt:Point = new Point(p1.x,p1.y);
						var cPt:Point = new Point(p2.x-p1.x,p2.y-p1.y);
						/*
						We'll be adding adding the vectors from the previous and next points to the current point,
						but we don't want differing magnitudes (i.e. line segment lengths) to affect the direction
						of the new vector. Therefore we make sure the segments we use, based on the duplicate points
						created above, are of equal length. The angle of the new vector will thus bisect angle C
						(defined above) and the perpendicular to this is nice for the line tangent to the curve.
						The curve control points will be along that tangent line.
						*/
						if (a > b){
							aPt.normalize(b);	// Scale the segment to aPt (bPt to aPt) to the size of b (bPt to cPt) if b is shorter.
						} else if (b > a){
							cPt.normalize(a);	// Scale the segment to cPt (bPt to cPt) to the size of a (aPt to bPt) if a is shorter.
						}
						// Offset aPt and cPt by the current point to get them back to their absolute position.
						aPt.offset(p1.x,p1.y);
						cPt.offset(p1.x,p1.y);
						// Get the sum of the two vectors, which is perpendicular to the line along which our curve control points will lie.
						var ax:Number = bPt.x-aPt.x;	// x component of the segment from previous to current point
						var ay:Number = bPt.y-aPt.y; 
						var bx:Number = bPt.x-cPt.x;	// x component of the segment from next to current point
						var by:Number = bPt.y-cPt.y;
						var rx:Number = ax + bx;	// sum of x components
						var ry:Number = ay + by;
						// Correct for three points in a line by finding the angle between just two of them
						if (rx == 0 && ry == 0){
							rx = -bx;	// Really not sure why this seems to have to be negative
							ry = by;
						}
						// Switch rx and ry when y or x difference is 0. This seems to prevent the angle from being perpendicular to what it should be.
						if (ay == 0 && by == 0){
							rx = 0;
							ry = 1;
						} else if (ax == 0 && bx == 0){
							rx = 1;
							ry = 0;
						}
						var r:Number = Math.sqrt(rx*rx+ry*ry);	// length of the summed vector - not being used, but there it is anyway
						var theta:Number = Math.atan2(ry,rx);	// angle of the new vector
						
						var controlDist:Number = Math.min(a,b)*z;	// Distance of curve control points from current point: a fraction the length of the shorter adjacent triangle side
						var controlScaleFactor:Number = C/Math.PI;	// Scale the distance based on the acuteness of the angle. Prevents big loops around long, sharp-angled triangles.
						controlDist *= ((1-angleFactor) + angleFactor*controlScaleFactor);	// Mess with this for some fine-tuning
						var controlAngle:Number = theta+Math.PI/2;	// The angle from the current point to control points: the new vector angle plus 90 degrees (tangent to the curve).
						var controlPoint2:Point = Point.polar(controlDist,controlAngle);	// Control point 2, curving to the next point.
						var controlPoint1:Point = Point.polar(controlDist,controlAngle+Math.PI);	// Control point 1, curving from the previous point (180 degrees away from control point 2).
						// Offset control points to put them in the correct absolute position
						controlPoint1.offset(p1.x,p1.y);
						controlPoint2.offset(p1.x,p1.y);
						/*
						Haven't quite worked out how this happens, but some control points will be reversed.
						In this case controlPoint2 will be farther from the next point than controlPoint1 is.
						Check for that and switch them if it's true.
						*/
						if (Point.distance(controlPoint2,p2) > Point.distance(controlPoint1,p2)){
							controlPts[i] = new Array(controlPoint2,controlPoint1);	// Add the two control points to the array in reverse order
						} else {
							controlPts[i] = new Array(controlPoint1,controlPoint2);	// Otherwise add the two control points to the array in normal order
						}
						// Uncomment to draw lines showing where the control points are.
						/*
						g.moveTo(p1.x,p1.y);
						g.lineTo(controlPoint2.x,controlPoint2.y);
						g.moveTo(p1.x,p1.y);
						g.lineTo(controlPoint1.x,controlPoint1.y);
						*/						
					}
					//
					// Now draw the curve
					//
					// If moveTo condition is false, this curve can connect to a previous curve on the same graphics.
					if (moveTo) g.moveTo(p[0].x, p[0].y);
					else g.lineTo(p[0].x, p[0].y);
					// If this isn't a closed line
					if (firstPt == 1){
						// Draw a regular quadratic Bézier curve from the first to second points, using the first control point of the second point
						g.curveTo(controlPts[1][0].x,controlPts[1][0].y,p[1].x,p[1].y);
					}
					var straightLines:Boolean = true;	// Change to true if you want to use lineTo for straight lines of 3 or more points rather than curves. You'll get straight lines but possible sharp corners!
					// Loop through points to draw cubic Bézier curves through the penultimate point, or through the last point if the line is closed.
					for (i=firstPt;i<lastPt-1;i++){
						// Determine if multiple points in a row are in a straight line
						var isStraight:Boolean = ( ( i > 0 && Math.atan2(p[i].y-p[i-1].y,p[i].x-p[i-1].x) == Math.atan2(p[i+1].y-p[i].y,p[i+1].x-p[i].x) ) || ( i < p.length - 2 && Math.atan2(p[i+2].y-p[i+1].y,p[i+2].x-p[i+1].x) == Math.atan2(p[i+1].y-p[i].y,p[i+1].x-p[i].x) ) );
						if (straightLines && isStraight){
							g.lineTo(p[i+1].x,p[i+1].y);
						} else {
							// BezierSegment instance using the current point, its second control point, the next point's first control point, and the next point
							var bezier:BezierSegment = new BezierSegment(p[i],controlPts[i][1],controlPts[i+1][0],p[i+1]);
							// Construct the curve out of 100 segments (adjust number for less/more detail)
							for (var t:Number=.01;t<1.01;t+=.01){
								var val:Object = bezier.getValue(t);	// x,y on the curve for a given t
								g.lineTo(val.x,val.y);
							}
						}
					}
					// If this isn't a closed line
					if (lastPt == p.length-1){
						// Curve to the last point using the second control point of the penultimate point.
						g.curveTo(controlPts[i][1].x,controlPts[i][1].y,p[i+1].x,p[i+1].y);
					}
					// just draw a line if only two points
				} else if (p.length == 2){	
					g.moveTo(p[0].x,p[0].y);
					g.lineTo(p[1].x,p[1].y);
				}
			} 
			// Catch error
			catch (e:Error) {
				trace(e.getStackTrace());
			}
		}
		
	}
	
}