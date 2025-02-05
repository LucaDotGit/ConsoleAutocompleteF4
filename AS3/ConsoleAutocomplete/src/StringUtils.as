package
{
	public final class StringUtils
	{
		public static function isWhitespace(value:String):Boolean
		{
			return /^\s*$/.test(value);
		}

		public static function compareIgnoreCase(left:String, right:String):int
		{
			return left.toLowerCase().localeCompare(right.toLowerCase());
		}

		public static function startsWithIgnoreCase(value:String, substring:String):Boolean
		{
			return value.toLowerCase().indexOf(substring.toLowerCase()) == 0;
		}

		public static function trim(value:String):String
		{
			return value.replace(/^\s+|\s+$/g, "");
		}

		public static function substringBy(value:String, separator:*):String
		{
			var index:int = value.search(separator);
			return index < 0 ? value : value.substring(0, index);
		}

		public static function splitBy(value:String, separator:*):Array
		{
			var parts:Array = value.split(separator);

			if (parts.length < 2)
			{
				return parts;
			}

			var first:String = parts.shift();
			var second:String = parts.join(separator);

			return [first, second];
		}
	}
}