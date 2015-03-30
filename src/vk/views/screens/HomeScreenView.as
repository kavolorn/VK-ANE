package vk.views.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;

	import ru.kavolorn.ane.VK;
	import ru.kavolorn.ane.VKError;
	import ru.kavolorn.ane.VKEvent;
	import ru.kavolorn.ane.VKScope;

	import starling.events.Event;

	import vk.models.CapabilitiesModel;

	public class HomeScreenView extends Screen
	{
		public static const SCOPE:Array = [
			VKScope.WALL,
			VKScope.AUDIO,
			VKScope.FRIENDS
		];

		private var _header:Header;
		private var _buttonsGroup:LayoutGroup;
		private var _scrollText:ScrollText;
		private var _statusBar:Label;

		public function HomeScreenView():void
		{
			VK.setDebug(true);

			VK.getInstance().initialize("4620596", "eyJsaWNlbnNlIjoie1widGltZXN0YW1wXCI6MTQyMzA2MTI1MixcImlkc1wiOltcInJ1Lmthdm9sb3JuLmFuZS5WSy5EZW1vXCJdfSIsInNpZ25hdHVyZSI6ImZqSHBYbUhVUDJJcnhQQ00wZXZzbkx5Q040RGNrUm5DcWdTTWRMMlVaZHFDWlRLdms0c3J3VjZsNGdSb0ZRRlNlbWE0cVBSYVF0S0FBbXJpZnBRSmNiVTdBbU42aWl1T014XC9sQmNOUFNldHpHTVNRNFNDRmQrVjRCNjhGY2VtTmQ4YlB4SmJIMUk2Z21PdmlvMXpraHd3U1h2VkVxc2VrekFwbThYZFdYNEpOVGdRaGVQNnNqWVZsVk1nMFhHeVljTm5sbmVNeGpZQThLQXV3ZFpjcExWMlV0YnpFWW5UbTJlK2pTMmk1eGI4YStFWVdOczhDYTkwSzdhSDMzOVFmZnRTQkRFV3BGVlwvUjltTmpVQ055R3QyK1pycDJXK0g1Vk1yaHRvMTJcL0hGZGtpdVltUkJsZUhwazNNblwvQkpJVWQ3MzU4TVZ4bzU5MFhcL01WQXR2dW93PT0ifQ==");

			// Fires up if initialization was completed with errors
			VK.getInstance().addEventListener(VKEvent.INITIALIZATION_ERROR, function (event:VKEvent):void
			{
				trace("Initialization error:", event.message);
			});

			// Fires up usualy right before INITIALIZATION_SUCCESS and notifies us about waked up session
			VK.getInstance().addEventListener(VKEvent.SESSION_WAKED_UP, function (event:VKEvent):void
			{
				trace(VK.getInstance().getUserToken());
				_statusBar.text = "User is logged in.";
			});

			// Extension was successfully initialized
			VK.getInstance().addEventListener(VKEvent.INITIALIZATION_SUCCESS, function (event:VKEvent):void
			{
				trace("Initialization success:", event.message);
				trace("Current SDK version:", VK.getInstance().getSdkVersion());
				trace("Current API version:", VK.getInstance().getApiVersion());
			});

			// Fires up if token is expired
			VK.getInstance().addEventListener(VKEvent.TOKEN_HAS_EXPIRED, function (event:VKEvent):void
			{
				trace(event.message);
				_statusBar.text = "User is logged out.";
			});

			// Fires up if user denied access in login screen
			VK.getInstance().addEventListener(VKEvent.USER_DENIED_ACCESS, function (event:VKEvent):void
			{
				trace(event.message);
				_statusBar.text = "User is logged out.";
			});

			// Fires up when SDK received new token
			VK.getInstance().addEventListener(VKEvent.RECEIVED_NEW_TOKEN, function (event:VKEvent):void
			{
				trace(VK.getInstance().getUserToken());
				_statusBar.text = "User is logged in.";
			});

			// Fires up when SDK renewed token
			VK.getInstance().addEventListener(VKEvent.RENEWED_TOKEN, function (event:VKEvent):void
			{
				trace(VK.getInstance().getUserToken());
				_statusBar.text = "User is logged in.";
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
				VK.getInstance().execute(
						{
							method: 'account.getAppPermissions',
							parameters: {},
							complete: completeHandler,
							error: errorHandler
						});
			});
			_buttonsGroup.addChild(getAppPermissionsButton);

			var wallPostButton:Button = new Button();
			wallPostButton.label = 'Wall post';
			wallPostButton.addEventListener(Event.TRIGGERED, function (event:Event):void
			{
				VK.getInstance().execute(
						{
							method: 'wall.post',
							parameters: {
								message: "It's alive! Alive!!"
							},
							complete: completeHandler,
							error: errorHandler
						});
			});
			_buttonsGroup.addChild(wallPostButton);

			var friendsButton:Button = new Button();
			friendsButton.label = 'Friends list';
			friendsButton.addEventListener(Event.TRIGGERED, function (event:Event):void
			{
				VK.getInstance().execute(
						{
							method: 'friends.getOnline',
							parameters: {
								online_mobile: 1
							},
							complete: completeHandler,
							error: errorHandler
						});
			});
			_buttonsGroup.addChild(friendsButton);

			var audioButton:Button = new Button();
			audioButton.label = 'Audio search';
			audioButton.addEventListener(Event.TRIGGERED, function (event:Event):void
			{
				VK.getInstance().execute(
						{
							method: 'audio.search',
							parameters: {
								q: "Red Hot Chili Peppers",
								count: 10
							},
							complete: completeHandler,
							error: errorHandler
						});
			});
			_buttonsGroup.addChild(audioButton);

			var logoutButton:Button = new Button();
			logoutButton.label = 'Logout';
			logoutButton.addEventListener(Event.TRIGGERED, function (event:Event):void
			{
				VK.getInstance().logout();
				_statusBar.text = "User is logged out.";
			});
			_buttonsGroup.addChild(logoutButton);

			_statusBar = new Label();
			_statusBar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			_statusBar.text = "User is logged out.";
			addChild(_statusBar);

			_scrollText = new ScrollText();
			_scrollText.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			(_scrollText.layoutData as AnchorLayoutData).topAnchorDisplayObject = _buttonsGroup;
			(_scrollText.layoutData as AnchorLayoutData).bottomAnchorDisplayObject = _statusBar;
			addChild(_scrollText);
		}

		private function completeHandler(response:Object, request:Object)
		{
			trace('complete', JSON.stringify(response));

			_scrollText.text = request.method + "\n\n" + JSON.stringify(response);
		}

		private function errorHandler(error:Object, request:Object)
		{
			trace('error', JSON.stringify(error));

			if (error.errorCode == VKError.VK_API_ERROR && error.vkErrorCode == 5)
			{
				_statusBar.text = "User is logged out.";
				VK.getInstance().authorize(SCOPE, true, false, false);
			}
			else if (error.errorCode == VKError.VK_API_REQUEST_HTTP_FAILED)
			{
				// Is internet connection working?
			}
		}
	}
}
