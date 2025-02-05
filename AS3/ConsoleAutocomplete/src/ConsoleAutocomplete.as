package
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.*;

	public final class ConsoleAutocomplete extends MovieClip
	{
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

		public function ConsoleAutocomplete()
		{
			trace("ConsoleAutocomplete is starting...");

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function get isRefSelected():Boolean
		{
			return !!_currentSelection.text;
		}

		public function get currentEntry():ScriptEntry
		{
			return _commandParser.last;
		}

		public function get selectedCommand():ScriptFunction
		{
			return _commandIterator.current;
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

			var lastIndex:int = _commandEntry.text.length - currentEntry.func.length;
			var entry:String = _commandEntry.text.substring(0, lastIndex);

			_commandEntry.text = entry + selectedCommand.name;
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

			var includeRefs:Boolean = isRefSelected || currentEntry.hasRef;

			_commandIterator = _commands.find(currentEntry.func, includeRefs);
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

			var nameIndex:int = currentEntry.func.length;
			var paramIndex:int = currentEntry.argIndex;

			var suggestion:String = selectedCommand.format(nameIndex, paramIndex);
			_commandSuggestion.htmlText = currentEntry.func + suggestion;
		}

		public function clearSuggestion():void
		{
			_commandSuggestion.text = "";
			_commandIterator.clear();
		}

		public function clear():void
		{
			clearSuggestion();
			_commandParser.clear();
		}

		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			setupVariables();
			setupTextFields();
		}

		private function setupVariables():void
		{
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

			_commandSuggestion = new TextField();
			_commandSuggestion.x = _commandEntry.x;
			_commandSuggestion.y = _commandEntry.y - _commandEntry.height / 1.75;

			_commandSuggestion.defaultTextFormat = _commandEntry.defaultTextFormat;
			_commandSuggestion.background = true;
			_commandSuggestion.backgroundColor = 0x000000;

			_commandSuggestion.selectable = false;
			_commandSuggestion.mouseEnabled = false;

			_commandSuggestion.autoSize = TextFieldAutoSize.LEFT;

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
				case Keyboard.BACKQUOTE:
					clear();
					break;
				case Keyboard.TAB:
					nextSuggestion();
					break;
				case Keyboard.CONTROL:
					previousSuggestion();
					break;
				case Keyboard.RIGHT:
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
				case Keyboard.UP:
				case Keyboard.DOWN:
					updateSuggestions();
					break;
				case Keyboard.ENTER:
				case Keyboard.NUMPAD_ENTER:
					if (StringUtils.isWhitespace(_commandEntry.text))
					{
						event.stopImmediatePropagation();
						_menu["ResetCommandEntry"]();
					}

					clear();
					break;
			}
		}
	}
}
