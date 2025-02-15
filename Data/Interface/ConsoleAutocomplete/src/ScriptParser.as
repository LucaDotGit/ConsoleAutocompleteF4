package
{
	internal final class ScriptParser
	{
		private var _text:String;
		private var _commands:Vector.<ScriptEntry>;

		public function ScriptParser(text:String = "")
		{
			this.text = text;
		}

		public function get isEmpty():Boolean
		{
			return _commands.length == 0;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
			_commands = new Vector.<ScriptEntry>();

			if (StringUtils.isWhitespace(_text))
			{
				return;
			}

			var commands:Array = StringUtils.trim(value)
				.replace(Separators.QUOTE_PATTERN, " ")
				.split(Separators.LINE_PATTERN);

			for each (var command:String in commands)
			{
				var commandParts:Array = StringUtils.splitBy(command, Separators.FUNCTION_PATTERN);

				var funcPart:String = commandParts.length < 2 ? commandParts[0] : commandParts[1];
				var func:String = StringUtils.substringBy(funcPart, " ");

				var args:Array = StringUtils.trim(funcPart.substring(func.length))
					.split(Separators.PARAMETER_PATTERN);

				var ref:String = commandParts.length < 2 ? "" : commandParts[0];
				var entry:ScriptEntry = new ScriptEntry(ref, func, args);

				_commands.push(entry);
			}
		}

		public function get count():int
		{
			return _commands.length;
		}

		public function get first():ScriptEntry
		{
			return _commands[0];
		}

		public function get last():ScriptEntry
		{
			return _commands[_commands.length - 1];
		}

		public function getAt(index:int):ScriptEntry
		{
			return _commands[index];
		}

		public function clear():void
		{
			_text = "";
			_commands = new Vector.<ScriptEntry>();
		}

		public function toString():String
		{
			return _commands.join(Separators.LINE);
		}
	}
}