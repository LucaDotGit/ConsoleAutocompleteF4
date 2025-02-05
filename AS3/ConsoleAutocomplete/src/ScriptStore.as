package
{
	internal final class ScriptStore
	{
		private var _scripts:Object;

		public function ScriptStore()
		{
			clear();
		}

		public function contains(name:String):Boolean
		{
			return _scripts.hasOwnProperty(name.toLowerCase());
		}

		public function getValue(name:String):ScriptFunction
		{
			return _scripts[name.toLowerCase()];
		}

		public function setValue(name:String, script:ScriptFunction):void
		{
			_scripts[name.toLowerCase()] = script;
		}

		public function add(script:ScriptFunction):void
		{
			_scripts[script.name.toLowerCase()] = script;
		}

		public function remove(name:String):void
		{
			delete _scripts[name.toLowerCase()];
		}

		public function clear():void
		{
			_scripts = {};
		}

		public function find(command:String, includeRefs:Boolean = false):ScriptIterator
		{
			var list:Vector.<ScriptFunction> = new Vector.<ScriptFunction>();

			for each (var script:ScriptFunction in _scripts)
			{
				if (!includeRefs && script.requiresRef)
				{
					continue;
				}

				if (!command || StringUtils.startsWithIgnoreCase(script.name, command))
				{
					list.push(script);
				}
			}

			return new ScriptIterator(list);
		}
	}
}