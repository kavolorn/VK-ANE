package vk.views.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;

	import ru.kavolorn.ane.VK;
	import ru.kavolorn.ane.VKEvent;
	import ru.kavolorn.ane.VKScope;

	import starling.events.Event;

	import vk.models.CapabilitiesModel;

	public class HomeScreenView extends Screen
	{
		private var _header:Header;
		private var _buttonsGroup:LayoutGroup;
		private var _scrollText:ScrollText;

		public function HomeScreenView():void
		{
			VK.getInstance().initialize("4620596", "eyJsaWNlbnNlIjoie1widGltZXN0YW1wXCI6MTQyMzA2MTI1MixcImlkc1wiOltcInJ1Lmthdm9sb3JuLmFuZS5WSy5EZW1vXCJdfSIsInNpZ25hdHVyZSI6ImZqSHBYbUhVUDJJcnhQQ00wZXZzbkx5Q040RGNrUm5DcWdTTWRMMlVaZHFDWlRLdms0c3J3VjZsNGdSb0ZRRlNlbWE0cVBSYVF0S0FBbXJpZnBRSmNiVTdBbU42aWl1T014XC9sQmNOUFNldHpHTVNRNFNDRmQrVjRCNjhGY2VtTmQ4YlB4SmJIMUk2Z21PdmlvMXpraHd3U1h2VkVxc2VrekFwbThYZFdYNEpOVGdRaGVQNnNqWVZsVk1nMFhHeVljTm5sbmVNeGpZQThLQXV3ZFpjcExWMlV0YnpFWW5UbTJlK2pTMmk1eGI4YStFWVdOczhDYTkwSzdhSDMzOVFmZnRTQkRFV3BGVlwvUjltTmpVQ055R3QyK1pycDJXK0g1Vk1yaHRvMTJcL0hGZGtpdVltUkJsZUhwazNNblwvQkpJVWQ3MzU4TVZ4bzU5MFhcL01WQXR2dW93PT0ifQ==");
			VK.getInstance().setAuthorizeParameters(
					[
						VKScope.WALL,
						VKScope.AUDIO,
						VKScope.FRIENDS
					],
					true, false, false
			);
			VK.getInstance().addEventListener(VKEvent.INITIALIZATION_ERROR, function (event:VKEvent):void
			{
				trace("Initialization error:", event.message);
			});
			VK.getInstance().addEventListener(VKEvent.INITIALIZATION_SUCCESS, function (event:VKEvent):void
			{
				trace("Initialization success:", event.message);
			});
		}

		override protected function initialize():void
		{
			layout = new AnchorLayout();

			_header = new Header();
			_header.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			_header.useExtraPaddingForOSStatusBar = true;
			_header.title = "VK ANE Demo";
			addChild(_header);

			_buttonsGroup = new LayoutGroup();
			_buttonsGroup.layout = new VerticalLayout();
			(_buttonsGroup.layout as VerticalLayout).gap = 10 * CapabilitiesModel.dpiScale;
			(_buttonsGroup.layout as VerticalLayout).padding = 10 * CapabilitiesModel.dpiScale;
			(_buttonsGroup.layout as VerticalLayout).horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			_buttonsGroup.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
			(_buttonsGroup.layoutData as AnchorLayoutData).topAnchorDisplayObject = _header;
			addChild(_buttonsGroup);

			if (!CapabilitiesModel.isIos)
			{
				var fingerprintButton:Button = new Button();
				fingerprintButton.label = 'App fingerprint';
				fingerprintButton.addEventListener(Event.TRIGGERED, function (event:Event):void
				{
					trace(VK.getInstance().getCertificateFingerprint());
					_scrollText.text = "certificateFingerprint\n\n" + VK.getInstance().getCertificateFingerprint();
				});
				_buttonsGroup.addChild(fingerprintButton);
			}

			var getAppPermissionsButton:Button = new Button();
			getAppPermissionsButton.label = 'App permissions';
			getAppPermissionsButton.addEventListener(Event.TRIGGERED, function (event:Event):void
			{
				VK.getInstance().removeEventListener("account.getAppPermissions", accountGetAppPermissionsHandler);
				VK.getInstance().addEventListener("account.getAppPermissions", accountGetAppPermissionsHandler);
				VK.getInstance().execute(
						{
							method: 'account.getAppPermissions',
							parameters: {}
						});
			});
			_buttonsGroup.addChild(getAppPermissionsButton);

			var wallPostButton:Button = new Button();
			wallPostButton.label = 'Wall post';
			wallPostButton.addEventListener(Event.TRIGGERED, function (event:Event):void
			{
				VK.getInstance().removeEventListener("wall.post", wallPostHandler);
				VK.getInstance().addEventListener("wall.post", wallPostHandler);
				VK.getInstance().execute(
						{
							method: 'wall.post',
							parameters: {
								message : "It's alive! Alive!!"
							}
						});
			});
			_buttonsGroup.addChild(wallPostButton);

			var friendsButton:Button = new Button();
			friendsButton.label = 'Friends list';
			friendsButton.addEventListener(Event.TRIGGERED, function (event:Event):void
			{
				VK.getInstance().removeEventListener("friends.getOnline", friendsGetOnlineHandler);
				VK.getInstance().addEventListener("friends.getOnline", friendsGetOnlineHandler);
				VK.getInstance().execute(
						{
							method: 'friends.getOnline',
							parameters: {
								online_mobile : 1
							}
						});
			});
			_buttonsGroup.addChild(friendsButton);

			var audioButton:Button = new Button();
			audioButton.label = 'Audio search';
			audioButton.addEventListener(Event.TRIGGERED, function (event:Event):void
			{
				VK.getInstance().removeEventListener("audio.search", audioSearchHandler);
				VK.getInstance().addEventListener("audio.search", audioSearchHandler);
				VK.getInstance().execute(
						{
							method: 'audio.search',
							parameters: {
								q : "Red Hot Chili Peppers",
								count : 10
							}
						});
			});
			_buttonsGroup.addChild(audioButton);
			
			_scrollText = new ScrollText();
			_scrollText.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			(_scrollText.layoutData as AnchorLayoutData).topAnchorDisplayObject = _buttonsGroup;
			addChild(_scrollText);
		}

		private function accountGetAppPermissionsHandler(event:VKEvent)
		{
			VK.getInstance().removeEventListener("account.getAppPermissions", arguments.callee);

			_scrollText.text = "account.getAppPermissions\n\n" + event.message;
		}

		private function wallPostHandler(event:VKEvent)
		{
			VK.getInstance().removeEventListener("wall.post", arguments.callee);

			_scrollText.text = "wall.post\n\n" + event.message;
		}

		private function friendsGetOnlineHandler(event:VKEvent)
		{
			VK.getInstance().removeEventListener("friends.getOnline", arguments.callee);

			_scrollText.text = "friends.getOnline\n\n" + event.message;
		}

		private function audioSearchHandler(event:VKEvent)
		{
			VK.getInstance().removeEventListener("audio.search", arguments.callee);

			_scrollText.text = "audio.search\n\n" + event.message;
		}
	}
}
