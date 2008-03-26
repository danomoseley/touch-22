package app.core.canvas
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import com.touchlib.*;	
	import flash.geom.*;			
	
	
    import flash.filters.*;


	public class PaintCanvas extends MovieClip
	{
//		[Embed(source="brush.swf", symbol="Brush")]
//		public var Brush:Class;


		private var blobs:Array;		// blobs we are currently interacting with		
		
		private var sourceBmp:BitmapData;		
		private var paintBmpData:BitmapData;
		private var paintBmpData2:BitmapData;		
		private var buffer:BitmapData;		
		private var paintBmp:Bitmap;
		private var brush:MovieClip;
		private var filter:BitmapFilter;
		private var filter2:BitmapFilter;
		private var col:ColorTransform;
		
		
		private var colorBar_0:Sprite;
		private var colorButton_0:Sprite;
		private var colorButton_1:Sprite;		
		private var colorButton_2:Sprite;		
		private var colorButton_3:Sprite;
		private var colorButton_4:Sprite;		
		private var colorButton_5:Sprite;		
		private var colorButton_6:Sprite;
		private var colorButton_7:Sprite;		
		private var colorButton_8:Sprite;	
		private var colorButton_9:Sprite;		
		
		public function PaintCanvas():void
		{

			blobs = new Array();
			paintBmpData = new BitmapData(800, 600, true, 0x00000000);
			
			brush = new BrushObj();
			
			trace(brush);
			this.addEventListener(TUIOEvent.TUIO_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TUIOEvent.TUIO_DOWN, this.downEvent, false, 0, true);						
			this.addEventListener(TUIOEvent.TUIO_UP, this.upEvent, false, 0, true);									
			this.addEventListener(TUIOEvent.TUIO_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TUIOEvent.TUIO_OUT, this.rollOutHandler, false, 0, true);																
			
			 var colorBar_0:Sprite = new Sprite();
			 		
				colorBar_0.graphics.beginFill(0xFFFFFF,0.65);
				colorBar_0.graphics.drawRoundRect(0, 0, 80, 565,6);	
				colorBar_0.y = 5;
				colorBar_0.x = 5;	
				
			 var colorButton_0:Sprite = new Sprite();
			 var colorButton_1:Sprite = new Sprite();		
			 var colorButton_2:Sprite = new Sprite();	
			 var colorButton_3:Sprite = new Sprite();
			 var colorButton_4:Sprite = new Sprite();		
			 var colorButton_5:Sprite = new Sprite();	
			 var colorButton_6:Sprite = new Sprite();
			 var colorButton_7:Sprite = new Sprite();		
			 var colorButton_8:Sprite = new Sprite();	
			 var colorButton_9:Sprite = new Sprite();	

			
			colorButton_0.graphics.beginFill(0x000000);
			colorButton_0.graphics.drawRoundRect(0, 0, 70, 50,6);			
			colorButton_0.y = 10;
			colorButton_0.x = 5;	
			
			colorButton_1.graphics.beginFill(0xFF0000);
			colorButton_1.graphics.drawRoundRect(0, 0, 70, 50,6);	
			colorButton_1.y = 65;					
			colorButton_1.x = 5;	
				
			colorButton_2.graphics.beginFill(0xFF8000);
			colorButton_2.graphics.drawRoundRect(0, 0, 70, 50,6);									
			colorButton_2.y = 120;	
			colorButton_2.x = 5;	
			
			colorButton_3.graphics.beginFill(0xFFFF00);
			colorButton_3.graphics.drawRoundRect(0, 0, 70, 50,6);			
			colorButton_3.y = 175;	
			colorButton_3.x = 5;
			
			colorButton_4.graphics.beginFill(0x00FF00);
			colorButton_4.graphics.drawRoundRect(0, 0, 70, 50,6);	
			colorButton_4.y = 230;					
			colorButton_4.x = 5;
			
			colorButton_5.graphics.beginFill(0x80FF80);
			colorButton_5.graphics.drawRoundRect(0, 0, 70, 50,6);									
			colorButton_5.y = 285;	
			colorButton_5.x = 5;
			
			colorButton_6.graphics.beginFill(0x0000FF);
			colorButton_6.graphics.drawRoundRect(0, 0, 70, 50,6);			
			colorButton_6.y = 340;	
			colorButton_6.x = 5;
			
			colorButton_7.graphics.beginFill(0x800080);
			colorButton_7.graphics.drawRoundRect(0, 0, 70, 50,6);	
			colorButton_7.y = 395;					
			colorButton_7.x = 5;
			
			colorButton_8.graphics.beginFill(0xFF00FF);
			colorButton_8.graphics.drawRoundRect(0, 0, 70, 50,6);									
			colorButton_8.y = 450;	
			colorButton_8.x = 5;
			
			colorButton_9.graphics.beginFill(0xF4F4F4);
			colorButton_9.graphics.drawRoundRect(0, 0, 70, 50,6);									
			colorButton_9.y = 505;	
			colorButton_9.x = 5;
			
			colorButton_0.addEventListener(TUIOEvent.TUIO_DOWN, function(){setColor(0.0, 0.0, 0.0);}, false, 0, true);									
			colorButton_1.addEventListener(TUIOEvent.TUIO_DOWN, function(){setColor(1.0, 0.0, 0.0);}, false, 0, true);	
			colorButton_2.addEventListener(TUIOEvent.TUIO_DOWN, function(){setColor(1.0, 0.5, 0.0);}, false, 0, true);									
			colorButton_3.addEventListener(TUIOEvent.TUIO_DOWN, function(){setColor(1.0, 1.0, 0.0);}, false, 0, true);
			colorButton_4.addEventListener(TUIOEvent.TUIO_DOWN, function(){setColor(0.0, 1.0, 0.0);}, false, 0, true);									
			colorButton_5.addEventListener(TUIOEvent.TUIO_DOWN, function(){setColor(0.5, 1.0, 0.5);}, false, 0, true);
			colorButton_6.addEventListener(TUIOEvent.TUIO_DOWN, function(){setColor(0.0, 0.0, 1.0);}, false, 0, true);									
			colorButton_7.addEventListener(TUIOEvent.TUIO_DOWN, function(){setColor(0.5, 0.0, 0.5);}, false, 0, true);									
			colorButton_8.addEventListener(TUIOEvent.TUIO_DOWN, function(){setColor(1.0, 0.0, 1.0);}, false, 0, true);
			colorButton_9.addEventListener(TUIOEvent.TUIO_DOWN, function(){setColor(1.0, 1.0, 1.0);}, false, 0, true);
			
			this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);			
			paintBmp = new Bitmap(paintBmpData);
			
			var cmat:Array = [ 1, 1, 1,
						       1, 1, 1,
							   1, 1, 1 ] ;
			filter = new ConvolutionFilter(3, 3, cmat, 5, 0);
			filter2 = new BlurFilter(17,17);
			
//			filter = new BlurFilter(5, 5);
			addChild(paintBmp);					

//			addChild(brush);
			colorBar_0.addChild(colorButton_0);
			colorBar_0.addChild(colorButton_1);
			colorBar_0.addChild(colorButton_2);	
			colorBar_0.addChild(colorButton_3);
			colorBar_0.addChild(colorButton_4);
			colorBar_0.addChild(colorButton_5);	
			colorBar_0.addChild(colorButton_6);
			colorBar_0.addChild(colorButton_7);
			colorBar_0.addChild(colorButton_8);	
			colorBar_0.addChild(colorButton_9);	
				
			this.addChild(colorBar_0);

			setColor(0.0, 0.0, 1.0);

			
		}
		
		function setColor(r:Number, g:Number, b:Number):void
		{
			col = new ColorTransform(r, g, b);
		}
		

		function addBlob(id:Number, origX:Number, origY:Number):void
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}
			
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y} );
		}
		
		function removeBlob(id:Number):void
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id) 
				{
					blobs.splice(i, 1);		
					return;
				}
			}
		}
		
		function update(e:Event):void
		{
			var pt = new Point(0,0);
			var matrix1 = new Matrix();
			for(var i:int = 0; i<blobs.length; i++)
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(blobs[i].id);
				
				// if not found, then it must have died..
				if(!tuioobj)
				{
					removeBlob(blobs[i].id);
				} else {
					var localPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));										
					var m:Matrix = new Matrix();
					m.translate(localPt.x, localPt.y);
					paintBmpData.draw(brush, m, col, 'add');
				}
			}
			
			paintBmpData.applyFilter(paintBmpData, paintBmpData.rect, new Point(), filter2);
		}
		
		
		public function downEvent(e:TUIOEvent):void
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									

			addBlob(e.ID, curPt.x, curPt.y);
				
			e.stopPropagation();
		}
		
		public function upEvent(e:TUIOEvent):void
		{		
			
				
			//removeBlob(e.ID);			
				
			e.stopPropagation();				
				
		}		

		public function moveHandler(e:TUIOEvent):void
		{
		}
		
		public function rollOverHandler(e:TUIOEvent):void
		{
		}
		
		public function rollOutHandler(e:TUIOEvent):void
		{
		
		}		
		
	}
}