package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import starling.core.Starling;

	import vk.views.application.ApplicationView;

	[SWF(frameRate="60")]
	public class VK_Demo extends Sprite
	{
		private static var _starling:Starling;

		public function VK_Demo()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			mouseEnabled = mouseChildren = false;

			loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		}

		protected function completeHandler(event:Event):void
		{
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;

			_starling = new Starling(ApplicationView, stage);
			Starling.current.enableErrorChecking = false;
			Starling.current.start();

			this.stage.addEventListener(Event.RESIZE, resizeHandler, false, int.MAX_VALUE, true);
			this.stage.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
		}

		protected function resizeHandler(event:Event):void
		{
			Starling.current.stage.stageWidth = stage.stageWidth;
			Starling.current.stage.stageHeight = stage.stageHeight;

			const viewPort:Rectangle = Starling.current.viewPort;
			viewPort.width = stage.stageWidth;
			viewPort.height = stage.stageHeight;

			try
			{
				Starling.current.viewPort = viewPort;
			}
			catch (error:Error)
			{
			}
		}

		protected function deactivateHandler(event:Event):void
		{
			if (stage)
			{
				Starling.current.stop(true);
				stage.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
			}
		}

		private function activateHandler(event:Event):void
		{
			if (stage)
			{
				stage.removeEventListener(Event.ACTIVATE, activateHandler);
				Starling.current.start();
			}
		}
	}
}
