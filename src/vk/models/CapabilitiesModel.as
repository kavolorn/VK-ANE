package vk.models
{
	import flash.system.Capabilities;

	public class CapabilitiesModel
	{
		public static function get dpiScale():Number
		{
			if (isIos)
			{
				return Capabilities.screenDPI / 326;
			}
			else
			{
				return Capabilities.screenDPI / 320;
			}
		}

		public static function get isIosDevice():Boolean
		{
			if (Capabilities.manufacturer.indexOf("iOS") > -1)
			{
				return true;
			}
			return false;
		}

		public static function get isIosEmulator():Boolean
		{
			if (Capabilities.version.indexOf("IOS") > -1 && !isIosDevice)
			{
				return true;
			}
			return false;
		}

		public static function get isIos():Boolean
		{
			return isIosDevice || isIosEmulator;
		}
	}
}
