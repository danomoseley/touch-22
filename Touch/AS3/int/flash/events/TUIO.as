/*
 * TODO: Make into a proper singleton
 * FIXME: Initilization Bug
 * TODO: Implement SWIPES and other events see: TouchEvent
*/
package flash.events {		
	import flash.display.Stage;
	import flash.display.Sprite;	
	import flash.display.Shape;
	import flash.display.DisplayObjectContainer;
	import flash.events.DataEvent;
	import flash.events.Event;	
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;	
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.XMLSocket;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	
	import flash.utils.getTimer;
	//import caurina.transitions.Tweener;

	public class TUIO
	{	
		//private static var INSTANCE:TUIO;			
		private static var STAGE:Stage;
		private static var SOCKET:XMLSocket;		
		private static var HOST:String;			
		private static var PORT:Number;				
		private static var FRAME_RATE:Number;	
		//-------------------------------------- DEBUG VARS			
		internal static var DEBUG:Boolean;				
		private static var INITIALIZED:Boolean;		
		//private static var PLAYBACK:Boolean;			
		private static var RECORDING:Boolean;			
		private static var DEBUG_TEXT:TextField;	
		private static var DEBUG_BUTTON:Sprite;			
		private static var RECORD_BUTTON:Sprite;							
		private static var PLAYBACK_BUTTON:Sprite;		
		private static var PLAYBACK_URL:String; 
		private static var PLAYBACK_LOADER:URLLoader;
		private static var PLAYBACK_XML:XML;
		private static var RECORDED_XML:XML;		
		private static var SERVICE:NetConnection;
    	private static var RESPONDER:Responder;
		//--------------------------------------		
		private static var ID_ARRAY:Array; 		
		private static var EVENT_ARRAY:Array;		
		private static var OBJECT_ARRAY:Array;		
		//--------------------------------------
		private static var SWIPE_THRESHOLD:Number = 1000;
		private static var HOLD_THRESHOLD:Number = 4000;
//---------------------------------------------------------------------------------------------------------------------------------------------	
// CONSTRUCTOR - SINGLETON
//---------------------------------------------------------------------------------------------------------------------------------------------		
		public static function init ($STAGE:DisplayObjectContainer, $HOST:String, $PORT:Number, $PLAYBACK_URL:String, $DEBUG:Boolean = true):void
		{
			if (INITIALIZED) { trace("TUIO Already Initialized!"); return; }	
			
			// FIXME: VERIFY STAGE IS AVAILABLE
			STAGE = $STAGE.stage;
			STAGE.align = "TL";
			STAGE.scaleMode = "noScale";				
			
			HOST=$HOST;			
			PORT=$PORT;					       
			
			SERVICE = new NetConnection();
			SERVICE.connect("http://nui.mine.nu/amfphp/gateway.php");
			
			PLAYBACK_URL = $PLAYBACK_URL;
			DEBUG = $DEBUG;				
			INITIALIZED = true;
			RECORDING = false;		
			//PLAYBACK = false;									
			OBJECT_ARRAY = new Array();
			ID_ARRAY = new Array();
			EVENT_ARRAY = new Array();
			
			try
			{
				SOCKET = new XMLSocket();	
				SOCKET.addEventListener(Event.CLOSE, closeHandler);
				SOCKET.addEventListener(Event.CONNECT, connectHandler);
				SOCKET.addEventListener(DataEvent.DATA, dataHandler);
				SOCKET.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				SOCKET.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				SOCKET.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);	
				startSocket();		
			} 
			catch(e){}			
			if(DEBUG)
			{
				activateDebugMode();				
			}  
			else 
			{		
				RECORDED_XML = new XML();	
				RECORDED_XML = <OSCPackets></OSCPackets>;
				RECORDING = false;			
			}			
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
// PUBLIC METHODS
//---------------------------------------------------------------------------------------------------------------------------------------------
		public static function addEventListener(e:EventDispatcher)
		{
			EVENT_ARRAY.push(e);
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		public static function listenForObject(id:Number, reciever:Object)
		{
			var tmpObj:TUIOObject = getObjectById(id);			
			if(tmpObj)
			{
				tmpObj.addListener(reciever);				
			}
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		public static function getObjectById(id:Number): TUIOObject
		{
			if(id == 0)
			{
				return new TUIOObject("mouse", 0, STAGE.mouseX, STAGE.mouseY, 0, 0, 0, 0, 10, 10, null);
			}
			for(var i=0; i<OBJECT_ARRAY.length; i++)
			{
				if(OBJECT_ARRAY[i].ID == id)
				{
					return OBJECT_ARRAY[i];
				}
			}
			return null;
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		public static function removeObjectListener(id:Number, reciever:Object)
		{
			var tmpObj:TUIOObject = getObjectById(id);			
			if(tmpObj)
			{
				tmpObj.removeListener(reciever);				
			}
		}		
//---------------------------------------------------------------------------------------------------------------------------------------------
// PRIVATE METHODS
//---------------------------------------------------------------------------------------------------------------------------------------------
		private static function processMessage(msg:XML)
		{
			// SPEEDTEST: For speed testing the function
			if (DEBUG)
			var time:Number = getTimer();
			
			var fseq:String;
			var node:XML;
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.ARGUMENT[0].@VALUE == "fseq")
					fseq = node.ARGUMENT[1].@VALUE;					
			}
			
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.ARGUMENT[0].@VALUE == "alive")
				{
					for each (var obj1:TUIOObject in OBJECT_ARRAY)
					{
						obj1.TUIO_ALIVE = false;
					}
					
					var newIdArray:Array = new Array();					
					for each(var aliveItem:XML in node.ARGUMENT.(@VALUE != "alive"))
					{
						if(getObjectById(aliveItem.@VALUE))
							getObjectById(aliveItem.@VALUE).TUIO_ALIVE = true;

					}   
					ID_ARRAY = newIdArray;
				}
			}				
							
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0])
				{
					var type:String;	
					if(node.@NAME == "/tuio/2Dobj")
					{
						/*
						// fixme: ensure everything is working properly here.
						
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var sID = node.ARGUMENT[1].@VALUE;
							var id = node.ARGUMENT[2].@VALUE;
							var x = Number(node.ARGUMENT[3].@VALUE) * STAGE.stageWidth;
							var y = Number(node.ARGUMENT[4].@VALUE) * STAGE.stageHeight;
							var a = Number(node.ARGUMENT[5].@VALUE);
							var X = Number(node.ARGUMENT[6].@VALUE);
							var Y = Number(node.ARGUMENT[7].@VALUE);
							var A = Number(node.ARGUMENT[8].@VALUE);
							var m = node.ARGUMENT[9].@VALUE;
							var r = node.ARGUMENT[10].@VALUE;
							
							// send object update event..
							
							var objArray:Array = STAGE.getObjectsUnderPoint(new Point(x, y));
							var stagePoint:Point = new Point(x,y);					
							var displayObjArray:Array = STAGE.getObjectsUnderPoint(stagePoint);							
							var dobj = null;
							
//							if(displayObjArray.length > 0)								
//								dobj = displayObjArray[displayObjArray.length-1];										

							
						
							var tuioobj = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dobj", id, x, y, X, Y, sID, a, 0, 0, dobj);
								STAGE.addChild(tuioobj.TUIO_CURSOR);
								
								OBJECT_ARRAY.push(tuioobj);
								tuioobj.notifyCreated();								
							} else {
								tuioobj.TUIO_CURSOR.x = x;
								tuioobj.TUIO_CURSOR.y = y;								
								tuioobj.x = x;
								tuioobj.y = y;
								tuioobj.oldX = tuioobj.x;
								tuioobj.oldY = tuioobj.y;
								tuioobj.dX = X;
								tuioobj.dY = Y;
								
								tuioobj.setObjOver(dobj);
								tuioobj.notifyMoved();								
							}
							
							try
							{
								if(tuioobj.TUIO_OBJECT && tuioobj.TUIO_OBJECT.parent)
								{							
									
									var localPoint:Point = tuioobj.TUIO_OBJECT.parent.globalToLocal(stagePoint);							
									tuioobj.TUIO_OBJECT.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_MOVE, true, false, x, y, localPoint.x, localPoint.y, tuioobj.oldX, tuioobj.oldY, tuioobj.TUIO_OBJECT, false,false,false, true, m, "2Dobj", id, sID, a));
								}
							} catch (e)
							{
							}
						}
						*/
					} 
					else if(node.@NAME == "/tuio/2Dcur")
					{
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var id:int;
							
							var x:Number,
								y:Number,
								X:Number,
								Y:Number,
								m:Number,
								wd:Number = 0, 
								ht:Number = 0;
							try 
							{
								id = node.ARGUMENT[1].@VALUE;
								x = Number(node.ARGUMENT[2].@VALUE) * STAGE.stageWidth;
								y = Number(node.ARGUMENT[3].@VALUE) *  STAGE.stageHeight;
								X = Number(node.ARGUMENT[4].@VALUE);
								Y = Number(node.ARGUMENT[5].@VALUE);
								m = Number(node.ARGUMENT[6].@VALUE);
								
								if(node.ARGUMENT[7])
									wd = Number(node.ARGUMENT[7].@VALUE) * STAGE.stageWidth;							
								
								if(node.ARGUMENT[8])
									ht = Number(node.ARGUMENT[8].@VALUE) * STAGE.stageHeight;
							} catch (e)
							{
								trace("Error Parsing TUIO XML");
							}
							
							//trace("Blob : ("+id + ")" + x + " " + y + " " + wd + " " + ht);
							
							var stagePoint:Point = new Point(x,y);					
							var displayObjArray:Array = STAGE.getObjectsUnderPoint(stagePoint);
							var dobj = null;
							
							if(displayObjArray.length > 0)								
							dobj = displayObjArray[displayObjArray.length-1];	
																				
							var tuioobj = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dcur", id, x, y, X, Y, -1, 0, wd, ht, dobj);
								STAGE.addChild(tuioobj.TUIO_CURSOR);								
								OBJECT_ARRAY.push(tuioobj);
								tuioobj.notifyCreated();
							} else {
								tuioobj.TUIO_CURSOR.x = x;
								tuioobj.TUIO_CURSOR.y = y;
								tuioobj.oldX = tuioobj.x;
								tuioobj.oldY = tuioobj.y;
								tuioobj.x = x;
								tuioobj.y = y;

								tuioobj.width = wd;
								tuioobj.height = ht;
								tuioobj.area = wd * ht;								
								tuioobj.dX = X;
								tuioobj.dY = Y;
								tuioobj.setObjOver(dobj);
								
								var d:Date = new Date();																
								if(!( int(Y*1000) == 0 && int(Y*1000) == 0) )
								{
									tuioobj.notifyMoved();
								}
								
								/*
								 * // SWIP RIGHT OR LEFT (with thresholds)
								if(blobs.length == 1)
								{										
								if((blobs[0].history.length) >= 10 && (blobs[0].history.length) <= 50 ){	
								if((my-blobs[0].history[0].y) <= 25 && (my-blobs[0].history[0].y) >= -25){
								if((mx-blobs[0].history[0].x) >= 75 || (mx-blobs[0].history[0].x) <= -75){
								if(mx > blobs[0].history[0].x){
							 	 EVENT_ARRAY[ndx].dispatchEvent(tuioobj.getTouchEvent(TouchEvent.SWIPE_RIGHT));
								}
							    else{
								   EVENT_ARRAY[ndx].dispatchEvent(tuioobj.getTouchEvent(TouchEvent.SWIPE_LEFT));
								}
								}
								}//else()		
								}
								} 								 
								 */
								
								if( int(Y*250) == 0 && int(Y*250) == 0) {
									if(Math.abs(d.time - tuioobj.lastModifiedTime) > HOLD_THRESHOLD)
									{
										for(var ndx:int=0; ndx<EVENT_ARRAY.length; ndx++)
										{
											EVENT_ARRAY[ndx].dispatchEvent(tuioobj.getTouchEvent(TouchEvent.LONG_PRESS));
										}
										tuioobj.lastModifiedTime = d.time;																		
									}
								}
							}

							try
							{
								if(tuioobj.TUIO_OBJECT && tuioobj.TUIO_OBJECT.parent)
								{							
									var localPoint:Point = tuioobj.TUIO_OBJECT.parent.globalToLocal(stagePoint);							
									tuioobj.TUIO_OBJECT.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_MOVE, true, false, x, y, localPoint.x, localPoint.y, tuioobj.oldX, tuioobj.oldY, tuioobj.TUIO_OBJECT, false,false,false, true, m, "2Dcur", id, 0, 0));
								}
							} catch (e)
							{
								trace("(" + e + ") Dispatch event failed " + tuioobj.ID);
							}
						}
					}
				}
			}
			if(DEBUG)
			{
				DEBUG_TEXT.text = "";
				DEBUG_TEXT.visible = false;
			}	
			for (var i=0; i<OBJECT_ARRAY.length; i++ )
			{	
				if(OBJECT_ARRAY[i].TUIO_ALIVE == false)
				{
					OBJECT_ARRAY[i].notifyRemoved();
					STAGE.removeChild(OBJECT_ARRAY[i].TUIO_CURSOR);
					OBJECT_ARRAY.splice(i, 1);
					i--;

				} else {
					if(DEBUG)
					{	
						var tmp = (int(OBJECT_ARRAY[i].area)/-100000);
						DEBUG_TEXT.appendText("  " + (i + 1) +" - " +OBJECT_ARRAY[i].ID + "  X:" + int(OBJECT_ARRAY[i].x) + "  Y:" + int(OBJECT_ARRAY[i].y) +
						"  A:" + int(tmp) + "  \n");	
						DEBUG_TEXT.visible = true;
					}
					}
			}
		// SPEEDTEST END
		//trace("SPEEDTEST: " +  time + " - "  + getTimer() + " = " + (getTimer() - time));
		if(DEBUG)
		DEBUG_TEXT.appendText("  T - " + (getTimer() - time)+"  \n");	
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
        private static function activateDebugMode():void 
        {
  				var format:TextFormat = new TextFormat("Verdana", 10, 0xFFFFFF);
				DEBUG_TEXT = new TextField();       
				DEBUG_TEXT.defaultTextFormat = format;
				DEBUG_TEXT.autoSize = TextFieldAutoSize.LEFT;
				DEBUG_TEXT.background = true;	
				DEBUG_TEXT.backgroundColor = 0x000000;	
				DEBUG_TEXT.border = true;	
				DEBUG_TEXT.borderColor = 0x333333;							
				DEBUG_TEXT.x = STAGE.stageWidth-200;
				DEBUG_TEXT.y = 25;
				STAGE.addChild( DEBUG_TEXT );						
				STAGE.setChildIndex(DEBUG_TEXT, STAGE.numChildren-1);	
		
				RECORDED_XML = <OSCPackets></OSCPackets>;	
				//
				DEBUG_BUTTON = new Sprite();			
				DEBUG_BUTTON.graphics.beginFill(0xFFFFFF);
				DEBUG_BUTTON.graphics.drawRect(10, 25, 50, 50);			
				DEBUG_BUTTON.addEventListener(MouseEvent.CLICK, toggleDebug);		
				DEBUG_BUTTON.addEventListener(TouchEvent.CLICK, toggleDebug);	
				DEBUG_BUTTON.alpha = 0.85;		 
				STAGE.addChildAt(DEBUG_BUTTON, STAGE.numChildren-1);								
					
				RECORD_BUTTON = new Sprite();	
				RECORD_BUTTON.graphics.beginFill(0xFF0000);
				RECORD_BUTTON.graphics.drawRect(10, 75, 50, 50);	
				RECORD_BUTTON.addEventListener(MouseEvent.CLICK, toggleRecord);		
				RECORD_BUTTON.addEventListener(TouchEvent.CLICK, toggleRecord);	
				RECORD_BUTTON.alpha = 0.25; 	
				STAGE.addChildAt(RECORD_BUTTON, STAGE.numChildren-1);	
						
				PLAYBACK_BUTTON = new Sprite();	
				PLAYBACK_BUTTON.graphics.beginFill(0x00FF00);
				PLAYBACK_BUTTON.graphics.drawRect(10, 125, 50, 50);	
				PLAYBACK_BUTTON.addEventListener(MouseEvent.CLICK, togglePlayback);		
				PLAYBACK_BUTTON.addEventListener(TouchEvent.CLICK, togglePlayback);	
				PLAYBACK_BUTTON.alpha = 0.25;			
				STAGE.addChildAt(PLAYBACK_BUTTON, STAGE.numChildren-1); 
        }
//---------------------------------------------------------------------------------------------------------------------------------------------
		private static function togglePlayback(e:Event)
		{ 	
			PLAYBACK_URL = "http://nui.mine.nu/amfphp/services/test.xml";		
			if(PLAYBACK_URL != "")
				 {	
					PLAYBACK_BUTTON.alpha = 0.9;
				 	//Tweener.addTween(e.target, {alpha:1, time:0.45, transition:"easeinoutquad"});	
				 	//Tweener.addTween(e.target, {alpha:0.25, delay:0.45,time:0.45, transition:"easeinoutquad"});	
					PLAYBACK_LOADER = new URLLoader();
					PLAYBACK_LOADER.addEventListener("complete", xmlPlaybackLoaded);
					PLAYBACK_LOADER.load(new URLRequest(PLAYBACK_URL));					
					PLAYBACK_LOADER.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);	
				 }
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private static function xmlPlaybackLoaded(evt:Event) 
        {
			trace("Playing from XML file...");
			PLAYBACK_XML = new XML(PLAYBACK_LOADER.data);	
			STAGE.addEventListener(Event.ENTER_FRAME, frameUpdate);
			FRAME_RATE = STAGE.frameRate;
			STAGE.frameRate = 30;		
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private static function frameUpdate(evt:Event)
		{
			if(PLAYBACK_XML && PLAYBACK_XML.OSCPACKET && PLAYBACK_XML.OSCPACKET[0])
			{
				processMessage(PLAYBACK_XML.OSCPACKET[0]);
				delete PLAYBACK_XML.OSCPACKET[0];		
				
				//if (PLAYBACK_XML.length) { }
				PLAYBACK_BUTTON.alpha = 0.25;		
				//STAGE.frameRate = FRAME_RATE;
				//trace(STAGE.frameRate);
				//STAGE.removeEventListener(Event.ENTER_FRAME, frameUpdate);		
			}
		}		
//---------------------------------------------------------------------------------------------------------------------------------------------
		private static function toggleDebug(e:Event)
		{ 
			if(!DEBUG){
			DEBUG=true;		
			startSocket();
			e.target.alpha = 0.85;		
			//e.target.scaleX = e.target.scaleY = 1.0;		
			RECORD_BUTTON.visible = true;
			PLAYBACK_BUTTON.visible = true;	
			DEBUG_TEXT.visible = true;
			}
			else{
			DEBUG=false;
			startSocket();
			e.target.alpha = 0.25;		
			//e.target.scaleX = e.target.scaleY = 0.5;		
			RECORD_BUTTON.visible = false;
			PLAYBACK_BUTTON.visible = false;
			DEBUG_TEXT.visible = false;
			}
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		public static function startSocket()
		{ 	
			SOCKET.connect(HOST, PORT);
		}
		public static function stopSocket()
		{ 	
			SOCKET.close();
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private static function toggleRecord(e:Event)
		{ 		
			var RESPONDER = new Responder(saveSession_Result, onFault);
			if(!RECORDING){
			RECORDING = true;
			e.target.alpha = 0.9;		
			//trace(e.target.parent);
			trace('-----------------------------------------------------------------------------------------------------');		
			trace('-------------------------------------- Record ON ----------------------------------------------------');
			trace('-----------------------------------------------------------------------------------------------------');	
			SERVICE.call("touchlib.clearSession", RESPONDER);			
			RECORDED_XML = <OSCPackets></OSCPackets>;	
			}
			else{
			RECORDING = false;
			e.target.alpha = 0.25;			
			trace('-----------------------------------------------------------------------------------------------------');		
			trace('-------------------------------------- Record OFF ---------------------------------------------------');
			trace('-----------------------------------------------------------------------------------------------------');	
			SERVICE.call("touchlib.saveSession", RESPONDER, RECORDED_XML.toXMLString());
			//trace(RECORDED_XML.toString());		
			trace('-------------------------------------- Recording END ------------------------------------------------');			
			}
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private static function saveSession_Result(result)
		{	
		DEBUG_TEXT.text = result;
		trace(result);			
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
        private static function dataHandler(event:DataEvent):void 
        {           			
			if(RECORDING)
			RECORDED_XML.appendChild( XML(event.data) );			
			processMessage(XML(event.data));
        } 
//---------------------------------------------------------------------------------------------------------------------------------------------   			
        private static function onFault(e:Event )
		{
			//trace("There was a problem: " + e.description);
		}
     	private static function connectHandler(event:Event):void 
     	{
            //trace("connectHandler: " + event);
        }       
        private static function ioErrorHandler(event:IOErrorEvent):void 
        {
            //trace("ioErrorHandler: " + event);
        }
        private static function progressHandler(event:ProgressEvent):void 
        {
            //trace("Debug XML Loading..." + event.bytesLoaded + " out of: " + event.bytesTotal);
        }
        private static function closeHandler(event:Event):void 
        {
            //trace("closeHandler: " + event);
        }
        private static function securityErrorHandler(event:SecurityErrorEvent):void 
        {
            //trace("securityErrorHandler: " + event);
        }
//---------------------------------------------------------------------------------------------------------------------------------------------
    }
}