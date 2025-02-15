package
{
	public final class ColorStyles
	{
		public static const FUNCTION:uint = 0xDCDCAA;
		public static const PARAMETER:uint = 0x9CDCFE;
		public static const COMMENT:uint = 0x6A9955;

		public static const HTML_ENTITIES:Object = {
			"<": "&lt;",
			">": "&gt;"
		};

		public static function format(text:String, color:uint):String
		{
			var sanitizedText:String = sanitizeText(text);
			return "<font color='#" + color.toString(16) + "'>" + sanitizedText + "</font>";
		}

		public static function sanitizeText(text:String):String
		{
			var sanitizedText:String = text;

			for (var entity:String in HTML_ENTITIES)
			{
				var replacement:String = HTML_ENTITIES[entity];
				var pattern:RegExp = new RegExp(entity, "g");

				sanitizedText = sanitizedText.replace(pattern, replacement);
			}

			return sanitizedText;
		}
	}
}