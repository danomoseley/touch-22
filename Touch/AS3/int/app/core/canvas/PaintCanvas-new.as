/*	Touch 22
	Software Design & Documentation, RPI
	Logan Moseley, Dan Moseley, Jon Wu, Danielle Geffert
	
	To find code corresponding to a use case, search for the
	use case name. For example, "USave" for the save function.
*/

package app.core.canvas{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;

	import app.core.element.Wrapper;

	public dynamic class PaintCanvas extends MovieClip;
	{
		// Variables, bitmaps, and buttons declaration.

		private var blobs:Array;// blobs we are currently interacting with
		private var sourceBmp:BitmapData;

		private var paintBmpData:BitmapData;
		private var paintBmpData2:BitmapData;
		private var paintBmpData_Holder:BitmapData;
		private var paintBmpData_Undo:BitmapData;
		private var paintBmp:Bitmap;
		private var brush:Sprite;
		private var col:ColorTransform;
		private var hexColor:uint;

		// Variables for currently unused use cases Zoom and Selection.
		// private var ZoomStatus:int;//0 or 1 depending on whether the zoom button is being pressed
		//private var SelectionOn:int;//0, 1, or 2 depending on the state of the selection process
		//private var curPt1:Point;
		//private var curPt2:Point;

		// the current status of each tool
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
		private var colorButton_0:colorButton;
		private var colorButton_1:colorButton;
		private var colorButton_2:colorButton;
		private var colorButton_3:colorButton;
		private var colorButton_4:colorButton;
		private var colorButton_5:colorButton;
		private var colorButton_6:colorButton;
		private var colorButton_7:colorButton;
		private var colorButton_8:colorButton;
		private var colorButton_9:colorButton;
		private var colorIndicator:Sprite;

		private var backupColor:ColorTransform;
		private var backupColor2:uint;

		//Sprites for currently unused use cases Zoom and Selection.
		//private var ZoominButton:Sprite;
		//private var SelectionButton:Sprite;

		// the toolbar and the individual tool buttons that are within the toolbar
		private var toolBar:Sprite;
		private var saveButton:toolButton;
		private var loadButton:toolButton;
		private var undoButton:toolButton;
		private var clearButton:toolButton;
		private var fillButton:toolButton;
		private var shapeButton:toolButton;
		private var lineButton:toolButton;
		private var eraseButton:toolButton;
		private var sampleButton:toolButton;

		// the sizebar and size buttons that are within the toolbar
		private var sizeBar:Sprite;
		private var sizeButton_1:Sprite;
		private var sizeButton_2:Sprite;
		private var sizeButton_3:Sprite;

		private var bInit:Boolean = false;

		
		// PaintCanvas constructor. Mode booleans (is a line being drawn?) are set here.
		public function PaintCanvas():void {
			this.addEventListener(Event.ADDED_TO_STAGE, function(){addedToStage();}, false, 0, true);
			brushSize = 10;
			fillMode = false;
			shapeMode = false;
			lineMode = startSet = false;
			eraseMode = false;
			sampleMode = false;
			//          ZoomStatus = 0;

			hexColor=0xFF00FF00;
		}

		// Button objects and  buttons' wrappers of touch events' initializations.
		// Adds wrappers to global workspace object.
		// This is where all setup occurs.
		public function setupButton(button:Sprite, x_coord:int, y_coord:int, label_text:String) {
			button.graphics.beginFill(0xF4F4F4);
			button.graphics.drawRoundRect(0,0,50,50,6);
			button.y = y_coord;
			button.x = x_coord;
			var loadLabel:TextField = new TextField();
			loadLabel.text = label_text;
			loadLabel.height = 20;
			loadLabel.width = 40;
			loadLabel.x = 10;
			loadLabel.y = 5;
			loadLabel.selectable = false;
			button.addChild(loadLabel);
		}
		function addedToStage() {
			if (bInit) {
				return;
			}

			blobs = new Array();
			// initialize the paintBmpData used for the canvas as well as the holder for saving and for undoing
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
			colorBar.graphics.drawRoundRect(0, 0, 80,  this.stage.stageHeight-40,6);
			00;
			colorBar.x = this.stage.stageWidth-100;
			colorBar.y = 15;

			toolBar = new Sprite();
			toolBar.graphics.beginFill(0xFFFFFF,0.65);
			toolBar.graphics.drawRoundRect(0,0,625,60,6);
			toolBar.x = 70;
			toolBar.y = 15;

			colorButton_0 = new colorButton(10,0x000000);
			colorButton_1 = new colorButton(65,0xFF0000);
			colorButton_2 = new colorButton(120,0xFF8000);
			colorButton_3 = new colorButton(175,0xFFFF00);
			colorButton_4 = new colorButton(230,0x00FF00);
			colorButton_5 = new colorButton(285,0x80FF80);
			colorButton_6 = new colorButton(340,0x0000FF);
			colorButton_7 = new colorButton(395,0x800080);
			colorButton_8 = new colorButton(450,0xFF00FF);
			colorButton_9 = new colorButton(505,0xF4F4F4);
			colorIndicator = new Sprite();
			setColor(0xFF00FF00);

			saveButton= new toolButton(5,"Save");
			loadButton = new toolButton(65,"Load");
			undoButton = new toolButton(125,"Undo");
			clearButton = new toolButton(185,"Clear");
			fillButton = new toolButton(245,"Fill");
			shapeButton = new toolButton(305,"Shape");
			lineButton = new toolButton(365,"Line");
			eraseButton = new toolButton(425,"Erase");
			sampleButton = new toolButton(485,"Sample");
			sizeBar = new Sprite();
			sizeButton_1 = new Sprite();
			sizeButton_2 = new Sprite();
			sizeButton_3 = new Sprite();

			//ZoominButton = new Sprite();
			//ZoomStatus = 0; 
			//SelectionButton = new Sprite();
			//SelectionOn = 0;

			//Fills new button with color
			//ZoominButton.graphics.beginFill(0x000000);
			//ZoominButton.graphics.drawRoundRect(0, 0, 70, 50, 6);
			//ZoominButton.y = 10;
			//ZoominButton.x = 120;
			// 
			//Fills new button with color
			//SelectionButton.graphics.beginFill(0x0000FF);
			//SelectionButton.graphics.drawRoundRect(0, 0, 70, 50, 6);
			//SelectionButton.y = 120;
			//SelectionButton.x = 120;

			colorIndicator.y = 540;
			colorIndicator.x = 10;

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
			//var zoomWrapper:Wrapper = new Wrapper(ZoominButton);
			// var selectWrapper:Wrapper = new Wrapper(SelectionButton);

			colorWrapper_0.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFF000000;setColor(0xFF000000);}, false, 0, true);;
			colorWrapper_1.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFFFF0000;setColor(0xFFFF0000);}, false, 0, true);;
			colorWrapper_2.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFFFF8000;setColor(0xFFFF8000);}, false, 0, true);;
			colorWrapper_3.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFFFFFF00;setColor(0xFFFFFF00);}, false, 0, true);
			colorWrapper_4.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFF00FF00;setColor(0xFF00FF00);}, false, 0, true);;
			colorWrapper_5.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFF80FF80;setColor(0xFF80FF80);}, false, 0, true);
			colorWrapper_6.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFF0000FF;setColor(0xFF0000FF);}, false, 0, true);;
			colorWrapper_7.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFF800080;setColor(0xFF800080);}, false, 0, true);;
			colorWrapper_8.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFFFF00FF;setColor(0xFFFF00FF);}, false, 0, true);
			colorWrapper_9.addEventListener(MouseEvent.CLICK, function(){trace("DOWN");hexColor=0xFFF4F4F4;setColor(0xFFF4F4F4);}, false, 0, true);

			saveWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){saveBmp();}, false, 0, true);
			loadWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){loadBmp();}, false, 0, true);
			undoWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){undo();}, false, 0, true);;
			clearWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){clear();}, false, 0, true);
			fillWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){fill();}, false, 0, true);
			shapeWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){shape();}, false, 0, true);
			lineWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){line();}, false, 0, true);
			eraseWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){erase();}, false, 0, true);
			sampleWrapper.addEventListener(TouchEvent.MOUSE_DOWN, function(){sample();}, false, 0, true);

			// Use name: USize
			// Called by: Touching one of three size buttons.
			// Function: Changes the brush size to either 5, 10, or 15.
			sizeWrapper_1.addEventListener(TouchEvent.MOUSE_OVER, function(){trace("DOWN");size(5);}, false, 0, true);
			sizeWrapper_2.addEventListener(TouchEvent.MOUSE_OVER, function(){trace("DOWN");size(10);}, false, 0, true);
			sizeWrapper_3.addEventListener(TouchEvent.MOUSE_OVER, function(){trace("DOWN");size(15);}, false, 0, true);
			//zoomWrapper.addEventListener(MouseEvent.MOUSE_DOWN, function(){Zoomdown();}, false, 0, true);
			//selectWrapper.addEventListener(MouseEvent.CLICK, function(){Selectdown();}, false, 0, true);

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

		// Use name: UChange
		// Called by: The color buttons.
		// Function: Changes the color of the brush to the one clicked on.
		function setColor(color:uint):void {
			col = new ColorTransform((((color>>16) & 0xFF)/255), (((color>>8) & 0xFF)/255), (((color) & 0xFF)/255));
			colorIndicator.graphics.clear();
			colorIndicator.graphics.beginFill(color);
			colorIndicator.graphics.drawRoundRect(0,0,50,50,6);
			colorIndicator.graphics.endFill();
		}
		//function Zoomdown():void
		//{
		//trace(ZoomStatus);
		////if Zoom is pressed, changes the color of the button to let the user know, and changes status to 1
		//if (ZoomStatus == 0)
		//{
		//ZoominButton.graphics.beginFill(0x00ff00);
		//ZoomStatus = 1;
		//}
		////if Zoom has already been activated, deactivates it and changes color back to black
		//else if (ZoomStatus == 1)
		//{
		//ZoominButton.graphics.beginFill(0x000000);
		//ZoomStatus = 0;
		//}
		//}
		//
		//function Selectdown():void
		//{
		//trace(SelectionOn);
		////if selection is pressed when deactivated, activates it and changes the color
		//if (SelectionOn == 0)
		//{
		//SelectionButton.graphics.beginFill(0xFF0000);
		//SelectionOn = 1;
		//}
		////if selection is already activated, deactivates it and changes color back
		//else 
		//{
		//SelectionButton.graphics.beginFill(0x000000);
		//SelectionOn = 0;
		//}
		//}


		// Use name:  UPaint
		// Called by: Touching the screen.
		// Function: Paints a blob of size 'brushSize' on the canvas.
		function addBlob(id:Number, origX:Number, origY:Number):void {
			for (var i=0; i<blobs.length; i++) {
				if (blobs[i].id == id) {
					return;
				}
			}
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y} );

		}
		
		// Use name: USave
		// Called by: "Save" button.
		// Function: Clones the current canvas into a dummy canvas holder.
		function saveBmp():void {
			trace("saving");
			paintBmpData_Holder = paintBmpData.clone();
			// if you have no SharedObject, get it
			// make a byte array out of the bitmap data
			// assign the byte array to a property on SharedObject data
			// flush the SharedObject
		}

		// Use name: ULoad
		// Called by: "Load" button.
		// Function: Redraws the current canvas as the dummy (saved) canvas.
		function loadBmp():void {
			trace("loading");
			clear();
			// if you have no SharedObject, get it
			// assign the SharedObject data to a byte array
			// load the byte array into the loader
			// when the loader is finished with the data, draw it onto the canvas
			paintBmpData.draw(paintBmpData_Holder);
		}

		// Use name: UUndo
		// Called by: "Undo" button.
		// Function: Reverts to immediately previous canvas state.
		function undo():void {
			trace("undoing");
			clear();
			paintBmpData.draw(paintBmpData_Undo);
		}

		function removeBlob(id:Number):void {
			for (var i=0; i<blobs.length; i++) {
				if (blobs[i].id == id) {
					blobs.splice(i, 1);
					return;
				}
			}
		}
		function update(e:Event):void {
			var pt = new Point(0,0);
			var matrix1 = new Matrix();
			for (var i:int = 0; i<blobs.length; i++) {
				var tuioobj:TUIOObject = TUIO.getObjectById(blobs[i].id);

				// if not found, then it must have died..
				if (!tuioobj) {
					removeBlob(blobs[i].id);
				} else if (parent != null) {
					var localPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));
					var m:Matrix = new Matrix();
					m.translate(localPt.x-75, localPt.y-90);
					brush = new Sprite();
					brush.graphics.beginFill(0xFFFFFF);
					if (eraseMode) {
						brush;
					}
					brush.graphics.drawCircle(0,0,brushSize);
					paintBmpData.draw(brush, m, col, 'normal');
				}
			}
		}

		// This the what happens when the user presses a finger against the touch pane.
		public function downEvent(e:TouchEvent):void {
			//save the current state of the canvas for undo purposes
			paintBmpData_Undo = paintBmpData.clone();

			// check to make sure non of the tools are active before adding the point to the canvas
			if (sampleMode) {
				setColor(paintBmpData.getPixel(e.stageX-75,e.stageY-90));
				sample();
			}
			// Essentially a component of UFill. This is where the magic happens.
			if (fillMode) {
				paintBmpData.floodFill(e.stageX-75,e.stageY-90,hexColor);
			// Essentially a component of ULine. This is where the magic happens.
			} else if (lineMode) {
				if (!startSet) {
					startX = e.stageX-75;
					startY = e.stageY-90;
					startSet = true;
				} else {
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
			// Essentially a component of UShapes. This is where the magic happens.
			} else if (shapeMode) {
				brush = new Sprite();
				brush.graphics.beginFill(0xFFFFFF);
				brush.graphics.drawRect(e.stageX-50-75, e.stageY-50-90, 100, 100);
				paintBmpData.draw(brush, m, col, 'normal');
			} else {
				var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));
				addBlob(e.ID, curPt.x, curPt.y);
			}
			e.stopPropagation();
		}

		// This the what happens when the user raises a finger from the touch pane.
		public function upEvent(e:TouchEvent):void {
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));

			//if this is the second point of the rectangle, record the point as curPt2 and draw the rectangle
			//if (ZoomStatus == 0 && SelectionOn == 2)
			//{
			//this.curPt2 = curPt;
			//this.graphics.drawRect(Math.min(curPt1.x, curPt2.x), Math.min(curPt1.y, curPt2.y), Math.abs(curPt1.x - curPt2.x), Math.abs(curPt1.y - curPt2.y));
			//}
			//if this is not a selection point, simply follow normal procedures

			removeBlob(e.ID);

			e.stopPropagation();
		}

		// Use name: UClear
		// Called by: "Clear" button.
		// Function: Clears the canvas of all painting marks.
		public function clear():void {
			trace("Clear");
			paintBmpData.fillRect(paintBmpData.rect,0xFFFFFFFF);
		}

		// Use name: UFill
		// Called by: Touching the canvas after having touched the "Fill" button.
		// Function: Fills the amoeba of touched pixel's color with the current brush color.
		public function fill():void {
			if (shapeMode) {
				shape();
			}
			if (lineMode) {
				line();
			}
			if (eraseMode) {
				erase();
			}
			if (sampleMode) {
				sample();
			}// if the tool is being activated, turn the button green, if being deactivated change it back to white
			if (!fillMode) {
				fillButton.graphics.clear();
				fillButton.graphics.beginFill(0x80FF80);
				fillButton.graphics.drawRoundRect(0,0,50,50,6);
				fillButton.graphics.endFill();
				fillMode = true;
				trace("fillMode enabled");
			} else {
				fillButton.graphics.clear();
				fillButton.graphics.beginFill(0xFFFFFF);
				fillButton.graphics.drawRoundRect(0,0,50,50,6);
				fillButton.graphics.endFill();
				fillMode = false;
				trace("fillMode disabled");
			}
		}

		// Use name: UShapes
		// Called by: Touching the canvas after having touched the "Shape" button.
		// Function: Lays a rectangle of the current brush color centered on the touch location.
		public function shape():void {
			if (fillMode) {
				fill();
			}
			if (lineMode) {
				line();
			}
			if (eraseMode) {
				erase();
			}
			if (sampleMode) {
				sample();
			}// if the tool is being activated, turn the button green, if being deactivated change it back to white
			if (!shapeMode) {
				shapeButton.graphics.clear();
				shapeButton.graphics.beginFill(0x80FF80);
				shapeButton.graphics.drawRoundRect(0,0,50,50,6);
				shapeButton.graphics.endFill();
				shapeMode = true;
				trace("shapeMode enabled");
			} else {
				shapeButton.graphics.clear();
				shapeButton.graphics.beginFill(0xFFFFFF);
				shapeButton.graphics.drawRoundRect(0,0,50,50,6);
				shapeButton.graphics.endFill();
				shapeMode = false;
				trace("shapeMode disabled");
			}
		}

		// Use name: ULine
		// Called by: Touching the canvas at start and end locations after having touched the "Line" button.
		// Function: Lays a line of the current brush color from the start to end points.
		public function line():void {
			if (fillMode) {
				fill();
			}
			if (shapeMode) {
				shape();
			}
			if (eraseMode) {
				erase();
			}
			if (sampleMode) {
				sample();
			}// if the tool is being activated, turn the button green, if being deactivated change it back to white
			if (!lineMode) {
				lineButton.graphics.clear();
				lineButton.graphics.beginFill(0x80FF80);
				lineButton.graphics.drawRoundRect(0,0,50,50,6);
				lineButton.graphics.endFill();
				lineMode = true;
				trace("lineMode enabled");
			} else {
				lineButton.graphics.clear();
				lineButton.graphics.beginFill(0xFFFFFF);
				lineButton.graphics.drawRoundRect(0,0,50,50,6);
				lineButton.graphics.endFill();
				lineMode = false;
				startSet = false;
				trace("lineMode disabled");
			}
		}
		public function erase():void {
			if (fillMode) {
				fill();
			}
			if (shapeMode) {
				shape();
			}
			if (lineMode) {
				line();
			}
			if (sampleMode) {
				sample();
			}// if the tool is being activated, turn the button green, if being deactivated change it back to white
			if (!eraseMode) {
				eraseButton.graphics.clear();
				eraseButton.graphics.beginFill(0x80FF80);
				eraseButton.graphics.drawRoundRect(0,0,50,50,6);
				eraseButton.graphics.endFill();
				backupColor = col;
				backupColor2 = hexColor;
				setColor(0xFFFFFFFF);
				eraseMode = true;
				trace("eraseMode enabled");
			} else {
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
		public function sample():void {
			if (fillMode) {
				fill();
			}
			if (shapeMode) {
				shape();
			}
			if (lineMode) {
				line();
			}
			if (eraseMode) {
				erase();
			}// if the tool is being activated, turn the button green, if being deactivated change it back to white
			if (!sampleMode) {
				sampleButton.graphics.clear();
				sampleButton.graphics.beginFill(0x80FF80);
				sampleButton.graphics.drawRoundRect(0,0,50,50,6);
				sampleButton.graphics.endFill();
				sampleMode = true;
				trace("sampleMode enabled");
			} else {
				sampleButton.graphics.clear();
				sampleButton.graphics.beginFill(0xFFFFFF);
				sampleButton.graphics.drawRoundRect(0,0,50,50,6);
				sampleButton.graphics.endFill();
				sampleMode = false;
				trace("sampleMode disabled");
			}
		}
		public function size(bsize:int):void {
			brushSize=bsize;
			// change the activated brush size button to green and reset all the others to white
			if (bsize==5) {
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
			if (bsize==10) {
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
			if (bsize==15) {
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

		public function moveHandler(e:TouchEvent):void {
		}
		public function rollOverHandler(e:TouchEvent):void {
		}
		public function rollOutHandler(e:TouchEvent):void {
		}
	}
}