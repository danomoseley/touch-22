package app.core.canvas
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	// Logan: April 16
	import flash.utils.ByteArray;
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.events.*;	
	import flash.geom.*;		
		
	import app.core.element.Wrapper;
   
    import flash.Math.*;
   
    import flash.filters.*;

	import fl.transitions.*;
	import fl.transitions.easing.*;

	public dynamic class PaintCanvas extends MovieClip
	{


		private var blobs:Array;		// blobs we are currently interacting with		
		private var sourceBmp:BitmapData;	
		
		private var m_stage:Stage;		
		private var brushSize:int;
		private var lineMode:Boolean;
		private var startSet:Boolean;
		private var continuous:Boolean;
		private var startX:int;
		private var startY:int;
	
		private var paintBmpData:BitmapData;
		private var paintBmpData2:BitmapData;		
		private var paintBmpData_Holder:BitmapData;
		private var buffer:BitmapData;		
		private var paintBmp:Bitmap;
		private var brush:Sprite;
		private var filter:BitmapFilter;
		private var filter2:BitmapFilter;
		private var col:ColorTransform;
		
		private var ZoomStatus:int;		//0 or 1 depending on whether the zoom button is being pressed
		private var SelectionOn:int;	//0, 1, or 2 depending on the state of the selection process
		private var curPt1:Point;
		private var curPt2:Point;
		
		private var bytes:ByteArray;
		private var rect:Rectangle;
		
		private var loaded:Boolean;
		private var fill:Boolean;
		
		
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
		
		private var ZoominButton:Sprite;
		private var SelectionButton:Sprite;
		private var fillButton:Sprite;
		
		private var bInit:Boolean = false;
		
		public function PaintCanvas():void
		{
			loaded = false;
			this.addEventListener(Event.ADDED_TO_STAGE, function(){addedToStage();}, false, 0, true);			
			brushSize = 10;			
			lineMode = false;
			startSet = false;
			continuous = false;			
			ZoomStatus = 0;			
			fill=false;
		}
		
		function addedToStage()
		{
			m_stage = this.stage;
			
			if(bInit)
				return;
			
			blobs = new Array();
			
			paintBmpData = new BitmapData(m_stage.stageWidth, m_stage.stageHeight, true, 0x00000000);
			paintBmpData_Holder = new BitmapData(m_stage.stageWidth, m_stage.stageHeight, true, 0x00000000);
			
			brush = new Sprite();
			brush.graphics.beginFill(0xFFFFFF);
			brush.graphics.drawCircle(0,0,brushSize);			

			this.addEventListener(TouchEvent.MOUSE_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.downEvent, false, 0, true);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.upEvent, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OUT, this.rollOutHandler, false, 0, true);

			 var colorBar_0:Sprite = new Sprite();
			 		
			 colorBar_0.graphics.beginFill(0xFFFFFF,0.65);
			 colorBar_0.graphics.drawRoundRect(0, 0, 80,  m_stage.stageHeight-40,6);	00;
			 colorBar_0.x = m_stage.stageWidth-100;	
			 colorBar_0.y = 15;	

				
			 colorButton_0 = new Sprite();
			 colorButton_1 = new Sprite();		
			 colorButton_2 = new Sprite();	
			 colorButton_3 = new Sprite();
			 colorButton_4 = new Sprite();		
			 colorButton_5 = new Sprite();	
			 colorButton_6 = new Sprite();
			 colorButton_7 = new Sprite();		
			 colorButton_8 = new Sprite();	
			 colorButton_9 = new Sprite();	
			 clearButton = new Sprite();
			 lineButton = new Sprite();
			 sizeButton_1 = new Sprite();
			 sizeButton_2 = new Sprite();
			 sizeButton_3 = new Sprite();
// Logan: April 16			 
			 var saveButton:Sprite = new Sprite();
			 var loadButton:Sprite = new Sprite();
			 
			 ZoominButton = new Sprite();
			 ZoomStatus = 0; 
			 SelectionButton = new Sprite();
			 SelectionOn = 0;
			 fillButton = new Sprite();
			 
			 			 //Fills new button with color
			 ZoominButton.graphics.beginFill(0x000000);
			 ZoominButton.graphics.drawRoundRect(0, 0, 70, 50, 6);
			 ZoominButton.y = 10;
			 ZoominButton.x = 120;
			 
			 //Fills new button with color
			 SelectionButton.graphics.beginFill(0x0000FF);
			 SelectionButton.graphics.drawRoundRect(0, 0, 70, 50, 6);
			 SelectionButton.y = 120;
			 SelectionButton.x = 120;
			 
			 fillButton.graphics.beginFill(0x0000FF);
			 fillButton.graphics.drawRoundRect(0, 0, 40, 50, 6);
			 fillButton.y = 300;
			 fillButton.x = 150;
			 
 			 
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
			
			clearButton.graphics.beginFill(0xF4F4F4);
			clearButton.graphics.drawRoundRect(0, 0, 70, 50,6);									
			clearButton.y = 490;	
			clearButton.x = 10;
			
			lineButton.graphics.beginFill(0xF4F4F4);
			lineButton.graphics.drawRoundRect(0, 0, 70, 50,6);									
			lineButton.y = 550;	
			lineButton.x = 10;
			
			sizeButton_1.graphics.beginFill(0xF4F4F4);
			sizeButton_1.graphics.drawCircle(0,0,5);									
			sizeButton_1.y = 525;	
			sizeButton_1.x = 100;
			
			sizeButton_2.graphics.beginFill(0xF4F4F4);
			sizeButton_2.graphics.drawCircle(0,0,10);
			sizeButton_2.y = 525;	
			sizeButton_2.x = 130;
			
			sizeButton_3.graphics.beginFill(0xF4F4F4);
			sizeButton_3.graphics.drawCircle(0,0,15);
			sizeButton_3.y = 525;	
			sizeButton_3.x = 170;
			

// Logan: April 16
			saveButton.graphics.beginFill(0xF4F4F4);
			saveButton.graphics.drawRoundRect(0,0,70,50,6);
			saveButton.y = 150;
			saveButton.x = 100;
			
			loadButton.graphics.beginFill(0xF4F4F4);
			loadButton.graphics.drawRoundRect(0,0,70,50,6);
			loadButton.y = 150;
			loadButton.x = 180;

			 var colorWrapper_0:Wrapper = new Wrapper(colorButton_0);
			 var colorWrapper_1:Wrapper = new Wrapper(colorButton_1);
			 var colorWrapper_2:Wrapper = new Wrapper(colorButton_2);
			 var colorWrapper_3:Wrapper = new Wrapper(colorButton_3);
			 var colorWrapper_4:Wrapper = new Wrapper(colorButton_4);
			 var colorWrapper_5:Wrapper = new Wrapper(colorButton_5);
			 var colorWrapper_6:Wrapper = new Wrapper(colorButton_6);
			 var colorWrapper_7:Wrapper = new Wrapper(colorButton_7);
			 var colorWrapper_8:Wrapper = new Wrapper(colorButton_8);
			 var colorWrapper_9:Wrapper = new Wrapper(colorButton_9);	
			 var clearWrapper:Wrapper = new Wrapper(clearButton);	
			 var lineWrapper:Wrapper = new Wrapper(lineButton);	
			 var sizeWrapper_1:Wrapper = new Wrapper(sizeButton_1);
			 var sizeWrapper_2:Wrapper = new Wrapper(sizeButton_2);
			 var sizeWrapper_3:Wrapper = new Wrapper(sizeButton_3);
			 var zoomWrapper:Wrapper = new Wrapper(ZoominButton);
			 var selectWrapper:Wrapper = new Wrapper(SelectionButton);
			 var saveWrapper:Wrapper = new Wrapper(saveButton);
			 var loadWrapper:Wrapper = new Wrapper(loadButton);
			 var fillWrapper:Wrapper = new Wrapper(fillButton);
			 
			 
			colorWrapper_0.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(0.0, 0.0, 0.0);}, false, 0, true);									
			colorWrapper_1.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(1.0, 0.0, 0.0);}, false, 0, true);	
			colorWrapper_2.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(1.0, 0.5, 0.0);}, false, 0, true);									
			colorWrapper_3.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(1.0, 1.0, 0.0);}, false, 0, true);
			colorWrapper_4.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(0.0, 1.0, 0.0);}, false, 0, true);									
			colorWrapper_5.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(0.5, 1.0, 0.5);}, false, 0, true);
			colorWrapper_6.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(0.0, 0.0, 1.0);}, false, 0, true);									
			colorWrapper_7.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(0.5, 0.0, 0.5);}, false, 0, true);									
			colorWrapper_8.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(1.0, 0.0, 1.0);}, false, 0, true);
			colorWrapper_9.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(1.0, 1.0, 1.0);}, false, 0, true);
			clearWrapper.addEventListener(MouseEvent.CLICK, function(){trace("CLEAR");clear();}, false, 0, true);
			lineWrapper.addEventListener(MouseEvent.CLICK, function(){trace("LINE");line();}, false, 0, true);
			sizeWrapper_1.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");brushSize=5;}, false, 0, true);
			sizeWrapper_2.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");brushSize=10;}, false, 0, true);
			sizeWrapper_3.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");brushSize=15;}, false, 0, true);
			zoomWrapper.addEventListener(MouseEvent.MOUSE_DOWN, function(){Zoomdown();}, false, 0, true);
			selectWrapper.addEventListener(MouseEvent.CLICK, function(){Selectdown();}, false, 0, true);
			fillWrapper.addEventListener(MouseEvent.CLICK, function(){filler();}, false, 0, true);
			


// Logan: April 16
			saveWrapper.addEventListener(MouseEvent.CLICK, function(){saveBmp();}, false, 0, true);
			loadWrapper.addEventListener(MouseEvent.CLICK, function(){loadBmp();}, false, 0, true);


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
			colorBar_0.addChild(colorWrapper_0);
			colorBar_0.addChild(colorWrapper_1);
			colorBar_0.addChild(colorWrapper_2);
			colorBar_0.addChild(colorWrapper_3);
			colorBar_0.addChild(colorWrapper_4);
			colorBar_0.addChild(colorWrapper_5);
			colorBar_0.addChild(colorWrapper_6);
			colorBar_0.addChild(colorWrapper_7);
			colorBar_0.addChild(colorWrapper_8);
			colorBar_0.addChild(colorWrapper_9);
			this.addChild(clearWrapper);
			this.addChild(lineWrapper);
			this.addChild(sizeWrapper_1);
			this.addChild(sizeWrapper_2);
			this.addChild(sizeWrapper_3);
			this.addChild(colorBar_0);
			this.addChild(saveWrapper);
			this.addChild(loadWrapper);
			this.addChild(zoomWrapper);
			this.addChild(selectWrapper);
			this.addChild(fillWrapper);
		

			setColor(0.0, 1.0, 0.0);

			
			bInit = true;
		}
		function setColor(r:Number, g:Number, b:Number):void
		{
			col = new ColorTransform(r, g, b);
		}
		
		function Zoomdown():void
		{
			trace(ZoomStatus);
			//if Zoom is pressed, changes the color of the button to let the user know, and changes status to 1
			if (ZoomStatus == 0)
			{
				ZoominButton.graphics.beginFill(0x00ff00);
				ZoomStatus = 1;
			}
			//if Zoom has already been activated, deactivates it and changes color back to black
			else if (ZoomStatus == 1)
			{
				ZoominButton.graphics.beginFill(0x000000);
				ZoomStatus = 0;
			}
		}
		
		function Selectdown():void
		{
			trace(SelectionOn);
			//if selection is pressed when deactivated, activates it and changes the color
			if (SelectionOn == 0)
			{
				SelectionButton.graphics.beginFill(0xFF0000);
				SelectionOn = 1;
			}
			//if selection is already activated, deactivates it and changes color back
			else 
			{
				SelectionButton.graphics.beginFill(0x000000);
				SelectionOn = 0;
			}
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
		

// Logan: April 16
		function saveBmp():void
		{
			trace("saving");
			paintBmpData_Holder = paintBmpData.clone();
		}
		
		function loadBmp():void
		{
			trace("loading");
			clear();
			paintBmpData.draw(paintBmpData_Holder);
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
				} else if(parent != null) {
					var localPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));										
					var m:Matrix = new Matrix();
					m.translate(localPt.x, localPt.y);
					brush = new Sprite();
					brush.graphics.beginFill(0xFFFFFF);
					brush.graphics.drawCircle(0,0,brushSize);

					paintBmpData.draw(brush, m, col, 'normal');
				}
			}
			
			//paintBmpData.applyFilter(paintBmpData, paintBmpData.rect, new Point(), filter2);
		}
		
		
		public function downEvent(e:TouchEvent):void
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			if(e.stageX < 100 && e.stageY < 250 )
				return;

			//if neither zoom nor selection button has been pressed, add the point to the blob array
			if(fill)
			{
				paintBmpData.floodFill(e.stageX,e.stageY,0xFF0000);
			}
			else if(ZoomStatus == 0 && SelectionOn == 0)
			{
				if(lineMode){
					if(!startSet)
					{
						startX = e.stageX;
						trace(startX);
						startY = e.stageY;
						startSet = true;
					}else{
						var m:Matrix = new Matrix();
						m.translate(e.stageX, e.stageY);
						brush = new Sprite();
						
						brush.graphics.lineStyle(2*brushSize,0xFFFFFF);
						brush.graphics.beginFill(col);
						brush.graphics.moveTo(-1*(e.stageX-startX),-1*(e.stageY-startY));
						brush.graphics.lineTo(0,0);
						startSet = false;
						lineMode = false;
						paintBmpData.draw(brush, m, col, 'normal');
					}
				}
			
				var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									
				
				addBlob(e.ID, curPt.x, curPt.y);
					
				e.stopPropagation();
			}
			//if zoom has been activated, instead of recording the touch, zoom in
			else if (ZoomStatus == 1 && SelectionOn == 0)
			{
				this.clipScale = 75;
				//TransitionManager.start(this, {type:Zoom, direction:Transition.IN, duration:20});
			}
			//if selection has been activated, record the point as curPt1 and wait for the user to lift
			//the point, which will be curPt2, the second corner of the rectangle.
			else if (ZoomStatus == 0 && SelectionOn == 1)
			{
				curPt = parent.globalToLocal(new Point(e.stageX, e.stageY));
				this.curPt1 = curPt;
				SelectionOn = 2;
			}
			//if both points of the selection rectangle have both been defined, only points within the
			//area of the rectangle will be allowed to be added to the blob
			else if (ZoomStatus == 0 && SelectionOn == 2)
			{
				curPt = parent.globalToLocal(new Point(e.stageX, e.stageY));									
				
				if (curPt.x > Math.min(curPt1.x, curPt2.x) && curPt.x < Math.max(curPt1.x, curPt2.x) && curPt.y > Math.min(curPt1.y, curPt2.y) && curPt.y < Math.max(curPt1.y, curPt2.y))
				{
					addBlob(e.ID, curPt.x, curPt.y);
					
					e.stopPropagation();
				}
			}
		}
		
		public function upEvent(e:TouchEvent):void
		{			
					var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));
			
			//if this is the second point of the rectangle, record the point as curPt2 and draw the rectangle
			if (ZoomStatus == 0 && SelectionOn == 2)
			{
				this.curPt2 = curPt;
				this.graphics.drawRect(Math.min(curPt1.x, curPt2.x), Math.min(curPt1.y, curPt2.y), Math.abs(curPt1.x - curPt2.x), Math.abs(curPt1.y - curPt2.y));	
			}
			//if this is not a selection point, simply follow normal procedures
			else
			{
				removeBlob(e.ID);			
				
				e.stopPropagation();				
			}
				
		}		
		public function clear():void
		{
			paintBmpData.fillRect(paintBmpData.rect,0x00000000);
			//paintBmpData.setPixels(rect,bytes);
		}
		
		public function filler():void
		{
			trace(fill);
			fill = true;
		}
		
		
		public function line():void
		{
			lineMode = true;
		}

		public function moveHandler(e:TouchEvent):void
		{
		}
		
		public function rollOverHandler(e:TouchEvent):void
		{
		}
		
		public function rollOutHandler(e:TouchEvent):void
		{
		
		}		
		
	}
}