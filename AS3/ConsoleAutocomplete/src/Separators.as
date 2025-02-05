package
{
	public final class Separators
	{
		public static const FUNCTION:String = ".";
		public static const PARAMETER:String = ",";
		public static const LINE:String = ";";
		public static const COMMENT:String = "//";
		public static const QUOTE:String = "\"";
		public static const WHITESPACE:String = " ";

		public static function get FUNCTION_PATTERN():RegExp
		{
			// Match a period that is not surrounded by digits.
			return /(?<!\s\d)\s*\.\s*(?!\d)/g;
		}

		public static function get PARAMETER_PATTERN():RegExp
		{
			// Match a comma that is not surrounded by spaces.
			return /\s*,\s*/g;
		}

		public static function get LINE_PATTERN():RegExp
		{
			// Match a semicolon that is not surrounded by spaces.
			return /\s*;\s*/g;
		}

		public static function get QUOTE_PATTERN():RegExp
		{
			// Match a quote that is not surrounded by spaces.
			return /\s*\".*?\"\s*/g;
		}
	}
}
