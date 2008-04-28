/*	Touch 22
	Software Design & Documentation, RPI
	Logan Moseley, Dan Moseley, Jon Wu, Danielle Geffert
	
	To find code corresponding to a use case, search for the
	use case name. For example, "USave" for the save function.
*/

package app.core.canvas
{
	import flash.display.Bitmap;			// Image handling library.
	import flash.display.BitmapData;		// Images' data handling library.
	import flash.utils.ByteArray;
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.events.*;	
	import flash.geom.*;		
    import flash.text.TextField;
		
	import app.core.element.Wrapper;		//  Wrapper library for linking buttons with events.
   
    import flash.Math.*;
   
    import flash.filters.*;

	import fl.transitions.*;
	import fl.transitions.easing.*;

	public dynamic class PaintCanvas extends MovieClip
	{
		// Variables, bitmaps, and buttons declaration.

		private var blobs:Array;		// Blobs we are currently interacting with.
		private var sourceBmp:BitmapData;
		
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
		
		// Variables for currently unused use cases Zoom and Selection.
 		private var ZoomStatus:int;				// 0 or 1 depending on whether the zoom button is being pressed
		private var SelectionOn:int;				// 0, 1, or 2 depending on the state of the selection process
		private var curPt1:Point;
		private var curPt2:Point;
		*/
		
		// The current status of each tool.
		private var fillMode:Boolean;
		private var lineMode:Boolean;
		private var shapeMode:Boolean;
		private var eraseMode:Boolean;
		private var sampleMode:Boolean;
		
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
		private var colorIndicator:Sprite;
		
		private var backupColor:ColorTransform;
		private var backupColor2:uint;
		
		/* Sprites for currently unused use cases Zoom and Selection.
		private var ZoominButton:Sprite;
		private var SelectionButton:Sprite;
		*/

	    // The toolbar and the individual tool buttons that are within the toolbar.
		private var toolBar:Sprite;
		private var saveButton:Sprite;
		private var loadButton:Sprite;
		private var undoButton:Sprite;
		private var clearButton:Sprite;
		private var fillButton:Sprite;
		private var shapeButton:Sprite;
		private var lineButton:Sprite;
		private var eraseButton:Sprite;
		private var sampleButton:Sprite;	
		
		// The sizebar and size buttons that are within the toolbar.
		private var sizeBar:Sprite;
		private var sizeButton_1:Sprite;
		private var sizeButton_2:Sprite;
		private var sizeButton_3:Sprite;
		
		private var bInit:Boolean = false;
		
		// paintCanvas constructor. Mode booleans are set here.
		public function paintCanvas():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, function(){addedToStage();}, false, 0, true);			
			brushSize = 10;			
			fillMode = false;
			shapeMode = false;
			lineMode = startSet = false;			
			eraseMode = false;
			sampleMode = false;
			hexColor=0xFF00FF00;
			// ZoomStatus = 0;
		}
		
		// Button objects and  buttons' wrappers of touch events' initializations.
		// Adds wrappers to global workspace object.
		// This is where all setup occurs.
		function addedToStage()
		{
			if(bInit)
				return;
			
			blobs = new Array();			
			// Initialize the paintBmpData used for the canvas as well as the holder for saving and for undoing
			paintBmpData = new BitmapData(this.stage.stageWidth-190, this.stage.stageHeight-100, true, 0xFFFFFFFF);
			paintBmpData_Holder = new BitmapData(this.stage.stageWidth-190, this.stage.stageHeight-100, true, 0xFFFFFFFF);
			paintBmpData_Undo = new BitmapData(this.stage.stageWidth-190, this.stage.stageHeight-100, true, 0xFFFFFFFF);
			
			paintBmp = new Bitmap(paintBmpData);
			paintBmp.x = 75;
			paintBmp.y = 90;
			addChild(paintBmp);					
			
			brush = new Sprite();
			brush.graphics.beginFill(0xFFFFFF);
			brush.graphics.drawCircle(0,0,brushSize);

			this.addEventListener(TouchEvent.MOUSE_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.downEvent, false, 0, true);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.upEvent, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OUT, this.rollOutHandler, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);			
			
			colorBar = new Sprite();			 
			colorBar.graphics.beginFill(0xFFFFFF,0.65);
			colorBar.graphics.drawRoundRect(0, 0, 80,  this.stage.stageHeight-40,6);	00;
			colorBar.x = this.stage.stageWidth-100;	
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
			colorIndicator = new Sprite();
			setColor(0xFF00FF00);
 
 			saveButton= new Sprite();
			loadButton = new Sprite();
			undoButton = new Sprite();
			clearButton = new Sprite();
			fillButton = new Sprite();
			shapeButton = new Sprite();
			lineButton = new Sprite();
			eraseButton = new Sprite();			 
			sampleButton = new Sprite();
			sizeBar = new Sprite();
			sizeButton_1 = new Sprite();
			sizeButton_2 = new Sprite();
			sizeButton_3 = new Sprite();		 
			 
			/* Sprite initialization and color fills for currently unused use cases Zoom and Selection.
			ZoominButton = new Sprite();
			ZoomStatus = 0; 
			SelectionButton = new Sprite();
			SelectionOn = 0;
			 
			Fills new button with color
			ZoominButton.graphics.beginFill(0x000000);
			ZoominButton.graphics.drawRoundRect(0, 0, 70, 50, 6);
			ZoominButton.y = 10;
			ZoominButton.x = 120;
			 
			Fills new button with color
			SelectionButton.graphics.beginFill(0x0000FF);
			SelectionButton.graphics.drawRoundRect(0, 0, 70, 50, 6);
			SelectionButton.y = 120;
			SelectionButton.x = 120;
			*/
 			 
			// Color buttons to go in the color bar.
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
			
			colorIndicator.y = 540;
			colorIndicator.x = 10;
			
			// Buttons to go in the toolbar.
			saveButton.graphics.beginFill(0xF4F4F4);
			saveButton.graphics.drawRoundRect(0,0,50,50,6);
			saveButton.y = 5;
			saveButton.x = 5;
			var saveLabel:TextField = new TextField();
			saveLabel.text = "Save";
			saveLabel.height = 20;
			saveLabel.width = 40;
            saveLabel.x = 10;
            saveLabel.y = 5;
            saveLabel.selectable = false;
            saveButton.addChild(saveLabel);
			
			loadButton.graphics.beginFill(0xF4F4F4);
			loadButton.graphics.drawRoundRect(0,0,50,50,6);
			loadButton.y = 5;
			loadButton.x = 65;
			var loadLabel:TextField = new TextField();
			loadLabel.text = "Load";
			loadLabel.height = 20;
			loadLabel.width = 40;
            loadLabel.x = 10;
            loadLabel.y = 5;
            loadLabel.selectable = false;
            loadButton.addChild(loadLabel);
						
			undoButton.graphics.beginFill(0xF4F4F4);
			undoButton.graphics.drawRoundRect(0, 0, 50, 50, 6);
			undoButton.y = 5;
			undoButton.x = 125;				
			var undoLabel:TextField = new TextField();
			undoLabel.text = "Undo";
			undoLabel.height = 20;
			undoLabel.width = 40;
            undoLabel.x = 10;
            undoLabel.y = 5;
            undoLabel.selectable = false;
            undoButton.addChild(undoLabel);
			
			clearButton.graphics.beginFill(0xF4F4F4);
			clearButton.graphics.drawRoundRect(0, 0, 50, 50,6);									
			clearButton.y = 5;	
			clearButton.x = 185;
			var clearLabel:TextField = new TextField();
			clearLabel.text = "Clear";
			clearLabel.height = 20;
			clearLabel.width = 40;
            clearLabel.x = 10;
            clearLabel.y = 5;
            clearLabel.selectable = false;
            clearButton.addChild(clearLabel);
			
			fillButton.graphics.beginFill(0xF4F4F4);
			fillButton.graphics.drawRoundRect(0, 0, 50, 50, 6);
			fillButton.y = 5;
			fillButton.x = 245;
			var fillLabel:TextField = new TextField();
			fillLabel.text = "Fill";
			fillLabel.height = 20;
			fillLabel.width = 40;
            fillLabel.x = 10;
            fillLabel.y = 5;
            fillLabel.selectable = false;
            fillButton.addChild(fillLabel);
			
			shapeButton.graphics.beginFill(0xF4F4F4);
			shapeButton.graphics.drawRoundRect(0, 0, 50, 50, 6);
			shapeButton.y = 5;
			shapeButton.x = 305;
			var shapeLabel:TextField = new TextField();
			shapeLabel.text = "Shape";
			shapeLabel.height = 20;
			shapeLabel.width = 40;
            shapeLabel.x = 10;
            shapeLabel.y = 5;
            shapeLabel.selectable = false;
            shapeButton.addChild(shapeLabel);
			
			lineButton.graphics.beginFill(0xF4F4F4);
			lineButton.graphics.drawRoundRect(0, 0, 50, 50,6);									
			lineButton.y = 5;	
			lineButton.x = 365;
			var lineLabel:TextField = new TextField();
			lineLabel.text = "Line";
			lineLabel.height = 20;
			lineLabel.width = 40;
            lineLabel.x = 10;
            lineLabel.y = 5;
            lineLabel.selectable = false;
            lineButton.addChild(lineLabel);
			
			eraseButton.graphics.beginFill(0xF4F4F4);
			eraseButton.graphics.drawRoundRect(0, 0, 50, 50,6);									
			eraseButton.y = 5;	
			eraseButton.x = 425;
			var eraseLabel:TextField = new TextField();
			eraseLabel.text = "Erase";
			eraseLabel.height = 20;
			eraseLabel.width = 40;
            eraseLabel.x = 10;
            eraseLabel.y = 5;
            eraseLabel.selectable = false;
            eraseButton.addChild(eraseLabel);
			
			sampleButton.graphics.beginFill(0xF4F4F4);
			sampleButton.graphics.drawRoundRect(0, 0, 50, 50,6);									
			sampleButton.y = 5;
			sampleButton.x = 485;
			var sampleLabel:TextField = new TextField();
			sampleLabel.text = "Sample";
			sampleLabel.height = 20;
			sampleLabel.width = 40;
            sampleLabel.x = 5;
            sampleLabel.y = 5;
            sampleLabel.selectable = false;
            sampleButton.addChild(sampleLabel);
			
			sizeBar.graphics.beginFill(0x000000,0.65);
			sizeBar.graphics.drawRoundRect(0, 0, 80,  50,6);
			sizeBar.x = 540;
			sizeBar.y = 5;
			
			sizeButton_1.graphics.beginFill(0xF4F4F4);
			sizeButton_1.graphics.drawCircle(0,0,5);									
			sizeButton_1.graphics.endFill();
			sizeButton_1.y = 25;	
			sizeButton_1.x = 10;
			
			sizeButton_2.graphics.beginFill(0x80FF80);
			sizeButton_2.graphics.drawCircle(0,0,10);
			sizeButton_2.graphics.endFill();
			sizeButton_2.y = 25;	
			sizeButton_2.x = 30;
			
			sizeButton_3.graphics.beginFill(0xF4F4F4);
			sizeButton_3.graphics.drawCircle(0,0,15);
			sizeButton_3.graphics.endFill();
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
			 
			var saveWrapper:Wrapper = new Wrapper(saveButton);
			var loadWrapper:Wrapper = new Wrapper(loadButton);
			var undoWrapper:Wrapper = new Wrapper(undoButton);
			var clearWrapper:Wrapper = new Wrapper(clearButton);	
			var fillWrapper:Wrapper = new Wrapper(fillButton);
			var shapeWrapper:Wrapper = new Wrapper(shapeButton);
			var lineWrapper:Wrapper = new Wrapper(lineButton);	
			var eraseWrapper:Wrapper = new Wrapper(eraseButton);
			var sampleWrapper:Wrapper = new Wrapper(sampleButton);
			
			var sizeWrapper_1:Wrapper = new Wrapper(sizeButton_1);
			var sizeWrapper_2:Wrapper = new Wrapper(sizeButton_2);
			var sizeWrapper_3:Wrapper = new Wrapper(sizeButton_3);
			// var zoomWrapper:Wrapper = new Wrapper(ZoominButton);
			// var selectWrapper:Wrapper = new Wrapper(SelectionButton);
			 		 
			colorWrapper_0.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFF000000;setColor(0xFF000000);}, false, 0, true);									
			colorWrapper_1.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFFFF0000;setColor(0xFFFF0000);}, false, 0, true);	
			colorWrapper_2.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFFFF8000;setColor(0xFFFF8000);}, false, 0, true);									
			colorWrapper_3.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFFFFFF00;setColor(0xFFFFFF00);}, false, 0, true);
			colorWrapper_4.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFF00FF00;setColor(0xFF00FF00);}, false, 0, true);									
			colorWrapper_5.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFF80FF80;setColor(0xFF80FF80);}, false, 0, true);
			colorWrapper_6.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFF0000FF;setColor(0xFF0000FF);}, false, 0, true);									
			colorWrapper_7.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFF800080;setColor(0xFF800080);}, false, 0, true);									
			colorWrapper_8.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFFFF00FF;setColor(0xFFFF00FF);}, false, 0, true);
			colorWrapper_9.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFFF4F4F4;setColor(0xFFF4F4F4);}, false, 0, true);
			
			saveWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){saveBmp();}, false, 0, true);
			loadWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){loadBmp();}, false, 0, true);
			undoWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){undo();}, false, 0, true);			
			clearWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){clear();}, false, 0, true);
			fillWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){fill();}, false, 0, true);
			shapeWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){shape();}, false, 0, true);
			lineWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){line();}, false, 0, true);
			eraseWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){erase();}, false, 0, true);
			sampleWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){sample();}, false, 0, true);
			
			sizeWrapper_1.addEventListener(TouchEvent.MOUSE_OVER, function(){trace("DOWN");size(5);}, false, 0, true);
			sizeWrapper_2.addEventListener(TouchEvent.MOUSE_OVER, function(){trace("DOWN");size(10);}, false, 0, true);
			sizeWrapper_3.addEventListener(TouchEvent.MOUSE_OVER, function(){trace("DOWN");size(15);}, false, 0, true);
			// zoomWrapper.addEventListener(MouseEvent.MOUSE_DOWN, function(){Zoomdown();}, false, 0, true);
			// selectWrapper.addEventListener(MouseEvent.CLICK, function(){Selectdown();}, false, 0, true);		

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
			toolBar.addChild(eraseWrapper);
			toolBar.addChild(sampleWrapper);
			this.addChild(toolBar);
			this.addChild(colorBar);
			this.addChild(colorIndicator);
			
			bInit = true;
		}
		
		function setColor(color:uint):void
		{
			col = new ColorTransform((((color>>16) & 0xFF)/255), (((color>>8) & 0xFF)/255), (((color) & 0xFF)/255));
			colorIndicator.graphics.clear();
			colorIndicator.graphics.beginFill(color);
			colorIndicator.graphics.drawRoundRect(0,0,50,50,6);
			colorIndicator.graphics.endFill();
		}
		
		/* Unused function for Zoom down-clicks.
		function zoomDown():void
		{
			trace(ZoomStatus);
			// If Zoom is pressed, changes the color of the button to let the user know, and changes status to 1.
			if (ZoomStatus == 0)
			{
				ZoominButton.graphics.beginFill(0x00ff00);
				ZoomStatus = 1;
			}
			// If Zoom has already been activated, deactivates it and changes color back to black.
			else if (ZoomStatus == 1)
			{
				ZoominButton.graphics.beginFill(0x000000);
				ZoomStatus = 0;
			}
		}
		*/
		
		/* Unused function for Select down-clicks.
		function zelectDown():void
		{
			trace(SelectionOn);
			// If selection is pressed when deactivated, activates it and changes the color.
			if (SelectionOn == 0)
			{
				SelectionButton.graphics.beginFill(0xFF0000);
				SelectionOn = 1;
			}
			// If selection is already activated, deactivates it and changes color back.
			else 
			{
				SelectionButton.graphics.beginFill(0x000000);
				SelectionOn = 0;
			}
		}
		*/

		function addBlob(id:Number, origX:Number, origY:Number):void
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y} );
			
		}
		
		function saveBmp():void
		{
			trace("saving");
			paintBmpData_Holder = paintBmpData.clone();
			// If you have no SharedObject, get it.
			// Make a byte array out of the bitmap data.
			// Assign the byte array to a property on SharedObject data.
			// Flush the SharedObject.
		}
		
		function loadBmp():void
		{
			trace("loading");
			clear();
			// If you have no SharedObject, get it.
			// Assign the SharedObject data to a byte array.
			// Load the byte array into the loader.
			// When the loader is finished with the data, draw it onto the canvas.
			paintBmpData.draw(paintBmpData_Holder);
		}
		
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
				
				// If not found, then it must have died..
				if(!tuioobj)
				{
					removeBlob(blobs[i].id);
				} else if(parent != null) {
					var localPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));										
					var m:Matrix = new Matrix();
					m.translate(localPt.x-75, localPt.y-90);
					brush = new Sprite();
					brush.graphics.beginFill(0xFFFFFF);
					if(eraseMode)
					brush
					brush.graphics.drawCircle(0,0,brushSize);
					paintBmpData.draw(brush, m, col, 'normal');
				}
			}
		}
		
		
		public function downEvent(e:TouchEvent):void
		{
			// Save the current state of the canvas for undo purposes.
			paintBmpData_Undo = paintBmpData.clone();
			
			// Check to make sure non of the tools are active before adding the point to the canvas.
			if(sampleMode)
			{
				setColor(paintBmpData.getPixel(e.stageX-75,e.stageY-90));
				sample();
			}
			if(fillMode)
			{
				paintBmpData.floodFill(e.stageX-75,e.stageY-90,hexColor);
			}
			else if(lineMode){
				if(!startSet){
					startX = e.stageX-75;
					startY = e.stageY-90;
					startSet = true;
				}else{
					var m:Matrix = new Matrix();
					m.translate(e.stageX-75, e.stageY-90);
					brush = new Sprite();
					
					brush.graphics.lineStyle(2*brushSize,0xFFFFFF);
					brush.graphics.beginFill(col);
					brush.graphics.moveTo(-1*(e.stageX-75-startX),-1*(e.stageY-90-startY));
					brush.graphics.lineTo(0,0);
					startX = e.stageX-75;
					startY = e.stageY-90;
					paintBmpData.draw(brush, m, col, 'normal');
				}
			}
			else if(shapeMode){
				brush = new Sprite();
				brush.graphics.beginFill(0xFFFFFF);
				brush.graphics.drawRect(e.stageX-50-75, e.stageY-50-90, 100, 100);
				paintBmpData.draw(brush, m, col, 'normal');
			}
			else{
				var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									
				addBlob(e.ID, curPt.x, curPt.y);
			}
				
			e.stopPropagation();
		}
		
		public function upEvent(e:TouchEvent):void
		{
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));
			
			// If this is the second point of the rectangle, record the point as curPt2 and draw the rectangle.
//			if (ZoomStatus == 0 && SelectionOn == 2)
//			{
//				this.curPt2 = curPt;
//				this.graphics.drawRect(Math.min(curPt1.x, curPt2.x), Math.min(curPt1.y, curPt2.y), Math.abs(curPt1.x - curPt2.x), Math.abs(curPt1.y - curPt2.y));	
//			}
			// If this is not a selection point, simply follow normal procedures.

			removeBlob(e.ID);			
				
			e.stopPropagation();				
		}		
		public function clear():void
		{
			trace("Clear");
			paintBmpData.fillRect(paintBmpData.rect,0xFFFFFFFF);
		}
		
		public function fill():void
		{
			if(shapeMode) shape();
			if(lineMode) line();
			if(eraseMode) erase();
			if(sampleMode) sample();
			// If the tool is being activated, turn the button green, if being deactivated change it back to white.
			if(!fillMode)
			{
				fillButton.graphics.clear();
				fillButton.graphics.beginFill(0x80FF80);
				fillButton.graphics.drawRoundRect(0,0,50,50,6);
				fillButton.graphics.endFill();
				fillMode = true;
				trace("fillMode enabled");
			}else{
				fillButton.graphics.clear();
				fillButton.graphics.beginFill(0xFFFFFF);
				fillButton.graphics.drawRoundRect(0,0,50,50,6);
				fillButton.graphics.endFill();
				fillMode = false;
				trace("fillMode disabled");
			}
		}
		
		public function shape():void
		{
			if(fillMode) fill();
			if(lineMode) line();
			if(eraseMode) erase();
			if(sampleMode) sample();
			// If the tool is being activated, turn the button green, if being deactivated change it back to white.
			if(!shapeMode)
			{
				shapeButton.graphics.clear();
				shapeButton.graphics.beginFill(0x80FF80);
				shapeButton.graphics.drawRoundRect(0,0,50,50,6);
				shapeButton.graphics.endFill();
				shapeMode = true;
				trace("shapeMode enabled");
			}else{
				shapeButton.graphics.clear();
				shapeButton.graphics.beginFill(0xFFFFFF);
				shapeButton.graphics.drawRoundRect(0,0,50,50,6);
				shapeButton.graphics.endFill();
				shapeMode = false;
				trace("shapeMode disabled");
			}
		}
		
		public function line():void
		{
			if(fillMode) fill();
			if(shapeMode) shape();			
			if(eraseMode) erase();
			if(sampleMode) sample();
			// If the tool is being activated, turn the button green, if being deactivated change it back to white.
			if(!lineMode)
			{
				lineButton.graphics.clear();
				lineButton.graphics.beginFill(0x80FF80);
				lineButton.graphics.drawRoundRect(0,0,50,50,6);
				lineButton.graphics.endFill();
				lineMode = true;
				trace("lineMode enabled");
			}else{
				lineButton.graphics.clear();
				lineButton.graphics.beginFill(0xFFFFFF);
				lineButton.graphics.drawRoundRect(0,0,50,50,6);
				lineButton.graphics.endFill();
				lineMode = false;
				startSet = false;
				trace("lineMode disabled");
			}
		}
		
		public function erase():void
		{
			if(fillMode) fill();
			if(shapeMode) shape();			
			if(lineMode) line();
			if(sampleMode) sample();
			// If the tool is being activated, turn the button green, if being deactivated change it back to white.
			if(!eraseMode)
			{
				eraseButton.graphics.clear();
				eraseButton.graphics.beginFill(0x80FF80);
				eraseButton.graphics.drawRoundRect(0,0,50,50,6);
				eraseButton.graphics.endFill();
				backupColor = col;
				backupColor2 = hexColor;
				setColor(0xFFFFFFFF);
				eraseMode = true;
				trace("eraseMode enabled");
			}else{
				eraseButton.graphics.clear();
				eraseButton.graphics.beginFill(0xFFFFFF);
				eraseButton.graphics.drawRoundRect(0,0,50,50,6);
				eraseButton.graphics.endFill();
				eraseMode = false;
				col=backupColor;
				setColor(backupColor2);
				trace("eraseMode disabled");
			}
		}
		
		public function sample():void
		{
			if(fillMode) fill();
			if(shapeMode) shape();			
			if(lineMode) line();
			if(eraseMode) erase();
			// If the tool is being activated, turn the button green, if being deactivated change it back to white.
			if(!sampleMode)
			{
				sampleButton.graphics.clear();
				sampleButton.graphics.beginFill(0x80FF80);
				sampleButton.graphics.drawRoundRect(0,0,50,50,6);
				sampleButton.graphics.endFill();
				sampleMode = true;
				trace("sampleMode enabled");
			}else{
				sampleButton.graphics.clear();
				sampleButton.graphics.beginFill(0xFFFFFF);
				sampleButton.graphics.drawRoundRect(0,0,50,50,6);
				sampleButton.graphics.endFill();
				sampleMode = false;
				trace("sampleMode disabled");
			}
		}
		
		public function size(bsize:int):void
		{
			brushSize=bsize;
			// Change the activated brush size button to green and reset all the others to white.
			if(bsize==5)
			{
				brush.graphics.clear();
				sizeButton_1.graphics.clear();
				sizeButton_1.graphics.beginFill(0x80FF80);
				sizeButton_1.graphics.drawCircle(0,0,5);
				sizeButton_1.graphics.endFill();
				sizeButton_2.graphics.clear();
				sizeButton_2.graphics.beginFill(0xFFFFFF);
				sizeButton_2.graphics.drawCircle(0,0,10);
				sizeButton_2.graphics.endFill();
				sizeButton_3.graphics.clear();
				sizeButton_3.graphics.beginFill(0xFFFFFF);
				sizeButton_3.graphics.drawCircle(0,0,15);
				sizeButton_3.graphics.endFill();
			}
			if(bsize==10)
			{
				brush.graphics.drawCircle(0,0,brushSize);
				sizeButton_1.graphics.clear();
				sizeButton_1.graphics.beginFill(0xFFFFFF);
				sizeButton_1.graphics.drawCircle(0,0,5);
				sizeButton_1.graphics.endFill();
				sizeButton_2.graphics.clear();
				sizeButton_2.graphics.beginFill(0x80FF80);
				sizeButton_2.graphics.drawCircle(0,0,10);
				sizeButton_2.graphics.endFill();
				sizeButton_3.graphics.clear();
				sizeButton_3.graphics.beginFill(0xFFFFFF);
				sizeButton_3.graphics.drawCircle(0,0,15);
				sizeButton_3.graphics.endFill();

			}
			if(bsize==15)
			{
				brush.graphics.drawCircle(0,0,brushSize);
				sizeButton_1.graphics.clear();
				sizeButton_1.graphics.beginFill(0xFFFFFF);
				sizeButton_1.graphics.drawCircle(0,0,5);
				sizeButton_1.graphics.endFill();
				sizeButton_2.graphics.clear();
				sizeButton_2.graphics.beginFill(0xFFFFFF);
				sizeButton_2.graphics.drawCircle(0,0,10);
				sizeButton_2.graphics.endFill();
				sizeButton_3.graphics.clear();
				sizeButton_3.graphics.beginFill(0x80FF80);
				sizeButton_3.graphics.drawCircle(0,0,15);
				sizeButton_3.graphics.endFill();
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