package vk.views.application
{
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.layout.AnchorLayout;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;

	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.gizmoduck.bundles.mvcs.MVCSBundle;
	import robotlegs.gizmoduck.extensions.contextView.ContextView;

	import starling.animation.Transitions;
	import starling.display.Sprite;

	import vk.configuration.Configuration;
	import vk.views.application.interfaces.IApplicationView;
	import vk.views.screens.HomeScreenView;

	public class ApplicationView extends Sprite implements IApplicationView
	{
		private var _context:IContext;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private static var _theme:MetalWorksMobileTheme;

		public static function get theme():MetalWorksMobileTheme
		{
			return _theme;
		}

		private static var _navigator:ScreenNavigator;

		public static function get navigator():ScreenNavigator
		{
			return _navigator;
		}

		private static var _overlay:LayoutGroup;

		public static function get overlay():LayoutGroup
		{
			return _overlay;
		}

		public function ApplicationView()
		{
			_context = new Context().install(MVCSBundle).configure(Configuration, new ContextView(this));
		}

		public function initialize():void
		{
			_theme = new MetalWorksMobileTheme();

			_navigator = new ScreenNavigator();
			_navigator.addScreen("home", new ScreenNavigatorItem(new HomeScreenView()));
			addChild(_navigator);

			_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
			_transitionManager.duration = 0.4;
			_transitionManager.delay = 0.2;
			_transitionManager.ease = Transitions.EASE_OUT;

			_overlay = new LayoutGroup();
			_overlay.layout = new AnchorLayout();
			_overlay.width = stage.stageWidth;
			_overlay.height = stage.stageHeight;
			addChild(_overlay);

			_navigator.showScreen('home');
		}
	}
}
