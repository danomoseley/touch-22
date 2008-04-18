/*	Touch 22
	Software Design & Documentation, RPI
	Logan Moseley, Dan Moseley, Jon Wu, Danielle Geffert
	
	To find code corresponding to a use case, search for the
	use case name. For example, "USave" for the save function.
*/

package app.core.canvas
{
	import flash.display.Bitmap;		// Image handling library.
	import flash.display.BitmapData;	// Images' data handling library.
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.events.*;	
	import flash.geom.*;
    import flash.text.TextField;
		
	import app.core.element.Wrapper;	//  Wrapper library for linking buttons with events.
   
    import flash.Math.*;
   
    import flash.filters.*;

	import fl.transitions.*;
	import fl.transitions.easing.*;

	public dynamic class PaintCanvas extends MovieClip
	{
		// Variables, bitmaps, and buttons declaration.

		private var blobs:Array;		// blobs we are currently interacting with		
		private var sourceBmp:BitmapData;
		
		// private var m_stage:Stage;	
		private var paintBmpData:BitmapData;
		private var paintBmpData2:BitmapData;		
		private var paintBmpData_Holder:BitmapData;
		private var paintBmpData_Undo:BitmapData;
		private var buffer:BitmapData;		
		private var paintBmp:Bitmap;
		private var brush:Sprite;
		private var filter:BitmapFilter;
		private var filter2:BitmapFilter;
		private var col:ColorTransform;
		private var hexColor:uint;
		
		private var ZoomStatus:int;		//0 or 1 depending on whether the zoom button is being pressed
		private var SelectionOn:int;	//0, 1, or 2 depending on the state of the selection process
		private var curPt1:Point;
		private var curPt2:Point;
		
		private var fillMode:Boolean;
		private var lineMode:Boolean;
		private var Mode:Boolean;		
		private var brushSize:int;
		private var startSet:Boolean;
		private var startX:int;
		private var startY:int;
		
		private var colorBar:Sprite;
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
		
//		private var ZoominButton:Sprite;
//		private var SelectionButton:Sprite;

		private var toolBar:Sprite;
		private var clearButton:Sprite;
		private var lineButton:Sprite;
		private var fillButton:Sprite;
		private var shapeButton:Sprite;
		private var saveButton:Sprite;
		private var loadButton:Sprite;
		private var undoButton:Sprite;
		private var sizeBar:Sprite;
		private var sizeButton_1:Sprite;
		private var sizeButton_2:Sprite;
		private var sizeButton_3:Sprite;
		
		private var bInit:Boolean = false;
		
		// PaintCanvas constructor. Mode booleans (is a line being drawn?) are set here.
		public function PaintCanvas():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, function(){addedToStage();}, false, 0, true);			// Adds the functionality of touching anywhere on the canvas.
			brushSize = 10;			
			lineMode = startSet = false;
			shapeMode = false;
			ZoomStatus = 0;			
			fillMode = false;
			hexColor=0xFF00FF00;
		}
		
		// Button objects and  buttons' wrappers of touch events' initializations.
		// Adds wrappers to global workspace object.
		// This is where all setup occurs.
		function addedToStage()
		{
			m_stage = this.stage;
			
			if(bInit)
				return;
			
			blobs = new Array();
			
			paintBmpData = new BitmapData(m_stage.stageWidth, m_stage.stageHeight, true, 0x00000000);
			paintBmpData_Holder = new BitmapData(m_stage.stageWidth, m_stage.stageHeight, true, 0x00000000);
			paintBmpData_Undo = new BitmapData(m_stage.stageWidth, m_stage.stageHeight, true, 0x00000000);
			
			brush = new Sprite();
			brush.graphics.beginFill(0xFFFFFF);
			brush.graphics.drawCircle(0,0,brushSize);

			this.addEventListener(TouchEvent.MOUSE_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.downEvent, false, 0, true);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.upEvent, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OUT, this.rollOutHandler, false, 0, true);

			colorBar = new Sprite();			 
			colorBar.graphics.beginFill(0xFFFFFF,0.65);
			colorBar.graphics.drawRoundRect(0, 0, 80,  m_stage.stageHeight-40,6);	00;
			colorBar.x = m_stage.stageWidth-100;	
			colorBar.y = 15;	

			toolBar = new Sprite();
			toolBar.graphics.beginFill(0xFFFFFF,0.65);
			toolBar.graphics.drawRoundRect(0,0,625,60,6);
			toolBar.x = 70;
			toolBar.y = 15;
			
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
			sizeBar = new Sprite();
			sizeButton_1 = new Sprite();
			sizeButton_2 = new Sprite();
			sizeButton_3 = new Sprite();
			saveButton= new Sprite();
			loadButton = new Sprite();
			undoButton = new Sprite();
			fillButton = new Sprite();
			shapeButton = new Sprite();
			 
/*
//			 //Fills new button with color
//			 ZoominButton.graphics.beginFill(0x000000);
//			 ZoominButton.graphics.drawRoundRect(0, 0, 70, 50, 6);
//			 ZoominButton.y = 10;
//			 ZoominButton.x = 120;
//			 
//			 //Fills new button with color
//			 SelectionButton.graphics.beginFill(0x0000FF);
//			 SelectionButton.graphics.drawRoundRect(0, 0, 70, 50, 6);
//			 SelectionButton.y = 120;
//			 SelectionButton.x = 120;	 
*/
 			 
			// Color buttons to go in the color bar
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
			
			// Buttons to go in the toolbar
			saveButton.graphics.beginFill(0xF4F4F4);
			saveButton.graphics.drawRoundRect(0,0,50,50,6);
			saveButton.y = 5;
			saveButton.x = 5;
			var saveLabel:TextField = new TextField()
			saveLabel.text = "Save";
			saveLabel.height = 20;
			saveLabel.width = 40;
            saveLabel.x = 10;
            saveLabel.y = 5;
            saveLabel.selectable = false;
            saveButton.addChild(saveLabel)
			
			loadButton.graphics.beginFill(0xF4F4F4);
			loadButton.graphics.drawRoundRect(0,0,50,50,6);
			loadButton.y = 5;
			loadButton.x = 65;
			var loadLabel:TextField = new TextField()
			loadLabel.text = "Load";
			loadLabel.height = 20;
			loadLabel.width = 40;
            loadLabel.x = 10;
            loadLabel.y = 5;
            loadLabel.selectable = false;
            loadButton.addChild(loadLabel)
						
			undoButton.graphics.beginFill(0xF4F4F4);
			undoButton.graphics.drawRoundRect(0, 0, 50, 50, 6);
			undoButton.y = 5;
			undoButton.x = 125;				
			var undoLabel:TextField = new TextField()
			undoLabel.text = "Undo";
			undoLabel.height = 20;
			undoLabel.width = 40;
            undoLabel.x = 10;
            undoLabel.y = 5;
            undoLabel.selectable = false;
            undoButton.addChild(undoLabel)
			
			clearButton.graphics.beginFill(0xF4F4F4);
			clearButton.graphics.drawRoundRect(0, 0, 50, 50,6);									
			clearButton.y = 5;	
			clearButton.x = 185;
			var clearLabel:TextField = new TextField()
			clearLabel.text = "Clear";
			clearLabel.height = 20;
			clearLabel.width = 40;
            clearLabel.x = 10;
            clearLabel.y = 5;
            clearLabel.selectable = false;
            clearButton.addChild(clearLabel)
			
			fillButton.graphics.beginFill(0xF4F4F4);
			fillButton.graphics.drawRoundRect(0, 0, 50, 50, 6);
			fillButton.y = 5;
			fillButton.x = 245;
			var fillLabel:TextField = new TextField()
			fillLabel.text = "Fill";
			fillLabel.height = 20;
			fillLabel.width = 40;
            fillLabel.x = 10;
            fillLabel.y = 5;
            fillLabel.selectable = false;
            fillButton.addChild(fillLabel)
			
			shapeButton.graphics.beginFill(0xF4F4F4);
			shapeButton.graphics.drawRoundRect(0, 0, 50, 50, 6);
			shapeButton.y = 5;
			shapeButton.x = 305;
			var shapeLabel:TextField = new TextField()
			shapeLabel.text = "Shape";
			shapeLabel.height = 20;
			shapeLabel.width = 40;
            shapeLabel.x = 10;
            shapeLabel.y = 5;
            shapeLabel.selectable = false;
            shapeButton.addChild(shapeLabel)
			
			lineButton.graphics.beginFill(0xF4F4F4);
			lineButton.graphics.drawRoundRect(0, 0, 50, 50,6);									
			lineButton.y = 5;	
			lineButton.x = 365;
			var lineLabel:TextField = new TextField()
			lineLabel.text = "Line";
            lineLabel.x = 10;
            lineLabel.y = 5;
            lineLabel.selectable = false;
            lineButton.addChild(lineLabel)
			
			sizeBar.graphics.beginFill(0x000000,0.65);
			sizeBar.graphics.drawRoundRect(0, 0, 80,  50,6);
			sizeBar.x = 500;	
			sizeBar.y = 5;	
			
			sizeButton_1.graphics.beginFill(0xF4F4F4);
			sizeButton_1.graphics.drawCircle(0,0,5);									
			sizeButton_1.y = 25;	
			sizeButton_1.x = 10;
			
			sizeButton_2.graphics.beginFill(0xF4F4F4);
			sizeButton_2.graphics.drawCircle(0,0,10);
			sizeButton_2.y = 25;	
			sizeButton_2.x = 30;
			
			sizeButton_3.graphics.beginFill(0xF4F4F4);
			sizeButton_3.graphics.drawCircle(0,0,15);
			sizeButton_3.y = 25;	
			sizeButton_3.x = 60;
			
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
			// var zoomWrapper:Wrapper = new Wrapper(ZoominButton);
			// var selectWrapper:Wrapper = new Wrapper(SelectionButton);
			var saveWrapper:Wrapper = new Wrapper(saveButton);
			var loadWrapper:Wrapper = new Wrapper(loadButton);
			var fillWrapper:Wrapper = new Wrapper(fillButton);
			var shapeWrapper:Wrapper = new Wrapper(shapeButton);
			var undoWrapper:Wrapper = new Wrapper(undoButton);
			 
			colorWrapper_0.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(0.0, 0.0, 0.0);hexColor=0xFF000000;}, false, 0, true);									
			colorWrapper_1.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(1.0, 0.0, 0.0);hexColor=0xFFFF0000;}, false, 0, true);	
			colorWrapper_2.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(1.0, 0.5, 0.0);hexColor=0xFFFF8000;}, false, 0, true);									
			colorWrapper_3.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(1.0, 1.0, 0.0);hexColor=0xFFFFFF00;}, false, 0, true);
			colorWrapper_4.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(0.0, 1.0, 0.0);hexColor=0xFF00FF00;}, false, 0, true);									
			colorWrapper_5.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(0.5, 1.0, 0.5);hexColor=0xFF80FF80;}, false, 0, true);
			colorWrapper_6.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(0.0, 0.0, 1.0);hexColor=0xFF0000FF;}, false, 0, true);									
			colorWrapper_7.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(0.5, 0.0, 0.5);hexColor=0xFF800080;}, false, 0, true);									
			colorWrapper_8.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(1.0, 0.0, 1.0);hexColor=0xFFFF00FF;}, false, 0, true);
			colorWrapper_9.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");setColor(1.0, 1.0, 1.0);hexColor=0xFFF4F4F4;}, false, 0, true);
			clearWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){clear();}, false, 0, true);
			lineWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){line();}, false, 0, true);
			
			
			// Use name: USize
			// Called by: Touching one of three size buttons.
			// Function: Changes the brush size to either 5, 10, or 15.
			sizeWrapper_1.addEventListener(TouchEvent.MOUSE_OVER, function(){trace("DOWN");brushSize=5;}, false, 0, true);
			sizeWrapper_2.addEventListener(TouchEvent.MOUSE_OVER, function(){trace("DOWN");brushSize=10;}, false, 0, true);
			sizeWrapper_3.addEventListener(TouchEvent.MOUSE_OVER, function(){trace("DOWN");brushSize=15;}, false, 0, true);
			
			//zoomWrapper.addEventListener(MouseEvent.MOUSE_DOWN, function(){Zoomdown();}, false, 0, true);
			//selectWrapper.addEventListener(MouseEvent.CLICK, function(){Selectdown();}, false, 0, true);
			fillWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){filler();}, false, 0, true);
			shapeWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){shape();}, false, 0, true);
			saveWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){saveBmp();}, false, 0, true);
			loadWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){loadBmp();}, false, 0, true);
			undoWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){undo();}, false, 0, true);

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
			colorBar.addChild(colorWrapper_0);
			colorBar.addChild(colorWrapper_1);
			colorBar.addChild(colorWrapper_2);
			colorBar.addChild(colorWrapper_3);
			colorBar.addChild(colorWrapper_4);
			colorBar.addChild(colorWrapper_5);
			colorBar.addChild(colorWrapper_6);
			colorBar.addChild(colorWrapper_7);
			colorBar.addChild(colorWrapper_8);
			colorBar.addChild(colorWrapper_9);
			
			toolBar.addChild(clearWrapper);			
			toolBar.addChild(lineWrapper);
			toolBar.addChild(saveWrapper);
			toolBar.addChild(loadWrapper);
			toolBar.addChild(fillWrapper);
			toolBar.addChild(shapeWrapper);
			toolBar.addChild(undoWrapper);
			sizeBar.addChild(sizeWrapper_1);
			sizeBar.addChild(sizeWrapper_2);
			sizeBar.addChild(sizeWrapper_3);
			toolBar.addChild(sizeBar);
			this.addChild(toolBar);
			this.addChild(colorBar);
			// Painting blobs start as green.
			setColor(0.0, 1.0, 0.0);
			
			bInit = true;
		}
		
		// Use name: UChange
		// Called by: The color buttons.
		// Function: Changes the color of the brush to the one clicked on.
		function setColor(r:Number, g:Number, b:Number):void
		{
			col = new ColorTransform(r, g, b);
		}
		
/*
//		function Zoomdown():void
//		{
//			trace(ZoomStatus);
//			//if Zoom is pressed, changes the color of the button to let the user know, and changes status to 1
//			if (ZoomStatus == 0)
//			{
//				ZoominButton.graphics.beginFill(0x00ff00);
//				ZoomStatus = 1;
//			}
//			//if Zoom has already been activated, deactivates it and changes color back to black
//			else if (ZoomStatus == 1)
//			{
//				ZoominButton.graphics.beginFill(0x000000);
//				ZoomStatus = 0;
//			}
//		}
//		
//		function Selectdown():void
//		{
//			trace(SelectionOn);
//			//if selection is pressed when deactivated, activates it and changes the color
//			if (SelectionOn == 0)
//			{
//				SelectionButton.graphics.beginFill(0xFF0000);
//				SelectionOn = 1;
//			}
//			//if selection is already activated, deactivates it and changes color back
//			else 
//			{
//				SelectionButton.graphics.beginFill(0x000000);
//				SelectionOn = 0;
//			}
//		}
*/
		

		// Use name:  UPaint
		// Called by: Touching the screen.
		// Function: Paints a blob of size 'brushSize' on the canvas.
		function addBlob(id:Number, origX:Number, origY:Number):void
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y} );
			
		}
		
		// Use name: USave
		// Called by: "Save" button.
		// Function: Clones the current canvas into a dummy canvas holder.
		function saveBmp():void
		{
			trace("saving");
			paintBmpData_Holder = paintBmpData.clone();
		}
		
		// Use name: ULoad
		// Called by: "Load" button.
		// Function: Redraws the current canvas as the dummy (saved) canvas.
		function loadBmp():void
		{
			trace("loading");
			clear();
			paintBmpData.draw(paintBmpData_Holder);
		}
		
		// Use name: UUndo
		// Called by: "Undo" button.
		// Function: Reverts to immediately previous canvas state.
		function undo():void
		{
			trace("undoing");
			clear();
			paintBmpData.draw(paintBmpData_Undo);
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
		
		// This the what happens when the user presses a finger against the touch pane.
		public function downEvent(e:TouchEvent):void
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			if(e.stageX > 600 || e.stageY < 100 )
				return;
			
			paintBmpData_Undo = paintBmpData.clone();
			//if neither zoom nor selection button has been pressed, add the point to the blob array
			
			// Essentially a component of UFill. This is where the magic happens.
			if(fillMode)
			{
				paintBmpData.floodFill(e.stageX,e.stageY,hexColor);
			}
			// Essentially a component of ULine. This is where the magic happens.
			else if(lineMode){
				if(!startSet){
					startX = e.stageX;
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
					startX = e.stageX;
					startY = e.stageY;
					paintBmpData.draw(brush, m, col, 'normal');
				}
			}
			// Essentially a component of UShapes. This is where the magic happens.
			else if(shapeMode){
				brush = new Sprite();
				brush.graphics.beginFill(0xFFFFFF);
				brush.graphics.drawRect(e.stageX-50, e.stageY-50, 100, 100);
				paintBmpData.draw(brush, m, col, 'normal');
			}
			else{
				var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									
				addBlob(e.ID, curPt.x, curPt.y);
			}
				
			e.stopPropagation();
		}
		
		// This the what happens when the user raises a finger from the touch pane.
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
		
		// Use name: UClear
		// Called by: "Clear" button.
		// Function: Clears the canvas of all painting marks.
		public function clear():void
		{
			trace("Clear");
			paintBmpData.fillRect(paintBmpData.rect,0x00000000);
		}
		
		// Use name: UFill
		// Called by: Touching the canvas after having touched the "Fill" button.
		// Function: Fills the amoeba of touched pixel's color with the current brush color.
		public function filler():void
		{
			shapeMode = lineMode = startSet = false;
			if(!fillMode)
			{
				fillMode = true;
				trace("fillMode enabled");
			}else{
				fillMode = false;
				trace("fillMode disabled");
			}
		}
		
		// Use name: UShapes
		// Called by: Touching the canvas after having touched the "Shape" button.
		// Function: Lays a rectangle of the current brush color centered on the touch location.
		public function shape():void
		{
			fillMode = lineMode = startSet = false;
			if(!shapeMode)
			{
				shapeMode = true;
				trace("shapeMode enabled");
			}else{
				shapeMode = false;
				trace("shapeMode disabled");
			}
		}
		
		// Use name: ULine
		// Called by: Touching the canvas at start and end locations after having touched the "Line" button.
		// Function: Lays a line of the current brush color from the start to end points.
		public function line():void
		{
			shapeMode = fillMode = false;
			if(!lineMode)
			{
				lineMode = true;
				trace("lineMode enabled");
			}else{
				lineMode = false;
				startSet = false;
				trace("lineMode disabled");
			}
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