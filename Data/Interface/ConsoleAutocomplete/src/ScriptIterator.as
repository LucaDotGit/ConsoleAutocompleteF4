package
{
	internal final class ScriptIterator
	{
		private var _scripts:Vector.<ScriptFunction>;
		private var _index:int;

		public function ScriptIterator(scripts:Vector.<ScriptFunction>)
		{
			_scripts = scripts;
			reset();
		}

		public function get isEmpty():Boolean
		{
			return _scripts.length == 0;
		}

		public function hasNext():Boolean
		{
			return _index + 1 < _scripts.length;
		}

		public function hasPrevious():Boolean
		{
			return _index - 1 > 0;
		}

		public function get current():ScriptFunction
		{
			return isEmpty ? null : _scripts[_index];
		}

		public function next():ScriptFunction
		{
			increment();
			return current;
		}

		public function previous():ScriptFunction
		{
			decrement();
			return current;
		}

		public function increment():void
		{
			if (isEmpty)
			{
				return;
			}

			_index = (_index + 1) % _scripts.length;
		}

		public function decrement():void
		{
			if (isEmpty)
			{
				return;
			}

			_index = (_index - 1 + _scripts.length) % _scripts.length;
		}

		public function sort():void
		{
			_scripts.sort(function(a:ScriptFunction, b:ScriptFunction):int
			{
				return StringUtils.compareIgnoreCase(a.name, b.name);
			});
		}

		public function reset():void
		{
			_index = isEmpty ? -1 : 0;
		}

		public function clear():void
		{
			_scripts.length = 0;
			reset();
		}

		public function toString():String
		{
			return isEmpty ? "" : current.toString();
		}
	}
}