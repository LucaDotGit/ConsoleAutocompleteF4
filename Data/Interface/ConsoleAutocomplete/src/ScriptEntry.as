package
{
	internal final class ScriptEntry
	{
		private var _ref:String;
		private var _func:String;
		private var _args:Array;

		public function ScriptEntry(ref:String, func:String, args:Array)
		{
			_ref = ref;
			_func = func;
			_args = args;
		}

		public function get hasRef():Boolean
		{
			return !!_ref;
		}

		public function get ref():String
		{
			return _ref;
		}

		public function get func():String
		{
			return _func;
		}

		public function get argIndex():int
		{
			return _args.length - 2;
		}

		public function get argCount():uint
		{
			return _args.length;
		}

		public function getArgAt(index:uint):String
		{
			return _args[index];
		}

		public function toString():String
		{
			var ref:String = _ref ? _ref + Separators.FUNCTION : "";
			var args:String = _args.length > 0 ? " " + _args.join(Separators.PARAMETER + " ") : "";
			return ref + _func + args;
		}
	}
}