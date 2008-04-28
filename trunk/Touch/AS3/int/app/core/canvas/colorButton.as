package app.core.canvas
{
	import flash.display.*;		
	
	public dynamic class colorButton extends Sprite
	{
		public function colorButton(y_coord:int,color:uint):void
		{
			this.graphics.beginFill(color);
			this.graphics.drawRoundRect(0, 0, 70, 50,6);
			this.y = y_coord;
			this.x = 5;
			this.graphics.endFill();
		}
	}
}