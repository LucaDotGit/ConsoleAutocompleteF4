package
{
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;

	internal final class Settings
	{
		private var _suggestionAlpha:Number = 0.75;
		private var _suggestionHasBackground:Boolean = true;
		private var _suggestionBackgroundColor:uint = 0x000000;

		private var _suggestionNext:uint = Keyboard.TAB;
		private var _suggestionPrevious:uint = Keyboard.CONTROL;
		private var _suggestionPaste:uint = Keyboard.RIGHT;
		private var _suggestionToggle:uint = Keyboard.ALTERNATE;

		private var _commandUp:uint = Keyboard.UP;
		private var _commandDown:uint = Keyboard.DOWN;
		private var _commandExecute:uint = Keyboard.ENTER;
		private var _commandExecuteSecondary:uint = Keyboard.NUMPAD_ENTER;
		private var _consoleClose:uint = Keyboard.BACKQUOTE;

		public function Settings()
		{
			super();
		}

		public function get suggestionAlpha():Number
		{
			return _suggestionAlpha;
		}

		public function set suggestionAlpha(value:Number):void
		{
			_suggestionAlpha = value;
		}

		public function get suggestionHasBackground():Boolean
		{
			return _suggestionHasBackground;
		}

		public function set suggestionHasBackground(value:Boolean):void
		{
			_suggestionHasBackground = value;
		}

		public function get suggestionBackgroundColor():uint
		{
			return _suggestionBackgroundColor;
		}

		public function set suggestionBackgroundColor(value:uint):void
		{
			_suggestionBackgroundColor = value;
		}

		public function get suggestionNext():uint
		{
			return _suggestionNext;
		}

		public function set suggestionNext(value:uint):void
		{
			_suggestionNext = value;
		}

		public function get suggestionPrevious():uint
		{
			return _suggestionPrevious;
		}

		public function set suggestionPrevious(value:uint):void
		{
			_suggestionPrevious = value;
		}

		public function get suggestionPaste():uint
		{
			return _suggestionPaste;
		}

		public function set suggestionPaste(value:uint):void
		{
			_suggestionPaste = value;
		}

		public function get suggestionToggle():uint
		{
			return _suggestionToggle;
		}

		public function set suggestionToggle(value:uint):void
		{
			_suggestionToggle = value;
		}

		public function get commandUp():uint
		{
			return _commandUp;
		}

		public function set commandUp(value:uint):void
		{
			_commandUp = value;
		}

		public function get commandDown():uint
		{
			return _commandDown;
		}

		public function set commandDown(value:uint):void
		{
			_commandDown = value;
		}

		public function get commandExecute():uint
		{
			return _commandExecute;
		}

		public function set commandExecute(value:uint):void
		{
			_commandExecute = value;
		}

		public function get commandExecuteSecondary():uint
		{
			return _commandExecuteSecondary;
		}

		public function set commandExecuteSecondary(value:uint):void
		{
			_commandExecuteSecondary = value;
		}

		public function get consoleClose():uint
		{
			return _consoleClose;
		}

		public function set consoleClose(value:uint):void
		{
			_consoleClose = value;
		}

		public static function load(filePath:String, onComplete:Function, onFail:Function):void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(filePath);

			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);
			loader.load(request);

			function onLoadComplete(event:Event):void
			{
				var loader:URLLoader = event.target as URLLoader;
				loader.removeEventListener(Event.COMPLETE, onLoadComplete);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);

				try
				{
					var xml:XML = new XML(loader.data);
				}
				catch (error:Error)
				{
					onLoadFail(event);
					return;
				}

				var settings:Settings = parseXML(xml);
				onComplete(settings);
			}

			function onLoadFail(event:Event):void
			{
				var loader:URLLoader = event.target as URLLoader;
				loader.removeEventListener(Event.COMPLETE, onLoadComplete);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFail);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFail);

				var settings:Settings = new Settings();
				onFail(settings);
			}
		}

		private static function parseXML(xml:XML):Settings
		{
			var settings:Settings = new Settings();
			var suggestion:XMLList = xml["suggestion"];

			if (!suggestion)
			{
				return settings;
			}

			settings.suggestionAlpha = Number(suggestion["alpha"]);
			settings.suggestionHasBackground = Boolean(suggestion["hasBackground"]);
			settings.suggestionBackgroundColor = parseInt(suggestion["backgroundColor"], 16);

			var keybinds:XMLList = xml["keybinds"];

			if (!keybinds)
			{
				return settings;
			}

			for each (var keybind:XML in keybinds["keybind"])
			{
				var action:String = keybind["@action"];
				var keyCode:uint = uint(keybind["@keyCode"]);

				if (!settings.hasOwnProperty(action))
				{
					continue;
				}

				settings[action] = keyCode;
			}

			return settings;
		}
	}
}