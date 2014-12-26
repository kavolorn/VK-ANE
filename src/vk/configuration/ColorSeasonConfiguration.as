package vk.configuration
{
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.gizmoduck.extensions.contextView.ContextView;
	import robotlegs.gizmoduck.extensions.mediatorMap.api.IMediatorMap;

	import vk.views.application.interfaces.IApplicationView;

	public class ColorSeasonConfiguration implements IConfig
	{
		[Inject]
		public var injector:IInjector;

		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var commandMap:IEventCommandMap;

		[Inject]
		public var contextView:ContextView;

		public function configure():void
		{
			(contextView.view as IApplicationView).initialize();
		}
	}
}
