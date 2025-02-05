package
{
	internal final class ScriptFunction
	{
		public static const PLAYER:ScriptFunction = new ScriptFunction("Player", "The reference to the player.", false, []);

		private var _name:String;
		private var _description:String;
		private var _requiresRef:Boolean;
		private var _params:Vector.<ScriptParameter>;

		public function ScriptFunction(name:String, description:String, requiresRef:Boolean, params:Array)
		{
			_name = name;
			_description = description;
			_requiresRef = requiresRef;

			_params = new Vector.<ScriptParameter>(params.length, true);

			for (var i:uint = 0; i < params.length; i++)
			{
				var param:Object = params[i];
				_params[i] = new ScriptParameter(param.name);
			}
		}

		public function get name():String
		{
			return _name;
		}

		public function get description():String
		{
			return _description;
		}

		public function get requiresRef():Boolean
		{
			return _requiresRef;
		}

		public function get paramCount():uint
		{
			return _params.length;
		}

		public function getNthParam(index:uint):ScriptParameter
		{
			return _params[index];
		}

		public function toString():String
		{
			return _name;
		}

		public function format(nameIndex:int = -1, paramIndex:int = -1):String
		{
			var name:String = formatName(nameIndex);
			var params:String = formatParams(paramIndex);
			var description:String = formatDescription();

			return name +
				(params ? Separators.WHITESPACE + params : params) +
				(description ? Separators.WHITESPACE + description : description);
		}

		private function formatName(index:int = -1):String
		{
			if (index < 0)
			{
				return _name;
			}

			var name:String = _name.substring(index);

			if (name.length == 0)
			{
				return "";
			}

			return ColorStyles.format(name, ColorStyles.FUNCTION);
		}

		private function formatParams(index:int = -1):String
		{
			var params:String = "";

			for (var i:uint = 0; i < _params.length; i++)
			{
				var param:ScriptParameter = _params[i];
				params += i > index ? ColorStyles.format(param.name, ColorStyles.PARAMETER) : param.name;

				if (i < _params.length - 1)
				{
					params += Separators.PARAMETER + Separators.WHITESPACE;
				}
			}

			return params;
		}

		private function formatDescription():String
		{
			if (!_description)
			{
				return "";
			}

			var description:String = Separators.COMMENT + Separators.WHITESPACE + _description;
			return ColorStyles.format(description, ColorStyles.COMMENT);
		}
	}
}