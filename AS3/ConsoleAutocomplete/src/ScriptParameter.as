package
{
	internal final class ScriptParameter
	{
		private var _name:String;

		public function ScriptParameter(name:String)
		{
			_name = name;
		}

		public function get name():String
		{
			return _name;
		}

		public function toString():String
		{
			return ColorStyles.format(_name, ColorStyles.PARAMETER);
		}
	}
}