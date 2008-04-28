package app.core.canvas{
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public dynamic class toolButton extends Sprite
	{
		public function toolButton(x_coord:int, label_text:String):void
		{
			var smallLabelFormat:TextFormat=new TextFormat();
			smallLabelFormat.align=TextFormatAlign.CENTER;

			this.graphics.beginFill(0xF4F4F4);
			this.graphics.drawRoundRect(0,0,50,50,6);
			this.y = 5;
			this.x = x_coord;
			var loadLabel:TextField = new TextField();
			loadLabel.defaultTextFormat = smallLabelFormat;
			loadLabel.text = label_text;
			loadLabel.height = 20;
			loadLabel.width = 50;
			loadLabel.x = 0;
			loadLabel.y = 15;
			loadLabel.selectable = false;
			this.addChild(loadLabel);
		}
	}
}