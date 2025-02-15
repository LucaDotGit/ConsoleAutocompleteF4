package
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;

	import scaleform.gfx.*;

	public final class ConsoleAutocomplete extends MovieClip
	{
		private static const SETTINGS_PATH:String = "ConsoleAutocomplete.xml";

		private var _root:MovieClip;
		private var _menu:MovieClip;

		private var _f4se:Object;
		private var _codeObject:Object;

		private var _currentSelection:TextField;
		private var _commandPrompt:TextField;
		private var _commandEntry:TextField;
		private var _commandSuggestion:TextField;

		private var _commands:ScriptStore;
		private var _commandIterator:ScriptIterator;
		private var _commandParser:ScriptParser;
		private var _settings:Settings;

		private var _displayWidth:Number;
		private var _displayHeight:Number;

		public function ConsoleAutocomplete()
		{
			trace("ConsoleAutocomplete: Starting...");

			Settings.load(SETTINGS_PATH, onSettingsLoadComplete, onSettingsLoadFail);
		}

		public function get isSuggestionsVisible():Boolean
		{
			return _commandSuggestion.visible;
		}

		public function set isSuggestionsVisible(value:Boolean):void
		{
			_commandSuggestion.visible = value;
		}

		public function get isRefSelected():Boolean
		{
			return !!_currentSelection.text;
		}

		public function get menu():MovieClip
		{
			return _menu;
		}

		public function get f4se():Object
		{
			return _f4se;
		}

		public function get codeObject():Object
		{
			return _codeObject;
		}

		public function get commandEntry():TextField
		{
			return _commandEntry;
		}

		public function get commandSuggestions():TextField
		{
			return _commandSuggestion;
		}

		public function get commands():ScriptStore
		{
			return _commands;
		}

		public function get commandIterator():ScriptIterator
		{
			return _commandIterator;
		}

		public function get commandParser():ScriptParser
		{
			return _commandParser;
		}

		public function get settings():Settings
		{
			return _settings;
		}

		public function nextSuggestion():void
		{
			_commandIterator.increment();
			updateSuggestionText();
		}

		public function previousSuggestion():void
		{
			_commandIterator.decrement();
			updateSuggestionText();
		}

		public function pasteSuggestion():void
		{
			if (_commandIterator.isEmpty)
			{
				return;
			}

			var lastIndex:int = _commandEntry.text.length - _commandParser.last.func.length;
			var command:String = _commandEntry.text.substring(0, lastIndex);

			_commandEntry.text = command + _commandIterator.current.name;
			_commandEntry.setSelection(_commandEntry.text.length, _commandEntry.text.length);

			updateSuggestions();
		}

		public function updateSuggestions():void
		{
			_commandParser.text = _commandEntry.text;

			if (_commandParser.isEmpty)
			{
				clearSuggestion();
				return;
			}

			var includeRefs:Boolean = isRefSelected || _commandParser.last.hasRef;

			_commandIterator = _commands.find(_commandParser.last.func, includeRefs);
			_commandIterator.sort();

			updateSuggestionText();
		}

		public function updateSuggestionText():void
		{
			if (_commandIterator.isEmpty)
			{
				clearSuggestion();
				return;
			}

			var nameIndex:int = _commandParser.last.func.length;
			var paramIndex:int = _commandParser.last.argIndex;
			var suggestion:String = _commandIterator.current.format(nameIndex, paramIndex);

			_commandSuggestion.wordWrap = false;
			_commandSuggestion.htmlText = _commandParser.last.func + suggestion;
			_commandSuggestion.wordWrap = _commandSuggestion.textWidth > _displayWidth - _commandSuggestion.x;
			_commandSuggestion.width = _displayWidth - _commandSuggestion.x;
		}

		public function clearSuggestion():void
		{
			_commandIterator.clear();

			_commandSuggestion.text = "";
			_commandSuggestion.wordWrap = false;
		}

		public function clear():void
		{
			clearSuggestion();
			_commandParser.clear();

			isSuggestionsVisible = true;
		}

		private function onSettingsLoadComplete(settings:Settings):void
		{
			trace("ConsoleAutocomplete: Settings loaded");

			_settings = settings;

			if (stage)
			{
				setup();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
		}

		private function onSettingsLoadFail(settings:Settings):void
		{
			trace("ConsoleAutocomplete: Failed to load settings");

			_settings = settings;

			if (stage)
			{
				setup();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
		}

		private function onAddedToStage(event:Event):void
		{
			setup();
		}

		private function setup():void
		{
			trace("ConsoleAutocomplete: Setup");

			setupVariables();
			setupTextFields();

			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function setupVariables():void
		{
			Extensions.enabled = true;

			_displayWidth = stage.stageWidth;
			_displayHeight = stage.stageHeight;

			_root = stage.getChildAt(0) as MovieClip;
			_menu = parent.parent as MovieClip;

			_f4se = _root["f4se"];
			_codeObject = _f4se["plugins"]["consoleAutocomplete"];

			var commands:Array = _codeObject["getCommands"]();

			_commandParser = new ScriptParser();
			_commands = new ScriptStore();

			for each (var command:Object in commands)
			{
				_commands.add(new ScriptFunction(
							command["name"], command["description"], command["requiresRef"], command["params"]));
			}

			_commands.add(ScriptFunction.PLAYER);
		}

		private function setupTextFields():void
		{
			_currentSelection = _menu["CurrentSelection"];
			_commandPrompt = _menu["CommandPrompt_tf"];
			_commandEntry = _menu["CommandEntry"];

			_commandPrompt.type = TextFieldType.DYNAMIC;
			_commandEntry.tabEnabled = false;

			var format:TextFormat = new TextFormat();
			format.font = _commandEntry.defaultTextFormat.font;
			format.size = _commandEntry.defaultTextFormat.size;
			format.color = _commandEntry.defaultTextFormat.color;

			_commandSuggestion = new TextField();
			_commandSuggestion.defaultTextFormat = _commandEntry.defaultTextFormat;
			_commandSuggestion.text = "";
			_commandSuggestion.autoSize = TextFieldAutoSize.LEFT;

			_commandSuggestion.alpha = settings.suggestionAlpha;
			_commandSuggestion.background = settings.suggestionHasBackground;
			_commandSuggestion.backgroundColor = _settings.suggestionBackgroundColor;

			_commandSuggestion.x = _commandEntry.x;
			_commandSuggestion.y = _commandEntry.y;

			TextFieldEx.setNoTranslate(_commandSuggestion, true);
			TextFieldEx.setVerticalAutoSize(_commandSuggestion, TextFieldEx.VALIGN_CENTER);
			TextFieldEx.setVerticalAlign(_commandSuggestion, TextFieldEx.VALIGN_BOTTOM);

			_commandSuggestion.selectable = false;
			_commandSuggestion.mouseEnabled = false;

			_menu.addChild(_commandSuggestion);
			_menu.addEventListener(Event.RESIZE, onMenuResize);

			_commandEntry.addEventListener(Event.CHANGE, onCommandEntryChange);
			_commandEntry.addEventListener(KeyboardEvent.KEY_DOWN, onCommandEntryKeyDown);
			_commandEntry.addEventListener(KeyboardEvent.KEY_UP, onCommandEntryKeyUp);
		}

		private function onMenuResize(event:Event):void
		{
			_commandSuggestion.width = _commandEntry.width;
			_commandSuggestion.height = _commandEntry.height;
		}

		private function onCommandEntryChange(event:Event):void
		{
			updateSuggestions();
		}

		private function onCommandEntryKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				// This doesn't seem to fire on key up,
				// so it's done here instead.
				case _settings.consoleClose:
					clear();
					break;
				case _settings.suggestionNext:
					nextSuggestion();
					break;
				case _settings.suggestionPrevious:
					previousSuggestion();
					break;
				case _settings.suggestionPaste:
					if (_commandEntry.selectionEndIndex == _commandEntry.text.length)
					{
						pasteSuggestion();
					}
					break;
			}
		}

		private function onCommandEntryKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				// Up and Down don't fire on key down,
				// so the suggestion is updated here.
				case _settings.commandUp:
				case _settings.commandDown:
					updateSuggestions();
					break;
				case _settings.commandExecute:
				case _settings.commandExecuteSecondary:
					if (StringUtils.isWhitespace(_commandEntry.text))
					{
						event.stopImmediatePropagation();
						_menu["ResetCommandEntry"]();
					}

					clear();
					break;
				case _settings.suggestionToggle:
					isSuggestionsVisible = !isSuggestionsVisible;
					break;
			}
		}
	}
}
